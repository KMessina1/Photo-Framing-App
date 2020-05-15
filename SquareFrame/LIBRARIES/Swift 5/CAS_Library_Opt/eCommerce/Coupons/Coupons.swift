/*--------------------------------------------------------------------------------------------------------------------------
    File: Coupons.swift
  Author: Kevin Messina
 Created: October 3, 2017
 
©2017-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: for Alamo Codable, For array: DataResponse<[Repo]>, for single object: DataResponse<Repo>
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** PUBLIC CONSTANTS ***


// MARK: - *** CUSTOM CLASS ***
class Coupons:NSObject {
    var Version: String { return "1.06" }

    var AlamoManager:Alamofire.SessionManager = Alamofire.SessionManager.init()
    var AlamoConfig:URLSessionConfiguration = URLSessionConfiguration.default

// MARK: - *** FUNCTIONS ***
// MARK: - === COUPONS ===
    var isOrderFree:Bool {
        // If no coupon, exit
        guard order.couponID > 0,
            let type:Int = Coupons.couponType.arr.firstIndex(of: selectedCoupon.type),
            let scope:Int = Coupons.couponScope.arr.firstIndex(of: selectedCoupon.scope)
        else { return false  }

        let entireOrderIsFree:Bool = (
            (type == Coupons.couponType.free.rawValue) &&
            (scope == Coupons.couponScope.entireOrder.rawValue)
        )

        return entireOrderIsFree
    }
    
    func calculateDiscount() -> (hasDiscount:Bool,entireOrderIsFree:Bool,amount:Double) {
        // If no coupon, exit
        guard (order.couponID > 0),
            let type:Int = Coupons.couponType.arr.firstIndex(of: selectedCoupon.type),
            let scope:Int = Coupons.couponScope.arr.firstIndex(of: selectedCoupon.scope)
        else {
          return (hasDiscount:false, entireOrderIsFree:false, amount:0.00)
        }

        let items = localCart.items
        
        var hasDiscount:Bool = false
        var discount:Double = 0.00
        let entireOrderIsFree:Bool = Coupons().isOrderFree

        /* Force 2 decimal point Currency accuracy */
        order.subtotal = Decimal(String(format:"%0.2f", order.subtotal.doubleValue).doubleValue)
        order.totalAmt = Decimal(String(format:"%0.2f", order.totalAmt.doubleValue).doubleValue)
        order.shippingAmt = Decimal(String(format:"%0.2f", order.shippingAmt.doubleValue).doubleValue)
        let entireOrder:Double = String(format:"%0.2f", (order.subtotal.doubleValue + order.shippingAmt.doubleValue)).doubleValue
        
        /* Is Entire Order Free? */
        if entireOrderIsFree {
            discount = entireOrder
            order.totalAmt = 0.00
        } else {
            switch Coupons.couponType(rawValue: type) {
                case .free?: ()
                    switch Coupons.couponScope(rawValue: scope) {
                        case .mostExpensiveItem?: discount = (items!.sorted(by: { $0.price > $1.price }).first?.price)?.doubleValue ?? 0.00
                        case .allItems?: discount = order.subtotal.doubleValue
                        case .shipping?: discount = order.shippingAmt.doubleValue
                        case .entireOrder?: discount = entireOrder
                        default: ()
                    }
                case .discount?:
                    let discountPercentage:Double = (selectedCoupon.discount.doubleValue * 0.01)

                    switch Coupons.couponScope(rawValue: scope) {
                        case .mostExpensiveItem?:
                            let mostExpensiveItem = items?.sorted(by: { $0.price > $1.price }).first?.price ?? 0.00
                            discount = (mostExpensiveItem.doubleValue * discountPercentage)
                        case .allItems?: discount = (order.subtotal.doubleValue * discountPercentage)
                        case .shipping?: discount = (order.shippingAmt.doubleValue * discountPercentage)
                        case .entireOrder?: discount = (entireOrder * discountPercentage)
                        default: ()
                    }
                default: ()
            }
        }

        /* Set Values */
        hasDiscount = (discount > 0.00)
        order.discountAmt = Decimal(String(format:"%0.2f", discount).doubleValue)

        /* Return results */
        return (hasDiscount:hasDiscount, entireOrderIsFree:entireOrderIsFree, amount:order.discountAmt.doubleValue)
    }
    
    func isValid(coupon:Coupons.couponStruct, completion: @escaping (Bool,String) -> Void) {
        let expired = "Coupon.Expired".localizedCAS()
        let notFound = "Coupon.NotFound".localizedCAS()
        let invalid = "Coupon.Invalid".localizedCAS()
        let inActive = "Coupon.Inactive".localizedCAS()
        let limitOnePer = "Coupon.LimitOnePer".localizedCAS()

        let today = "\(Date().yearNum)-\(Date().MonthNum())-\(Date().DayNum())".convertToDate(format: kDateFormat.yyyyMMdd)
        let expDate = coupon.expiration_date.convertToDate(format: kDateFormat.yyyyMMdd)

        if coupon.status.boolValue == false {
            completion(false, "\(coupon.code.capitalized.removeSpaces)\n\n\(inActive)")
        }else if coupon.code.isEmpty {
            completion(false, "\(coupon.code.capitalized.removeSpaces)\n\n\(notFound)")
        }else if coupon.remaining_qty.intValue < 1 {
            completion(false, "\(coupon.code.capitalized.removeSpaces)\n\n\(invalid)")
        }else if expDate.lessThan(date: today) == true {
            completion(false, "\(coupon.code.capitalized.removeSpaces)\n\n\(expired)")
        }else if coupon.limit_one_per.boolValue == true {
            Coupons.REDEMPTIONS().alreadyUsed(couponID: coupon.id,customerID: "\(order.customerID)", completion: { (alreadyUsed,error) in
                if alreadyUsed { // that means already redeemed, so its unavailable to be used here, again.
                    completion(false,"\(coupon.code.capitalized.removeSpaces)\n\n\(limitOnePer)")
                }else{
                    completion(true,"")
                }
            })
        }else{
            completion(true, "")
        }
    }
    
    func search(coupon_code:String, coupon_ID:Int? = 0, showMsg:Bool? = true, completion: @escaping (Bool, Coupons.couponStruct) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,Coupons.couponStruct.init()) }

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(serverScriptNames.COUPONS.search)")
        else { return completion(false,Coupons.couponStruct.init()) }

        let params:Alamofire.Parameters = [
            "code":coupon_code,
            "id":coupon_ID!,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]

        if showMsg! { waitHUD().showNow(msg: "Validating Coupon...") } 
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Coupons.couponStruct]>) in
            if showMsg! { waitHUD().hideNow() }
            Server().dumpURLfromDecodableResponse(responseRequestURL: response.request!.url!.absoluteString)
            
            let found = ((response.result.value?.count ?? 0) > 0)
            completion(found,found ?response.result.value!.first! :Coupons.couponStruct.init())
        }
    }

    func list(completion: @escaping (Bool, [Coupons.couponStruct]) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[]) }
        
        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(serverScriptNames.COUPONS.list)")
        else { return completion(false,[]) }

        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        waitHUD().showNow(msg: "Getting Coupons...") 
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Coupons.couponStruct]>) in
            Server().dumpURLfromDecodableResponse(responseRequestURL: response.request!.url!.absoluteString)

            if response.result.isSuccess {
                completion(true,response.result.value!)
            }else{
                sharedFunc.ALERT().show(
                    title:"coupon.error_Title".localized(),
                    style:.error,
                    msg:"coupon.error_Msg".localized()
                )
                completion(false,[])
            }

            waitHUD().hideNow()
        }
    }
    
    func delete(id:String, code:String, completion: @escaping (Bool) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptTitle = serverScriptNames.COUPONS.delete
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(scriptTitle)")
        else { return completion(false) }
        
        let params:Alamofire.Parameters = [
            "id":Int(id)!,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]

        waitHUD().showNow(msg: "Deleting Coupon...") 
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()

            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptTitle)
            
            sharedFunc.ALERT().show(
                title: results.success
                    ?"coupon.error.Delete_Title".localized()
                    :"error.unkown_Title".localized(),
                style:.error,
                msg: results.success
                    ?"\n\(code)\n"
                    :"coupon.error.Delete_Title".localizedCAS()
            )
            
            completion(results.success)
        })
    }
    
    func insertOrUpdate(isEdit:Bool, code:String, coupon:Coupons.couponStruct, completion: @escaping (Bool) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false) }
        
        let scriptTitle = isEdit ?serverScriptNames.COUPONS.update
                                 :serverScriptNames.COUPONS.add

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(scriptTitle)")
        else { return completion(false) }
        
        var params:Alamofire.Parameters = coupon.params!
            params.updateValue(Bundle.main.fullVer, forKey: "appVersion")
            params.updateValue(appInfo.EDITION.appEdition!, forKey: "calledFromApp")

        waitHUD().showNow(msg: "\(isEdit ?"Updating" :"Adding") Coupon") 
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptTitle)
            
            if results.success {
                var msg = "\n\(code.trimDoubleApostrophes)\n"
                if code.hasSuffix("_copy") {
                    msg = """
                         There was a duplicate already with that CODE. Saved with suffix '_copy'.
                         \nEdit Coupon to change the CODE.
                         \n\(code.trimDoubleApostrophes)
                         """
                }

                if isEdit {
                    if let record = results.records.first,
                       let limit_qty = record["limit_qty"] as? String,
                       let redeemed_qty = record["redeemed_qty"] as? String {

                        if limit_qty.intValue == redeemed_qty.intValue {
                            sharedFunc.ALERT().show(
                                title:"LIMIT < REDEEMED WARNING",
                                style:.error,
                                msg:"Limit was changed to less than Redeemed number. Limit was automatically changed to Redeemed. That means this coupon is now Invalid as there are 0 Available."
                            )
                            if isSim { print("LIMIT < REDEEMED WARNING Limit was changed to less than Redeemed number. Limit was automatically changed to Redeemed. That means this coupon is now Invalid as there are 0 Available.") }
                        }
                    }
                }

                sharedFunc.ALERT().show(
                    title:"COUPON \(isEdit ? "UPDATED" :"ADDED")",
                    style:.error,
                    msg:msg
                )
                if isSim { print("COUPON \( isEdit ? "UPDATED" :"ADDED" ) - \( msg )") }
                completion(true)
            }else{
                sharedFunc.ALERT().show(
                    title:"COUPON ERROR",
                    style:.error,
                    msg:"Error \(isEdit ?"UPDATING" :"ADDING") Coupon from server."
                )
                if isSim { print("COUPON ERROR \( "Error \(isEdit ?"UPDATING" :"ADDING") Coupon from server." )") }
                completion(false)
            }
        })
    }

    
//MARK: - === REDEMPTIONS ===
    struct REDEMPTIONS {
        func insert(redemption:Coupons.redemptionStruct, completion: @escaping (Bool,orderError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.none) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.REDEMPTIONS.add
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(scriptName)")
            else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }

            waitHUD().updateNow(msg: "Adding Coupon")

            let params:Alamofire.Parameters = [
                "date":redemption.date!,
                "coupon_code":redemption.coupon_code!,
                "coupon_id":redemption.coupon_id!,
                "coupon_value":redemption.coupon_value!,
                "order_num":redemption.order_num!,
                "customer_name":redemption.customer_name!,
                "customer_num":redemption.customer_num!,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp":appInfo.EDITION.appEdition!
            ]

            Server().dumpParams(params)
            
           
            Alamofire.request(scriptURL, parameters: params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseJSON(completionHandler: { response in
                Server().dumpURLfromResponse(response)

                switch response.result {
                case .success:
                    let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                    results.success
                        ?completion(true,.none)
                        :completion(false,.redemption_NotAdded(couponCode: "Coupon Code:\(redemption.coupon_code ?? "n/a") for order #\(redemption.order_num ?? "n/a") FAILED to add Redemption."))
                case .failure(let error):
                    if let err = response.result.error as? AFError {
                        Server().displayAlamoFireError(err,scriptTitle: scriptName)
                    }else{
                        simPrint().error("|--> \( scriptName ) Failed: \( error._code )\n\n\( error.localizedDescription) )",function:#function,line:#line)
                    }

                    completion(false,.alamoFire_failed(error: "\(scriptName)\n\nFailed: \(error._code)\n\n\(error.localizedDescription)"))
                }
            })
        }
        
        func alreadyUsed(couponID:String, customerID:String, completion: @escaping (Bool,orderError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }

            let scriptName = serverScriptNames.REDEMPTIONS.used
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(scriptName)")
            else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }

            let params:Alamofire.Parameters = [
                "couponID":couponID,
                "customerID":customerID,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp":appInfo.EDITION.appEdition!
            ]

            URLCache.shared.removeAllCachedResponses()
            waitHUD().updateNow(msg: "Verifying Coupon Not Used Already") 

            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters: params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseJSON(completionHandler: { response in
                waitHUD().hideNow()
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)

                switch response.result {
                case .success:
                    completion(results.success,.none)
                case .failure(let error):
                    if let err = response.result.error as? AFError {
                        Server().displayAlamoFireError(err,scriptTitle: scriptName)
                    }else{
                        simPrint().error("|--> \( scriptName ) Failed: \( error._code )\n\n\( error.localizedDescription ))",function:#function,line:#line)
                    }

                    completion(false,.alamoFire_failed(error: "\(scriptName)\n\nFailed: \(error._code)\n\n\(error.localizedDescription)"))
                }
            })
        }

        func list(completion: @escaping (Bool, [Coupons.redemptionStruct]) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[]) }

            URLCache.shared.removeAllCachedResponses()
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.coupons!)/\(serverScriptNames.REDEMPTIONS.list)")
            else { return completion(false,[]) }

            let params:Alamofire.Parameters = [
                "appVersion":Bundle.main.fullVer,
                "calledFromApp":appInfo.EDITION.appEdition!
            ]
            
            waitHUD().showNow(msg: "Getting Redemptions...") 
            Server().dumpParams(params)

            Alamofire.request(scriptURL, parameters:params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Coupons.redemptionStruct]>) in
                if response.result.isSuccess {
                    completion(true,response.result.value!)
                }else{
                    sharedFunc.ALERT().show(
                        title:"REDEMPTION ERROR",
                        style:.error,
                        msg:"Error Getting Redemptions from server."
                    )
                    completion(false,[])
                }

                waitHUD().hideNow()
            }
        }
    }
    
    
// MARK: - *** STRUCTS ***
    enum couponScope:Int,Codable { case undefined,mostExpensiveItem,allItems,shipping,entireOrder
        static let arr:[String] = ["undefined","most expensive item","all items","shipping","entire order"]
        static let count:Int = arr.count
    }
    
    enum couponType:Int,Codable { case undefined,discount,free
        static let arr:[String] = ["undefined","discount","free"]
        static let count:Int = arr.count
    }

    struct couponStruct:Codable,Loopable {
        var id:String // Primary Index.
        var created_date:String // Coupon creation Date in YYYY-MM-DD format.
        var code:String // Redemption Code for Coupon. Should always be unique.
        var name:String // Name of coupon.
        var description:String // Description and notes for coupon.
        var limit_qty:String // Number of total possible redemptions.
        var redeemed_qty:String // Number of redeemed coupons.
        var remaining_qty:String // Number of redemptions remaining available.
        var effective_date:String // Start Date in YYYY-MM-DD format.
        var expiration_date:String // End Date in YYYY-MM-DD format.
        var discount:String // Percentage 0 -> 100
        var type:String // Discount or Free?
        var scope:String // How coupon is applied to order.
        var limit_one_per:String // Bool for Limit redemption to 1 per customer number.
        var status:String // Bool for active or not.

        init (
            id:String? = "",
            created_date:String? = "",
            code:String? = "",
            name:String? = "",
            description:String? = "",
            limit_qty:String? = "",
            redeemed_qty:String? = "",
            remaining_qty:String? = "",
            effective_date:String? = "",
            expiration_date:String? = "",
            discount:String? = "",
            type:String? = "",
            scope:String? = "",
            limit_one_per:String? = "",
            status:String? = ""
        ){
            self.id = id!
            self.created_date = created_date!
            self.code = code!
            self.name = name!
            self.description = description!
            self.limit_qty = limit_qty!
            self.redeemed_qty = redeemed_qty!
            self.remaining_qty = remaining_qty!
            self.effective_date = effective_date!
            self.expiration_date = expiration_date!
            self.discount = discount!
            self.type = type!
            self.scope = scope!
            self.limit_one_per = limit_one_per!
            self.status = status!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "created_date" : created_date,
                "code" : code,
                "name" : name,
                "description" : description,
                "limit_qty" : limit_qty,
                "redeemed_qty" : redeemed_qty,
                "remaining_qty" : remaining_qty,
                "effective_date" : effective_date,
                "expiration_date" : expiration_date,
                "discount" : discount,
                "type" : type,
                "scope" : scope,
                "limit_one_per" : limit_one_per,
                "status" : status
            ]
        }
    }
    
    struct redemptionStruct:Codable,Loopable {
        var id:String!  // Primary Index
        var date:String! // Redemption Date in YYYY-MM-DD format.
        var coupon_code:String! // Coupon table column code. Use id as link as the CODE can be changed and may not match.
        var coupon_id:String! // Link back to Coupon table column id primary index.
        var coupon_value:String! // Amount that this coupon results in to order (for Marketing Expense & tax purposes).
        var order_num:String! // Moltin Order Number that this coupon was redeemed against.
        var customer_name:String! // Redemption Customer name
        var customer_num:String! // Redemption Customer Number

        init (
            id:String? = "",
            date:String? = "",
            coupon_code:String? = "",
            coupon_id:String? = "",
            coupon_value:String? = "",
            order_num:String? = "",
            customer_name:String? = "",
            customer_num:String? = ""
        ){
            self.id = id!
            self.date = date!
            self.coupon_code = coupon_code!
            self.coupon_id = coupon_id!
            self.coupon_value = coupon_value!
            self.order_num = order_num!
            self.customer_name = customer_name!
            self.customer_num = customer_num!
        }

        var params:Alamofire.Parameters? {
            return [
                "date" : date!,
                "coupon_code" : coupon_code!,
                "coupon_id" : coupon_id!,
                "coupon_value" : coupon_value!,
                "order_num" : order_num!,
                "customer_name" : customer_name!,
                "customer_num" : customer_num!
            ]
        }
    }
}



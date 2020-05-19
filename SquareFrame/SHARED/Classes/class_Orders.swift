/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Orders.swift
   Author: Kevin Messina
  Created: Apr 6, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class Orders:NSObject {
    let Version:String = "1.01"
    let name:String = "Orders"

// MARK: - *********************************************************
// MARK: CLASS: TEST RECORDS
// MARK: *********************************************************
    struct TEST:Codable,Loopable {
        static let customerID_1:Int = 90 // Kevin - Link to order primary Index
        static let customerID_2:Int = 91 // Stephen - Link to order primary Index
        static let orderID:Int = 90 // Link to order primary Index
        static let orderID2:Int = 91 // Link to order primary Index
    }
    
    
// MARK: - *********************************************************
// MARK: CLASS: FUNCTIONS
// MARK: *********************************************************
    func addOrder(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters, completion: @escaping (Bool,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
        
        let scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.orders
        let scriptName:String = serverScriptNames.ORDERS.add
        let className = "Orders"
        
        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else { return completion(false,-1,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") } 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if let JSONdict = response.result.value as? [String:Any],
                   let orderID = JSONdict["orderID"] as? Int {
                    
                    if showMsg! {
                        sharedFunc.ALERT().show(
                            title:"CMS \( results.success ?"SUCCESS" :"FAILURE" )",
                            style:.error,
                            msg:"\( dbActions.INSERT.noun ) \( className ) \( results.success ?"successful" :"failed." )."
                        )
                    }
                    
                    completion(results.success,results.success ?orderID :-1, results.success ?.none :.notInserted(scriptname:scriptName))
                }else{
                    completion(false,-1,.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    
// MARK: - *********************************************************
// MARK: STRUCT: ITEM STRUCT
// MARK: *********************************************************
    struct itemStruct:Codable,Loopable {
        var id:Int! // Primary Index.
        var cartID:Int! //Link to cart table
        var customerID:Int! //Link to customer table
        var SKU:String!
        var frameSize:String!
        var frameColor:String!
        var frameShape:String!
        var frameStyle:String!
        var matteColor:String!
        var qty:Int!
        var price:Decimal!
        var amount:Decimal!
        var photo:String! //PhotoFilename
        var moltinCartSKU:String!
        
        init (
            id:Int? = -1,
            cartID:Int? = -1,
            customerID:Int? = -1,
            SKU:String? = "",
            frameSize:String? = "",
            frameColor:String? = "",
            frameShape:String? = "",
            frameStyle:String? = "",
            matteColor:String? = "",
            qty:Int? = 0,
            price:Decimal? = 0.00,
            amount:Decimal? = 0.00,
            photo:String? = "",
            moltinCartSKU:String? = ""
        ){
            self.id = id!
            self.cartID = cartID!
            self.customerID = customerID!
            self.SKU = SKU!
            self.frameSize = frameSize!
            self.frameColor = frameColor!
            self.frameShape = frameShape!
            self.frameStyle = frameStyle!
            self.matteColor = matteColor!
            self.qty = qty!
            self.price = price!
            self.amount = amount!
            self.photo = photo!
            self.moltinCartSKU = moltinCartSKU!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id!,
                "cartID" : cartID!,
                "customerID" : customerID!,
                "SKU" : SKU!,
                "frameSize" : frameSize!,
                "frameColor" : frameColor!,
                "frameShape" : frameShape!,
                "frameStyle" : frameStyle!,
                "matteColor" : matteColor!,
                "qty" : qty!,
                "price" : price!,
                "qty" : qty!,
                "amount" : amount!,
                "moltinCartSKU" : moltinCartSKU!,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.cartID = (dictionary["cartID"] as? String ?? "-1").intValue
            self.customerID = (dictionary["customerID"] as? String ?? "-1").intValue
            self.SKU = dictionary["items"] as? String ?? ""
            self.frameSize = dictionary["frameSize"] as? String ?? ""
            self.frameColor = dictionary["frameColor"] as? String ?? ""
            self.frameShape = dictionary["frameShape"] as? String ?? ""
            self.frameStyle = dictionary["frameStyle"] as? String ?? ""
            self.matteColor = dictionary["matteColor"] as? String ?? ""
            self.qty = (dictionary["qty"] as? String ?? "-1").intValue
            self.price = Decimal((dictionary["price"] as? String ?? "-1").doubleValue)
            self.amount = Decimal((dictionary["amount"] as? String ?? "-1").doubleValue)
            self.photo = dictionary["photo"] as? String ?? ""
            self.moltinCartSKU = dictionary["moltinCartSKU"] as? String ?? ""
        }
        

        func convertStructToDictionary(structure:Orders.itemStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id!, forKey: "id")
                dict.updateValue(structure.cartID!, forKey: "cartID")
                dict.updateValue(structure.customerID!, forKey: "customerID")
                dict.updateValue(structure.SKU!, forKey: "SKU")
                dict.updateValue(structure.frameSize!, forKey: "frameSize")
                dict.updateValue(structure.frameColor!, forKey: "frameColor")
                dict.updateValue(structure.frameShape!, forKey: "frameShape")
                dict.updateValue(structure.frameStyle!, forKey: "frameStyle")
                dict.updateValue(structure.matteColor!, forKey: "matteColor")
                dict.updateValue(structure.qty!, forKey: "qty")
                dict.updateValue(structure.price!, forKey: "price")
                dict.updateValue(structure.amount!, forKey: "amount")
                dict.updateValue(structure.photo!, forKey: "photo")
                dict.updateValue(structure.moltinCartSKU!, forKey: "moltinCartSKU")

            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Orders.itemStruct] {
            var arr:[Orders.itemStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Orders.itemStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[Orders.itemStruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (item) in arr.append(Orders.itemStruct().convertStructToDictionary(structure: item) ) }
            
            return arr
        }
    }
    
    struct issueStruct:Codable,Loopable {
        var id:Int // Primary Index.
        var customerID:Int // Link to customer table
        var orderID:String
        var contactedBy:String
        var issue:String
        var lastAction:String
        var resolution:String
        var status:String
        var replacementTracking:String
        var notes:String
        
        init (
            id:Int? = -1,
            customerID:Int? = -1,
            orderID:String? = "",
            contactedBy:String? = "",
            issue:String? = "",
            lastAction:String? = "",
            resolution:String? = "",
            status:String? = "",
            replacementTracking:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.customerID = customerID!
            self.orderID = orderID!
            self.contactedBy = contactedBy!
            self.issue = issue!
            self.lastAction = lastAction!
            self.resolution = resolution!
            self.status = status!
            self.replacementTracking = replacementTracking!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "").intValue
            self.customerID = (dictionary["customerID"] as? String ?? "").intValue
            self.orderID = dictionary["orderID"] as? String ?? ""
            self.contactedBy = dictionary["contactedBy"] as? String ?? ""
            self.issue = dictionary["issue"] as? String ?? ""
            self.lastAction = dictionary["lastAction"] as? String ?? ""
            self.resolution = dictionary["resolution"] as? String ?? ""
            self.status = dictionary["status"] as? String ?? ""
            self.replacementTracking = dictionary["replacementTracking"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        
        func convertStructToDictionary(structure:Orders.issueStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
            dict.updateValue(structure.id, forKey: "id")
            dict.updateValue(structure.customerID, forKey: "customerID")
            dict.updateValue(structure.orderID, forKey: "orderID")
            dict.updateValue(structure.contactedBy, forKey: "contactedBy")
            dict.updateValue(structure.issue, forKey: "issue")
            dict.updateValue(structure.lastAction, forKey: "lastAction")
            dict.updateValue(structure.resolution, forKey: "resolution")
            dict.updateValue(structure.status, forKey: "status")
            dict.updateValue(structure.replacementTracking, forKey: "replacementTracking")
            dict.updateValue(structure.notes, forKey: "notes")
            
            return dict
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Orders.issueStruct] {
            var arr:[Orders.issueStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Orders.issueStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        struct prefKeys {
            static let id = "Orders.issue.id"
            static let customerID = "Orders.issue.customerID"
            static let orderID = "Orders.issue.orderID"
            static let contactedBy = "Orders.issue.contactedBy"
            static let issue = "Orders.issue.issue"
            static let lastAction = "Orders.issue.lastAction"
            static let resolution = "Orders.issue.resolution"
            static let status = "Orders.issue.status"
            static let replacementTracking = "Orders.issue.replacementTracking"
            static let notes = "Orders.issue.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "customerID" : customerID,
                "orderID" : orderID,
                "contactedBy" : contactedBy,
                "issue" : issue,
                "lastAction" : lastAction,
                "resolution" : resolution,
                "status" : status,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
    }
    
    struct orderStruct:Codable,Loopable,Equatable {
        var id:Int // Primary Index.
        var orderNum:String
        var orderDate:String //Date/Time
        var statusID:String //Link to orderStatus table
        var customerID:Int //Link to customers table
        var customerNum:String // Moltin CustomerNumber
        var customer_firstName:String
        var customer_lastName:String
        var customer_address1:String
        var customer_address2:String
        var customer_city:String
        var customer_stateCode:String
        var customer_zip:String
        var customer_countryCode:String
        var customer_phone:String
        var customer_email:String
        var cartID:String //Link to cart table
        var productCount:Int //Number of SKU's
        var photoCount:Int //Number of Photos
        var giftMessage:String
        var subtotal:Decimal //stored as Decimal(10,2) in CMS
        var taxAmt:Decimal //stored as Decimal(10,2) in CMS
        var shippingAmt:Decimal //stored as Decimal(10,2) in CMS
        var discountAmt:Decimal //stored as Decimal(10,2) in CMS
        var totalAmt:Decimal //stored as Decimal(10,2) in CMS
        var couponID:Int //Link to coupons table
        var shipToID:Int //Link to addresses table
        var shipToMoltinID:String //Link to addresses table
        var shipTo_firstName:String
        var shipTo_lastName:String
        var shipTo_address1:String
        var shipTo_address2:String
        var shipTo_city:String
        var shipTo_stateCode:String
        var shipTo_zip:String
        var shipTo_countryCode:String
        var shipTo_phone:String
        var shipTo_email:String
        var shippingPriority:String //Link to shippingPriority table
        var shippedVia:String //Link to shipper table
        var trackingNum:String
        var shippedAmt:Decimal //stored as Decimal(10,2) in CMS
        var shippedDate:String
        var deliveredDate:String
        var mailer_compFilesDate:String
        var mailer_confDate:String
        var mailer_trackingDate:String
        var taxJarTransactionID:String //Link to TaxJar API
        var paymentAuthorized:String
        var paymentCard:String // Last 4 digits of CC
        var StripeTransactionID:String //Link to Stripe API
        var shippoTransactionID:String //Link to Shippo API
        var orderFolder:String //comma separated filenames
        var orderDocs:String //comma separated filenames
        var photos:String //comma separated filenames
        var notes:String
        
        init (
            id:Int? = -1,
            orderNum:String? = "",
            orderDate:String? = "",
            statusID:String? = "",
            customerID:Int? = -1,
            customerNum:String? = "",
            customer_firstName:String? = "",
            customer_lastName:String? = "",
            customer_address1:String? = "",
            customer_address2:String? = "",
            customer_city:String? = "",
            customer_stateCode:String? = "",
            customer_zip:String? = "",
            customer_countryCode:String? = "",
            customer_phone:String? = "",
            customer_email:String? = "",
            cartID:String? = "-1",
            productCount:Int? = -1,
            photoCount:Int? = -1,
            giftMessage:String? = "",
            subtotal:Decimal? = 0.00,
            taxAmt:Decimal? = 0.00,
            shippingAmt:Decimal? = 0.00,
            discountAmt:Decimal? = 0.00,
            totalAmt:Decimal? = 0.00,
            couponID:Int? = -1,
            shipToID:Int? = -1,
            shipToMoltinID:String? = "",
            shipTo_firstName:String? = "",
            shipTo_lastName:String? = "",
            shipTo_address1:String? = "",
            shipTo_address2:String? = "",
            shipTo_city:String? = "",
            shipTo_stateCode:String? = "",
            shipTo_zip:String? = "",
            shipTo_countryCode:String? = "",
            shipTo_phone:String? = "",
            shipTo_email:String? = "",
            shippingPriority:String? = "",
            shippedVia:String? = "",
            trackingNum:String? = "",
            shippedAmt:Decimal? = 0.00,
            shippedDate:String? = "",
            deliveredDate:String? = "",
            mailer_compFilesDate:String? = "",
            mailer_confDate:String? = "",
            mailer_trackingDate:String? = "",
            taxJarTransactionID:String? = "",
            paymentAuthorized:String? = "0",
            paymentCard:String? = "",
            StripeTransactionID:String? = "",
            shippoTransactionID:String? = "",
            orderFolder:String? = "",
            orderDocs:String? = "",
            photos:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.orderNum = orderNum!
            self.orderDate = orderDate!
            self.statusID = statusID!
            self.customerID = customerID!
            self.customerNum = customerNum!
            self.customer_firstName = customer_firstName!
            self.customer_lastName = customer_lastName!
            self.customer_address1 = customer_address1!
            self.customer_address2 = customer_address2!
            self.customer_city = customer_city!
            self.customer_stateCode = customer_stateCode!
            self.customer_zip = customer_zip!
            self.customer_countryCode = customer_countryCode!
            self.customer_phone = customer_phone!
            self.customer_email = customer_email!
            self.cartID = cartID!
            self.productCount = productCount!
            self.photoCount = photoCount!
            self.giftMessage = giftMessage!
            self.subtotal = subtotal!
            self.taxAmt = taxAmt!
            self.shippingAmt = shippingAmt!
            self.discountAmt = discountAmt!
            self.totalAmt = totalAmt!
            self.couponID = couponID!
            self.shipToID = shipToID!
            self.shipToMoltinID = shipToMoltinID!
            self.shipTo_firstName = shipTo_firstName!
            self.shipTo_lastName = shipTo_lastName!
            self.shipTo_address1 = shipTo_address1!
            self.shipTo_address2 = shipTo_address2!
            self.shipTo_city = shipTo_city!
            self.shipTo_stateCode = shipTo_stateCode!
            self.shipTo_zip = shipTo_zip!
            self.shipTo_countryCode = shipTo_countryCode!
            self.shipTo_phone = shipTo_phone!
            self.shipTo_email = shipTo_email!
            self.shippingPriority = shippingPriority!
            self.shippedVia = shippedVia!
            self.trackingNum = trackingNum!
            self.shippedAmt = shippedAmt!
            self.shippedDate = shippedDate!
            self.deliveredDate = deliveredDate!
            self.mailer_compFilesDate = mailer_compFilesDate!
            self.mailer_confDate = mailer_confDate!
            self.mailer_trackingDate = mailer_trackingDate!
            self.taxJarTransactionID = taxJarTransactionID!
            self.paymentAuthorized = paymentAuthorized!
            self.paymentCard = paymentCard!
            self.StripeTransactionID = StripeTransactionID!
            self.shippoTransactionID = shippoTransactionID!
            self.orderFolder = orderFolder!
            self.orderDocs = orderDocs!
            self.photos = photos!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "").intValue
            self.orderNum = dictionary["orderNum"] as? String ?? ""
            self.orderDate = dictionary["orderDate"] as? String ?? ""
            self.statusID = dictionary["statusID"] as? String ?? ""
            self.customerID = (dictionary["customerID"] as? String ?? "").intValue
            self.customerNum = dictionary["customerNum"] as? String ?? ""
            self.customer_firstName = dictionary["customer_firstName"] as? String ?? ""
            self.customer_lastName = dictionary["customer_lastName"] as? String ?? ""
            self.customer_address1 = dictionary["customer_address1"] as? String ?? ""
            self.customer_address2 = dictionary["customer_address2"] as? String ?? ""
            self.customer_city = dictionary["customer_city"] as? String ?? ""
            self.customer_stateCode = dictionary["customer_stateCode"] as? String ?? ""
            self.customer_zip = dictionary["customer_zip"] as? String ?? ""
            self.customer_countryCode = dictionary["customer_countryCode"] as? String ?? ""
            self.customer_phone = dictionary["customer_phone"] as? String ?? ""
            self.customer_email = dictionary["customer_email"] as? String ?? ""
            self.cartID = dictionary["cartID"] as? String ?? ""
            self.productCount = (dictionary["productCount"] as? String ?? "").intValue
            self.photoCount = (dictionary["photoCount"] as? String ?? "").intValue
            self.giftMessage = dictionary["giftMessage"] as? String ?? ""
            self.subtotal = Decimal((dictionary["subtotal"] as? String ?? "").doubleValue)
            self.taxAmt = Decimal((dictionary["taxAmt"] as? String ?? "").doubleValue)
            self.shippingAmt = Decimal((dictionary["shippingAmt"] as? String ?? "").doubleValue)
            self.discountAmt = Decimal((dictionary["discountAmt"] as? String ?? "").doubleValue)
            self.totalAmt = Decimal((dictionary["totalAmt"] as? String ?? "").doubleValue)
            self.couponID = (dictionary["couponID"] as? String ?? "").intValue
            self.shipToID = (dictionary["shipToID"] as? String ?? "").intValue
            self.shipToMoltinID = dictionary["shipToMoltinID"] as? String ?? ""
            self.shipTo_firstName = dictionary["shipTo_firstName"] as? String ?? ""
            self.shipTo_lastName = dictionary["shipTo_lastName"] as? String ?? ""
            self.shipTo_address1 = dictionary["shipTo_address1"] as? String ?? ""
            self.shipTo_address2 = dictionary["shipTo_address2"] as? String ?? ""
            self.shipTo_city = dictionary["shipTo_city"] as? String ?? ""
            self.shipTo_stateCode = dictionary["shipTo_stateCode"] as? String ?? ""
            self.shipTo_zip = dictionary["shipTo_zip"] as? String ?? ""
            self.shipTo_countryCode = dictionary["shipTo_countryCode"] as? String ?? ""
            self.shipTo_phone = dictionary["shipTo_phone"] as? String ?? ""
            self.shipTo_email = dictionary["shipTo_email"] as? String ?? ""
            self.shippingPriority = dictionary["shippingPriority"] as? String ?? ""
            self.shippedVia = dictionary["shippedVia"] as? String ?? ""
            self.trackingNum = dictionary["trackingNum"] as? String ?? ""
            self.shippedAmt = Decimal((dictionary["shippedAmt"] as? String ?? "").doubleValue)
            self.shippedDate = dictionary["shippedDate"] as? String ?? ""
            self.deliveredDate = dictionary["deliveredDate"] as? String ?? ""
            self.mailer_compFilesDate = dictionary["mailer_compFilesDate"] as? String ?? ""
            self.mailer_confDate = dictionary["mailer_confDate"] as? String ?? ""
            self.mailer_trackingDate = dictionary["mailer_trackingDate"] as? String ?? ""
            self.taxJarTransactionID = dictionary["taxJarTransactionID"] as? String ?? ""
            self.paymentAuthorized = dictionary["paymentAuthorized"] as? String ?? ""
            self.paymentCard = dictionary["paymentCard"] as? String ?? ""
            self.StripeTransactionID = dictionary["StripeTransactionID"] as? String ?? ""
            self.shippoTransactionID = dictionary["shippoTransactionID"] as? String ?? ""
            self.orderFolder = dictionary["orderFolder"] as? String ?? ""
            self.orderDocs = dictionary["orderDocs"] as? String ?? ""
            self.photos = dictionary["photos"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        
        func convertStructToDictionary(structure:Orders.orderStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
            dict.updateValue(structure.id, forKey: "id")
            dict.updateValue(structure.orderNum, forKey: "orderNum")
            dict.updateValue(structure.orderDate, forKey: "orderDate")
            dict.updateValue(structure.statusID, forKey: "statusID")
            dict.updateValue(structure.customerID, forKey: "customerID")
            dict.updateValue(structure.customerNum, forKey: "customerNum")
            dict.updateValue(structure.customer_firstName, forKey: "customer_firstName")
            dict.updateValue(structure.customer_lastName, forKey: "customer_lastName")
            dict.updateValue(structure.customer_address1, forKey: "customer_address1")
            dict.updateValue(structure.customer_address2, forKey: "customer_address2")
            dict.updateValue(structure.customer_city, forKey: "customer_city")
            dict.updateValue(structure.customer_stateCode, forKey: "customer_stateCode")
            dict.updateValue(structure.customer_zip, forKey: "customer_zip")
            dict.updateValue(structure.customer_countryCode, forKey: "customer_countryCode")
            dict.updateValue(structure.customer_phone, forKey: "customer_phone")
            dict.updateValue(structure.customer_email, forKey: "customer_email")
            dict.updateValue(structure.cartID, forKey: "cartID")
            dict.updateValue(structure.productCount, forKey: "productCount")
            dict.updateValue(structure.photoCount, forKey: "photoCount")
            dict.updateValue(structure.giftMessage, forKey: "giftMessage")
            dict.updateValue(structure.subtotal, forKey: "subtotal")
            dict.updateValue(structure.taxAmt, forKey: "taxAmt")
            dict.updateValue(structure.shippingAmt, forKey: "shippingAmt")
            dict.updateValue(structure.discountAmt, forKey: "discountAmt")
            dict.updateValue(structure.totalAmt, forKey: "totalAmt")
            dict.updateValue(structure.couponID, forKey: "couponID")
            dict.updateValue(structure.shipToID, forKey: "shipToID")
            dict.updateValue(structure.shipToMoltinID, forKey: "shipToMoltinID")
            dict.updateValue(structure.shipTo_firstName, forKey: "shipTo_firstName")
            dict.updateValue(structure.shipTo_lastName, forKey: "shipTo_lastName")
            dict.updateValue(structure.shipTo_address1, forKey: "shipTo_address1")
            dict.updateValue(structure.shipTo_address2, forKey: "shipTo_address2")
            dict.updateValue(structure.shipTo_city, forKey: "shipTo_city")
            dict.updateValue(structure.shipTo_stateCode, forKey: "shipTo_stateCode")
            dict.updateValue(structure.shipTo_zip, forKey: "shipTo_zip")
            dict.updateValue(structure.shipTo_countryCode, forKey: "shipTo_countryCode")
            dict.updateValue(structure.shipTo_phone, forKey: "shipTo_phone")
            dict.updateValue(structure.shipTo_email, forKey: "shipTo_email")
            dict.updateValue(structure.shippingPriority, forKey: "shippingPriority")
            dict.updateValue(structure.shippedVia, forKey: "shippedVia")
            dict.updateValue(structure.trackingNum, forKey: "trackingNum")
            dict.updateValue(structure.shippedAmt, forKey: "shippedAmt")
            dict.updateValue(structure.shippedDate, forKey: "shippedDate")
            dict.updateValue(structure.deliveredDate, forKey: "deliveredDate")
            dict.updateValue(structure.mailer_compFilesDate, forKey: "mailer_compFilesDate")
            dict.updateValue(structure.mailer_confDate, forKey: "mailer_confDate")
            dict.updateValue(structure.mailer_trackingDate, forKey: "mailer_trackingDate")
            dict.updateValue(structure.taxJarTransactionID, forKey: "taxJarTransactionID")
            dict.updateValue(structure.paymentAuthorized, forKey: "paymentAuthorized")
            dict.updateValue(structure.paymentCard, forKey: "paymentCard")
            dict.updateValue(structure.StripeTransactionID, forKey: "StripeTransactionID")
            dict.updateValue(structure.shippoTransactionID, forKey: "shippoTransactionID")
            dict.updateValue(structure.orderFolder, forKey: "orderFolder")
            dict.updateValue(structure.orderDocs, forKey: "orderDocs")
            dict.updateValue(structure.photos, forKey: "photos")
            dict.updateValue(structure.notes, forKey: "notes")
            
            return dict
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Orders.orderStruct] {
            var arr:[Orders.orderStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Orders.orderStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        static func == (lhs: orderStruct, rhs: orderStruct) -> Bool {
            return (
                (lhs.id == rhs.id) &&
                (lhs.orderNum == rhs.orderNum) &&
                (lhs.orderDate == rhs.orderDate) &&
                (lhs.statusID == rhs.statusID) &&
                (lhs.customerID == rhs.customerID) &&
                (lhs.customerNum == rhs.customerNum) &&
                (lhs.customer_firstName == rhs.customer_firstName) &&
                (lhs.customer_lastName == rhs.customer_lastName) &&
                (lhs.customer_address1 == rhs.customer_address1) &&
                (lhs.customer_address2 == rhs.customer_address2) &&
                (lhs.customer_city == rhs.customer_city) &&
                (lhs.customer_stateCode == rhs.customer_stateCode) &&
                (lhs.customer_zip == rhs.customer_zip) &&
                (lhs.customer_countryCode == rhs.customer_countryCode) &&
                (lhs.customer_phone == rhs.customer_phone) &&
                (lhs.customer_email == rhs.customer_email) &&
                (lhs.cartID == rhs.cartID) &&
                (lhs.productCount == rhs.productCount) &&
                (lhs.photoCount == rhs.photoCount) &&
                (lhs.photoCount == rhs.photoCount) &&
                (lhs.giftMessage == rhs.giftMessage) &&
                (lhs.subtotal == rhs.subtotal) &&
                (lhs.taxAmt == rhs.taxAmt) &&
                (lhs.shippingAmt == rhs.shippingAmt) &&
                (lhs.discountAmt == rhs.discountAmt) &&
                (lhs.totalAmt == rhs.totalAmt) &&
                (lhs.couponID == rhs.couponID) &&
                (lhs.shipToID == rhs.shipToID) &&
                (lhs.shipToMoltinID == rhs.shipToMoltinID) &&
                (lhs.shipTo_firstName == rhs.shipTo_firstName) &&
                (lhs.shipTo_lastName == rhs.shipTo_lastName) &&
                (lhs.shipTo_address1 == rhs.shipTo_address1) &&
                (lhs.shipTo_address2 == rhs.shipTo_address2) &&
                (lhs.shipTo_city == rhs.shipTo_city) &&
                (lhs.shipTo_stateCode == rhs.shipTo_stateCode) &&
                (lhs.shipTo_zip == rhs.shipTo_zip) &&
                (lhs.shipTo_countryCode == rhs.shipTo_countryCode) &&
                (lhs.shipTo_phone == rhs.shipTo_phone) &&
                (lhs.shipTo_email == rhs.shipTo_email) &&
                (lhs.shippingPriority == rhs.shippingPriority) &&
                (lhs.shippedVia == rhs.shippedVia) &&
                (lhs.trackingNum == rhs.trackingNum) &&
                (lhs.shippedAmt == rhs.shippedAmt) &&
                (lhs.shippedDate == rhs.shippedDate) &&
                (lhs.deliveredDate == rhs.deliveredDate) &&
                (lhs.mailer_compFilesDate == rhs.mailer_compFilesDate) &&
                (lhs.mailer_confDate == rhs.mailer_confDate) &&
                (lhs.mailer_trackingDate == rhs.mailer_trackingDate) &&
                (lhs.taxJarTransactionID == rhs.taxJarTransactionID) &&
                (lhs.paymentAuthorized == rhs.paymentAuthorized) &&
                (lhs.paymentCard == rhs.paymentCard) &&
                (lhs.StripeTransactionID == rhs.StripeTransactionID) &&
                (lhs.shippoTransactionID == rhs.shippoTransactionID) &&
                (lhs.orderFolder == rhs.orderFolder) &&
                (lhs.orderDocs == rhs.orderDocs) &&
                (lhs.photos == rhs.photos) &&
                (lhs.notes == rhs.notes)
            )
        }
        
        func customerInfoHasChanged(order1 lhs: orderStruct,order2 rhs: orderStruct) -> Bool {
            let areTheSame:Bool = (
                (lhs.customerID == rhs.customerID) &&
                (lhs.customerNum == rhs.customerNum) &&
                (lhs.customer_firstName == rhs.customer_firstName) &&
                (lhs.customer_lastName == rhs.customer_lastName) &&
                (lhs.customer_address1 == rhs.customer_address1) &&
                (lhs.customer_address2 == rhs.customer_address2) &&
                (lhs.customer_city == rhs.customer_city) &&
                (lhs.customer_stateCode == rhs.customer_stateCode) &&
                (lhs.customer_zip == rhs.customer_zip) &&
                (lhs.customer_countryCode == rhs.customer_countryCode) &&
                (lhs.customer_phone == rhs.customer_phone) &&
                (lhs.customer_email == rhs.customer_email)
            )
            
            return !areTheSame
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "orderNum" : orderNum,
                "orderDate" : orderDate,
                "statusID" : statusID,
                "customerID" : customerID,
                "customerNum" : customerNum,
                "customer_firstName" :customer_firstName,
                "customer_lastName":customer_lastName,
                "customer_address1":customer_address1,
                "customer_address2":customer_address2,
                "customer_city":customer_city,
                "customer_stateCode":customer_stateCode,
                "customer_zip":customer_zip,
                "customer_countryCode":customer_countryCode,
                "customer_phone":customer_phone,
                "customer_email":customer_email,
                "cartID" : cartID,
                "productCount" : productCount,
                "photoCount" : photoCount,
                "giftMessage" : giftMessage,
                "subtotal" : subtotal,
                "taxAmt" : taxAmt,
                "shippingAmt" : shippingAmt,
                "discountAmt" : discountAmt,
                "totalAmt" : totalAmt,
                "couponID" : couponID,
                "shipToID" : shipToID,
                "shipToMoltinID" : shipToMoltinID,
                "shipTo_firstName" :shipTo_firstName,
                "shipTo_lastName":shipTo_lastName,
                "shipTo_address1":shipTo_address1,
                "shipTo_address2":shipTo_address2,
                "shipTo_city":shipTo_city,
                "shipTo_stateCode":shipTo_stateCode,
                "shipTo_zip":shipTo_zip,
                "shipTo_countryCode":shipTo_countryCode,
                "shipTo_phone":shipTo_phone,
                "shipTo_email":shipTo_email,
                "shippingPriority" : shippingPriority,
                "shippedVia" : shippedVia,
                "trackingNum" : trackingNum,
                "shippedAmt" : shippedAmt,
                "shippedDate" : shippedDate,
                "deliveredDate" : deliveredDate,
                "mailer_compFilesDate" : mailer_compFilesDate,
                "mailer_confDate" : mailer_confDate,
                "mailer_trackingDate" : mailer_trackingDate,
                "taxJarTransactionID" : taxJarTransactionID,
                "paymentAuthorized" : paymentAuthorized,
                "paymentCard" : paymentCard,
                "StripeTransactionID" : StripeTransactionID,
                "shippoTransactionID" : shippoTransactionID,
                "orderFolder" : orderFolder,
                "orderDocs" : orderDocs,
                "photos" : photos,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
    }

// MARK: - *********************************************************
// MARK: CLASS: PHP FUNCTIONS
// MARK: *********************************************************
    /// resets the test orders (ornerNum<100) to statusID=Unpaid
    /// returns (success:Bool,error:cmsError)
    func resetTestOrders(completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName:String = serverScriptNames.ORDERS.resetTestOrders
        guard let scriptURL =  URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
            else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        Alamofire.request(scriptURL, method: .post, parameters: [:], encoding: URLEncoding.default)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseString(completionHandler: { response in
                switch response.result {
                case .success:
                    completion(true,.none)
                case .failure(let error):
                    completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            })
    }
    
    /// returns (success:Bool,error:cmsError,erroMSG:error string from script)
    func completeOrder(order_id:Int,ccToken:String,testOrder:Bool? = false, completion: @escaping (Bool,cmsError,String) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable,"") }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName:String = serverScriptNames.ORDERS.completeOrder

        guard let scriptURL =  URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.stripe!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName),"") }

        let params:Alamofire.Parameters = [
            "testOrder":false,
            "dontSendEmail":false,
            "forceWriteTaxRecord":false,
            "order_id":order_id,
            "token": ccToken,
        ]
        
        waitHUD().showNow(msg: "Completing Order...") 
        Server().dumpParams(params,scriptName: scriptName)

        /* Setup Configuration for upload which will include a timeout */
        let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 100
            config.timeoutIntervalForResource = 50
        AFmanager = Alamofire.SessionManager(configuration: config)

        AFmanager.request(scriptURL, method: .post, parameters: params, encoding: URLEncoding.default)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
            simPrint().info("\( response )",function:#function,line:#line)

            switch response.result {
            case .success:
                let _ = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["successful"] as? Bool {

                    /* Low-level return status */
                    let order_number = JSONdict["order_number"] as? String ?? "n/a"
                    let found = JSONdict["found"] as? Int ?? 0
                    let error_count = JSONdict["error_count"] as? Int ?? 0
                    let error_Stripe = Bool(JSONdict["error_Stripe"] as? Int ?? 0)
                    let error_CMS = Bool(JSONdict["error_CMS"] as? Int ?? 0)
                    let error_Shippo = Bool(JSONdict["error_Shippo"] as? Int ?? 0)
                    let error_TaxJar = Bool(JSONdict["error_TaxJar"] as? Int ?? 0)
                    let error_message = JSONdict["error_message"] as? String ?? "n/a"

                    simPrint().success(
                        """
                       orderID: \(order_number)/n
                       found: \(found)/n
                       error_count: \(error_count)/n
                       error_Stripe: \(error_Stripe)/n
                       error_CMS: \(error_CMS)/n
                       error_Shippo: \(error_Shippo)/n
                       error_TaxJar: \(error_TaxJar)/n
                       error_message: \(error_message)/n
                       """,function:#function,line:#line
                    )
                    simPrint().success("Order \(success ?"Completed":"Failed"), id: \(success ?order_number :error_message)",function:#function,line:#line)
                    
                    completion(success,success ?.none :.notCompleted(scriptname:scriptName) ,success ?"" :error_message )
                }else{
                    completion(false,.notCompleted(scriptname:scriptName),"")
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)),"")
            }
        })
    }
    
    func listIssues(showMsg:Bool? = false,completion: @escaping (Bool,[Orders.orderStruct],[Orders.issueStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listIssues
        let className = Orders.orderStruct.self
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
            else { return completion(false,[],[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                let orders = Orders.orderStruct().returnArray(arrayOfDictionaries:results.records)
                
                let JSONdict = response.result.value as! [String:Any]
                let records = JSONdict["issues"] as? [[String:Any]] ?? []
                let issues = Orders.issueStruct().returnArray(arrayOfDictionaries:records)
                
                completion(true,orders,issues,.none)
            case .failure(let error):
                completion(false,[],[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func listStatuses(showMsg:Bool? = false,completion: @escaping (Bool,[[String:String]],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listStatuses
        let className = Orders.orderStruct.self
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
            else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                var records:[[String:String]] = []
                for counter in 0..<results.records.count {
                    let record = results.records[counter]
                    let key = record["statusID"] as? String ?? ""
                    let val = record["count"] as? String ?? ""
                    
                    records.append(["key":"\( key )","value":"\( val.intValue )"])
                }
                
                
                completion(true,records,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func listOrdersByCustomerID(showMsg:Bool? = false, id:Int, completion: @escaping (Bool,[Orders.orderStruct],[Customers.address],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listCustOrders
        let className = Orders().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,[],[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "customerID": id,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName) 
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                if let dict = response.result.value as? [String:Any],
                   let shipToRecords = dict["shipToRecords"] as? [[String:Any]],
                   let orderRecords = dict["records"] as? [[String:Any]] {
                    
                    let orderRecs = Orders.orderStruct().returnArray(arrayOfDictionaries: orderRecords)
                    let shipToRecs = Customers.address().returnArray(arrayOfDictionaries: shipToRecords)
                    
                    completion(true,orderRecs,shipToRecs,.none)
                }else{
                    completion(false,[],[],.items_NotFound)
                }
            case .failure(let error):
                completion(false,[],[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func listOrdersByOrderNum(showMsg:Bool? = false, orderNum:Int, completion: @escaping (Bool,Orders.orderStruct,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,Orders.orderStruct.init(),.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listByOrderNum
        let className = Orders().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,Orders.orderStruct.init(),.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "orderNum": orderNum,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if results.success {
                    let order = Orders.orderStruct.init(dictionary: results.records.first!)
                    completion(true,order,.none)
                }else{
                    completion(false,Orders.orderStruct.init(),.items_NotFound)
                }
            case .failure(let error):
                completion(false,Orders.orderStruct.init(),.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func listGifts(showMsg:Bool? = false,completion: @escaping (Bool,[Orders.orderStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listGifts
        let className = Orders.orderStruct.self
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                let orders = Orders.orderStruct().returnArray(arrayOfDictionaries:results.records)
                completion(true,orders,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func listByDateRange(showMsg:Bool? = false,fromDate:String,toDate:String,completion: @escaping (Bool,[Orders.orderStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listByDateRange
        let className = Orders.orderStruct.self
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "fromDate": fromDate,
            "toDate": toDate,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        Server().dumpParams(params)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                let orders = Orders.orderStruct().returnArray(arrayOfDictionaries:results.records)
                completion(true,orders,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func listByStatus(showMsg:Bool? = false,status:String,completion: @escaping (Bool,[Orders.orderStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.listByStatus
        let className = "Orders"
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
            else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "status": status,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        Server().dumpParams(params)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                let orders = Orders.orderStruct().returnArray(arrayOfDictionaries:results.records)
                completion(true,orders,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func updateStatus(showMsg:Bool? = false,orderNums:String,status:String,completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.updateOrderStatus
        let className = "Order Status"
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "orderNums": orderNums,
            "status": status,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
            let success = results.success

            switch response.result {
            case .success:
                completion(success,success ?.none :cmsError.notUpdated(scriptname: scriptName))
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func updateDeliveryInfo(
        showMsg:Bool? = false,
        orderNum:String,
        deliveredDate:String,
        completion: @escaping (Bool,cmsError) -> Void) {
        
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.updateOrderDeliveryInfo
        let className = "Order Delivered Status & Info"
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") }
        let params:Alamofire.Parameters = [
            "orderID": orderNum,
            "statusID": orderStatus.delivered,
            "deliveredDate": deliveredDate,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
            
            switch response.result {
            case .success:
                let success = results.success
                completion(success,success ?.none :cmsError.notUpdated(scriptname: scriptName))
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func updateShippingInfo(
        showMsg:Bool? = false,
        orderNum:String,
        postage:Decimal,
        shipDate:String,
        trackingNum:String,
        completion: @escaping (Bool,cmsError) -> Void) {

        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.updateOrderShippingInfo
        let className = "Order Shipping Status & Info"
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") }
        let params:Alamofire.Parameters = [
            "orderID": orderNum,
            "statusID": orderStatus.shipped,
            "postage": postage,
            "shipDate": shipDate,
            "trackingNum": trackingNum,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)

            switch response.result {
            case .success:
                let success = results.success
                completion(success,success ?.none :cmsError.notUpdated(scriptname: scriptName))
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[Orders.orderStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.list
        let className = Orders.orderStruct.self
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                let orders = Orders.orderStruct().returnArray(arrayOfDictionaries:results.records)
                completion(true,orders,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func addItem(customerID:Int, params:Alamofire.Parameters, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName:String = serverScriptNames.ORDERS.addItem
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if results.success.isTrue {
                    completion(results.success,results.success ?.none :.notFound(scriptname: scriptName))
                }else{
                    completion(false,.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func addRecord(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters,action:String, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.order.add { scriptName = serverScriptNames.ORDERS.add; className = "\(Orders.orderStruct.self)" }
        else{ return completion(false,.script_NotFound(scriptname: scriptName)) }
        
        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)") else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") } 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if results.success.isTrue {
                    if showMsg! {
                        sharedFunc.ALERT().show(
                            title:"CMS \( results.success ?"SUCCESS" :"FAILURE" )",
                            style:.error,
                            msg:"\( dbActions.INSERT.noun ) \( className ) \( results.success ?"successful" :"failed." )."
                        )
                    }
                    completion(results.success,results.success ?.none :.notInserted(scriptname:scriptName))
                }else{
                    completion(false,.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

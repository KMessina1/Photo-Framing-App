/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Cart.swift
   Author: Kevin Messina
  Created: Apr 15, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire


// MARK: - *********************************************************
// MARK: CLASS: LocalCart
// MARK: *********************************************************

class LocalCart:Codable,Loopable {
    let Version:String = "1.01"
    let name:String = "Local Cart"

    var itemCount:Int!
    var subtotal:Decimal!
    var items:[LocalCartItem]!

    init (
        itemCount:Int? = 0,
        subtotal:Decimal? = 0.00,
        items:[LocalCartItem]? = []
    ){
        self.itemCount = itemCount!
        self.subtotal = subtotal!
        self.items = items!
    }

    func hasItem(SKU:String,instagramImageURL:String) -> (found:Bool,qty:Int) {
        let matches = localCart.items.filter { (($0.SKU == SKU) && ($0.instagramImageURL == instagramImageURL)) }
        let found:Bool = (matches.count > 0)

        return (found:found,qty: found.isTrue ? matches.first?.quantity ?? 0:0)
    }
    
    func addItem(cartItem:LocalCartItem) -> Void {
        itemCount = (itemCount + cartItem.quantity)
        subtotal = (subtotal + cartItem.amount)
        items.append(cartItem)

        simPrint().info("\( dump(localCart)! )",function:#function,line:#line)
    }

    func updateItem(cartItem:LocalCartItem,qtyToChange:Int) -> Bool {
        if let index = localCart.items.firstIndex(where: { (($0.SKU == cartItem.SKU) && ($0.instagramImageURL == cartItem.instagramImageURL)) }) {
            localCart.items[index].quantity = cartItem.quantity
            localCart.items[index].amount = cartItem.amount

            itemCount = (itemCount + qtyToChange)
            subtotal = (subtotal + (Decimal(qtyToChange) * cartItem.price))
            
            simPrint().info("\( dump(localCart)! )",function:#function,line:#line)

            return true
        }
        
        return false
    }

    func removeItem(cartItem:LocalCartItem) -> Void {
        if let index = localCart.items.firstIndex(where: { (($0.SKU == cartItem.SKU) && ($0.instagramImageURL == cartItem.instagramImageURL)) }) {
            /* Remove locally saved photos */
            let photoFileToDelete = sharedFunc.FILES().dirDocuments(fileName: cartItem.photo_FullSizeFileName)
            let thumbnailFileToDelete = sharedFunc.FILES().dirDocuments(fileName: cartItem.photo_ThumbnailFileName)

            sharedFunc.FILES().delete(filePathAndName: photoFileToDelete)
            sharedFunc.FILES().delete(filePathAndName: thumbnailFileToDelete)

            /* Reduce cart totals */
            itemCount = (itemCount - cartItem.quantity)
            subtotal = (subtotal - (Decimal(cartItem.quantity) * cartItem.price))

            /* Remove item from cart */
            localCart.items.remove(at: index)
            localCart.itemCount = itemCount
            localCart.subtotal = subtotal
        }
        
        simPrint().info("\( dump(localCart)! )",function:#function,line:#line)
    }

    func empty() -> Void {
        localCart = LocalCart.init()
        
        /* Delete Cart Thumbnails */
        sharedFunc.FILES().deleteFiles(
            Predicate: "SELF BEGINSWITH[cd] 'thumbnail_'",
            path: sharedFunc.FILES().dirDocuments()
        )
        
        /* Delete Cart Photos */
        sharedFunc.FILES().deleteFiles(
            Predicate: "SELF BEGINSWITH[cd] 'photo_'",
            path: sharedFunc.FILES().dirDocuments()
        )

        /* Delete Cart PDFs */
        sharedFunc.FILES().deleteFiles(
            Predicate: "SELF BEGINSWITH[cd] 'Order' && SELF ENDSWITH[cd] 'pdf'",
            path: sharedFunc.FILES().dirDocuments()
        )

        NotificationCenter.default.post(name: NSNotification.Name("notification_CartCount"), object: nil)

        simPrint().info("\( dump(localCart)! )",function:#function,line:#line)
    }
}

public struct LocalCartItem:Codable,Loopable {
    var frame_size:Int!
    var frame_color:Int!
    var frame_shape:Int!
    var frame_style:Int!
    var matte_color:Int!
    var frame_material:Int!
    var photo_ThumbnailFileName:String!
    var photo_FullSizeFileName:String!
    var instagramImageURL:String
    var quantity:Int!
    var price:Decimal!
    var amount:Decimal!
    var SKU:String!
    
    init (
        frame_size:Int? = 0,
        frame_color:Int? = 0,
        frame_shape:Int? = 0,
        frame_style:Int? = 0,
        matte_color:Int? = 0,
        frame_material:Int? = 0,
        photo_ThumbnailFileName:String? = "",
        photo_FullSizeFileName:String? = "",
        instagramImageURL:String? = "",
        quantity:Int? = 0,
        price:Decimal? = 0.00,
        amount:Decimal? = 0.00,
        SKU:String? = ""
    ){
        self.frame_size = frame_size!
        self.frame_color = frame_color!
        self.frame_shape = frame_shape!
        self.frame_style = frame_style!
        self.matte_color = matte_color!
        self.frame_material = frame_material!
        self.photo_ThumbnailFileName = photo_ThumbnailFileName!
        self.photo_FullSizeFileName = photo_FullSizeFileName!
        self.instagramImageURL = instagramImageURL!
        self.quantity = quantity!
        self.price = price!
        self.amount = amount!
        self.SKU = SKU!
    }
        
    enum CodingKeys:String,CodingKey {
        case frame_size,frame_color,frame_shape,frame_style,matte_color,frame_material,
             photo_ThumbnailFileName,photo_FullSizeFileName,instagramImageURL,
             quantity,price,amount,SKU
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.frame_size = try values.decode(Int.self, forKey: .frame_size)
        self.frame_color = try values.decode(Int.self, forKey: .frame_color)
        self.frame_shape = try values.decode(Int.self, forKey: .frame_shape)
        self.frame_style = try values.decode(Int.self, forKey: .frame_style)
        self.matte_color = try values.decode(Int.self, forKey: .matte_color)
        self.frame_material = try values.decode(Int.self, forKey: .frame_material)
        self.photo_ThumbnailFileName = try values.decode(String.self, forKey: .photo_ThumbnailFileName)
        self.photo_FullSizeFileName = try values.decode(String.self, forKey: .photo_FullSizeFileName)
        self.instagramImageURL = try values.decode(String.self, forKey: .instagramImageURL)
        self.quantity = try values.decode(Int.self, forKey: .quantity)
        self.price = try values.decode(Decimal.self, forKey: .price)
        self.amount = try values.decode(Decimal.self, forKey: .amount)
        self.SKU = try values.decode(String.self, forKey: .SKU)
    }
}


// MARK: - *********************************************************
// MARK: CLASS: CART
// MARK: *********************************************************
class Cart:NSObject,Loopable {
    let Version:String = "1.03"
    let name:String = "Cart"

    var id:Int!
    var customerID:Int!
    var itemCount:Int!
    var items:String!
    var subtotal:Decimal!
    var orderID:Int!

    init(
        id:Int? = 0,
        customerID:Int? = 0,
        itemCount:Int? = 0,
        items:String? = "",
        subtotal:Decimal? = 0.00,
        orderID:Int? = 0
    ){
        self.id = id!
        self.customerID = customerID!
        self.itemCount = itemCount!
        self.items = items!
        self.subtotal = subtotal!
        self.orderID = orderID!
    }

    init(dictionary:[String:Any]) {
        self.id = (dictionary["id"] as? String ?? "-1").intValue
        self.customerID = (dictionary["customerID"] as? String ?? "0").intValue
        self.itemCount = (dictionary["itemCount"] as? String ?? "0").intValue
        self.items = dictionary["items"] as? String ?? ""
        self.subtotal = Decimal((dictionary["subtotal"] as? String ?? "0.00").doubleValue)
        self.orderID = (dictionary["itemCount"] as? String ?? "0").intValue
    }

    func convertStructToDictionary(structure:Cart) -> [String:Any] {
        var dict:[String:Any] = [:]
            dict.updateValue(structure.id!, forKey: "id")
            dict.updateValue(structure.customerID!, forKey: "customerID")
            dict.updateValue(structure.itemCount!, forKey: "itemCount")
            dict.updateValue(structure.items!, forKey: "items")
            dict.updateValue(structure.subtotal!, forKey: "subtotal")
            dict.updateValue(structure.orderID!, forKey: "orderID")

        return dict
    }
    
    func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Cart] {
        var arr:[Cart] = []
        arrayOfDictionaries.forEach { (dict) in arr.append(Cart.init(dictionary: dict)) }
        
        return arr
    }
    
    func returnArrayOfDictionaries(arrayOfStructs:[Cart]) -> [[String:Any]] {
        var arr:[[String:Any]] = []
        arrayOfStructs.forEach { (item) in arr.append(Cart().convertStructToDictionary(structure: item) ) }
        
        return arr
    }

    

// MARK: - *** FUNCTIONS ***
    func saveLocalCartItemsToCMS(completion: @escaping (Bool) -> Void) {
        var params:[[String:Any]] = []
        localCart.items.forEach { (localCartItem) in
            params.append([
                "customerID" : order.customerID,
                "SKU": localCartItem.SKU!,
                "frameSize": Frames.products().returnProductPhotoSize(SKU: localCartItem.SKU!).name,
                "frameColor": Frames.products().returnProductColor(SKU: localCartItem.SKU!).name,
                "frameShape": Frames.products().returnProductShape(SKU: localCartItem.SKU!).name,
                "frameStyle": Frames.products().returnProductStyle(SKU: localCartItem.SKU!).name,
                "matteColor": Frames.products().returnProductMatteColor(SKU: localCartItem.SKU!).name,
                "frameMaterial" : Frames.products().returnProductMaterial(SKU: localCartItem.SKU!).name,
                "qty": localCartItem.quantity!,
                "price": localCartItem.price!,
                "amount": localCartItem.amount!,
                "photo": localCartItem.photo_FullSizeFileName!
            ])
        }

        if JSONSerialization.isValidJSONObject(params) {
            do{
                let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions(rawValue: 0))
                if let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    Cart().addAllItemsToCart(jsonSerializedStringOfParams: datastring) { (success, cartID, error) in
                        order.cartID = "\( cartID )"
                        
                        completion(success)
                    }
                }
            }catch {
                print("Error processing new cartID.")
                completion(false)
            }
        }
    }

    func convertCartToOrder(completion: @escaping (Bool, Int) -> Void) {
        /* Update to current date & time */
        order.orderDate = Date().toString(format: kDateFormat.yyyyMMdd)
        
        /* Strip phone & zip formatting */
        order.customer_phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: order.customer_phone)
        order.customer_zip = sharedFunc.STRINGS().stripZipCodeFormatting(text: order.customer_zip)
        order.shipTo_phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: order.shipTo_phone)
        order.shipTo_zip = sharedFunc.STRINGS().stripZipCodeFormatting(text: order.shipTo_zip)

        order.photos = ""
        localCart.items.forEach { (localCartItem) in
            if order.photos.isNotEmpty { order.photos.append(",") }
            order.photos.append(localCartItem.photo_FullSizeFileName!)
        }

        let params = Orders.orderStruct().convertStructToDictionary(structure: order)
        dump(params)
        
        if JSONSerialization.isValidJSONObject(params) {
            do{
                let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions(rawValue: 0))
                if let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    Cart().createOrder(jsonSerializedStringOfParams: datastring) { (success, orderID, error) in
                        order.id = orderID
                        order.orderNum = "\( orderID )"

                        completion(success,orderID)
                    }
                }
            }catch {
                print("Error processing new cartID.")
                completion(false,-1)
            }
        }
    }

    
// MARK: - *** PHP FUNCTIONS ***
    func createOrder(jsonSerializedStringOfParams:NSString ,completion: @escaping (Bool,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CART.convertToOrder
        let className = "Order".localized()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.cart!)/\(scriptName)")
        else { return completion(false,-1,.script_CreationFailed(scriptname: scriptName)) }

        simPrint().info("\( jsonSerializedStringOfParams )",function:#function,line:#line)
        
        let params:Alamofire.Parameters = [
            "jsonSerializedStringOfParams" : jsonSerializedStringOfParams,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                var orderID:Int = -1
                var success = results.success
                
                if success {
                    if let JSONdict = response.result.value as? [String:Any],
                       let ORDERID = JSONdict["orderID"] {
                        
                        orderID = Int("\( ORDERID )") ?? -1
                    }else{
                        success = false
                    }
                }

                if orderID == -1 {
                    success = false
                }
                
                completion(success,orderID,success ?.none :.items_NotFound)
            case .failure(let error):
                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func addAllItemsToCart(jsonSerializedStringOfParams:NSString ,completion: @escaping (Bool,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }

        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CART.addItem
        let className = "Cart.AddItems".localized()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.cart!)/\(scriptName)")
        else { return completion(false,-1,.script_CreationFailed(scriptname: scriptName)) }
        
        waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...")
        simPrint().info("\( jsonSerializedStringOfParams )",function:#function,line:#line)
        
        let params:Alamofire.Parameters = [
            "customerID" : order.customerID,
            "jsonSerializedStringOfParams" : jsonSerializedStringOfParams,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]

        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response) 
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                var cartID:Int = -1
                
                if results.success {
                    if let JSONdict = response.result.value as? [String:Any],
                       let CARTID = JSONdict["cartID"] as? Int{
                    
                        cartID = CARTID
                    }
                }

                completion(results.success,cartID,(results.success) ?.none :.items_NotFound)
            case .failure(let error):
                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func getByCustomerID(completion: @escaping (Bool,Cart,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,Cart.init(),.network_Unavailable) }

        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CART.getByCustomerID
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.cart!)/\(scriptName)")
        else { return completion(false,Cart.init(),.script_CreationFailed(scriptname: scriptName)) }

        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                    let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)

                    if results.found > 0 {
                        completion(true,Cart.init(dictionary: results.records.first!),.none)
                    }else{
                        completion(false,Cart.init(),.items_NotFound)
                    }
            case .failure(let error):
                completion(false,Cart.init(),.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func getByCartID(cartID:Int, completion: @escaping (Bool,Cart,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,Cart.init(),.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CART.getByID
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.cart!)/\(scriptName)")
        else { return completion(false,Cart.init(),.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "cartID":cartID,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if results.found > 0 {
                    completion(true,Cart.init(dictionary: results.records.first!),.none)
                }else{
                    completion(false,Cart.init(),.items_NotFound)
                }
            case .failure(let error):
                completion(false,Cart.init(),.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func list(completion: @escaping (Bool,[Cart],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CART.list
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.cart!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if results.found > 0 {
                    let arr = Cart().returnArray(arrayOfDictionaries: results.records)
                    completion(true,arr,.none)
                }else{
                    completion(false,[],.items_NotFound)
                }
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

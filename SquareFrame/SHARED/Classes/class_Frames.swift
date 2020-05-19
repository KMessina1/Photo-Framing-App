/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Frames.swift
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
class Frames:NSObject {
    let Version:String = "2.01"
    let name:String = "Frames"

    // MARK: - *** FUNCTIONS ***
    func loadComponents(completion: @escaping (Bool) -> Void) {
        Frames().componentsList(showMsg: false) { (success, components, error) in
            CMS_frame_colors = success ?components["frameColors"] as! [Frames.colors] :[]
            CMS_frame_sizes = success ?components["frameSizes"] as! [Frames.sizes] :[]
            CMS_frame_styles = success ?components["frameStyles"] as! [Frames.style] :[]
            CMS_frame_shapes = success ?components["frameShapes"] as! [Frames.shape] :[]
            CMS_matte_Colors = success ?components["matteColors"] as! [Frames.matteColors] :[]
            CMS_frame_materials = success ?components["frameMaterials"] as! [Frames.materials] :[]
            CMS_photo_Sizes = success ?components["photoSizes"] as! [Frames.photoSizes] :[]
            CMS_products = success ?components["products"] as! [Frames.products] :[]
            CMS_products = (CMS_products.filter { $0.active == "1" }).sorted(by: {
                ($0.SKU < $1.SKU) && ($0.frameStyle < $1.frameStyle)
            })
            CMS_frame_colors.sort(by: {$0.displayOrder < $1.displayOrder})
            CMS_frame_sizes.sort(by: {$0.getStartedDisplayOrder < $1.getStartedDisplayOrder})
            CMS_Frames_Square = (CMS_frame_sizes.filter {$0.frameShape == "Square"}).sorted(by: {
                ($0.name < $1.name) && ($0.frameStyle < $1.frameStyle)
            })
            CMS_Frames_Rect = CMS_frame_sizes.filter { $0.frameShape == "Rectangle" }.sorted(by: {
                ($0.name < $1.name) && ($0.frameStyle < $1.frameStyle)
            })

            completion(success)
        }
    }
    
    func componentsList(showMsg:Bool? = false,includeMoltin:Bool? = false,completion: @escaping (Bool,[String:[AnyObject]],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[:],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.FRAMES.componentsList
        let className = Frames().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
        else { return completion(false,[:],.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params)

        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
        
            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any] {
                    let frameColors = Frames.colors().returnArray(arrayOfDictionaries:(JSONdict["frameColors"] as? [[String:Any]])!)
                    let frameStyles = Frames.style().returnArray(arrayOfDictionaries:(JSONdict["frameStyles"] as? [[String:Any]])!)
                    let frameSizes = Frames.sizes().returnArray(arrayOfDictionaries:(JSONdict["frameSizes"] as? [[String:Any]])!)
                    let matteColors = Frames.matteColors().returnArray(arrayOfDictionaries:(JSONdict["matteColors"] as? [[String:Any]])!)
                    let photoSizes = Frames.photoSizes().returnArray(arrayOfDictionaries:(JSONdict["photoSizes"] as? [[String:Any]])!)
                    let frameShapes = Frames.shape().returnArray(arrayOfDictionaries:(JSONdict["frameShapes"] as? [[String:Any]])!)
                    let frameMaterials = Frames.materials().returnArray(arrayOfDictionaries:(JSONdict["frameMaterials"] as? [[String:Any]])!)
                    let products = Frames.products().returnArray(arrayOfDictionaries:(JSONdict["products"] as? [[String:Any]])!)

                    var items:[String:[AnyObject]] = [:]
                        items.updateValue(frameColors as [AnyObject], forKey: "frameColors")
                        items.updateValue(frameStyles as [AnyObject], forKey: "frameStyles")
                        items.updateValue(frameSizes as [AnyObject], forKey: "frameSizes")
                        items.updateValue(frameShapes as [AnyObject], forKey: "frameShapes")
                        items.updateValue(matteColors as [AnyObject], forKey: "matteColors")
                        items.updateValue(frameMaterials as [AnyObject], forKey: "frameMaterials")
                        items.updateValue(photoSizes as [AnyObject], forKey: "photoSizes")
                        items.updateValue(products as [AnyObject], forKey: "products")

                    completion(true,items,.none)
                }else{
                    completion(false,[:],.items_NotFound)
                }
            case .failure(let error):
                completion(false,[:],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func existsRecord(code:String, action:String, completion: @escaping (Bool,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
        
        var scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.components
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.frameColors.exists {
            scriptName = serverScriptNames.FRAMES.COLORS.exists
            className = "\(Frames.colors.self)"
        }else if action == dbActions.PHP.frameStyle.exists {
            scriptName = serverScriptNames.FRAMES.STYLES.exists
            className = "\(Frames.style.self)"
        }else if action == dbActions.PHP.frameSize.exists {
            scriptName = serverScriptNames.FRAMES.SIZES.exists
            className = "\(Frames.sizes.self)"
        }else if action == dbActions.PHP.matteColors.exists {
            scriptName = serverScriptNames.FRAMES.MATTECOLORS.exists
            className = "\(Frames.matteColors.self)"
        }else if action == dbActions.PHP.photoSize.exists {
            scriptName = serverScriptNames.FRAMES.PHOTOSIZES.exists
            className = "\(Frames.photoSizes.self)"
        }else if action == dbActions.PHP.frameShapes.exists {
            scriptName = serverScriptNames.FRAMES.SHAPES.exists
            className = "\(Frames.shape.self)"
        }else if action == dbActions.PHP.products.exists {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.products
            scriptName = serverScriptNames.FRAMES.PRODUCTS.exists
            className = "\(Frames.products.self)"
        }else if action == dbActions.PHP.address.exists {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.addresses
            scriptName = serverScriptNames.ADDRESSES.exists
            className = "\(Customers.address.self)"
        }else if action == dbActions.PHP.customer.exists {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.customers
            scriptName = serverScriptNames.CUSTOMER.exists
            className = "\(Customers.customer.self)"
        }else if action == dbActions.PHP.order.exists {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.orders
            scriptName = serverScriptNames.ORDERS.exists
            className = "\(Orders.orderStruct.self)"
        }else{ return completion(false,-1,.script_NotFound(scriptname: scriptName)) }

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else { return completion(false,-1,.script_CreationFailed(scriptname: scriptName)) }
        
        var params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        if action == dbActions.PHP.products.exists {
            params.updateValue(code, forKey: "SKU")
        }else if action == dbActions.PHP.order.exists {
            params.updateValue(code, forKey: "orderNum")
        }else{
            params.updateValue(code, forKey: "code")
        }
        
        waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                let success = results.success
                var recordID = -1
                if ((results.found > 0) && (results.records.first != nil)) {
                    recordID = (results.records.first?["id"] as? String ?? "-1").intValue
                }
                
                completion(success,recordID,success ?.none :.notFound(scriptname:scriptName))
            case .failure(let error):
                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func updateRecord(vc:UIViewController, params:Alamofire.Parameters,action:String,completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        var scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.components
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.frameColors.update {
            scriptName = serverScriptNames.FRAMES.COLORS.update
            className = "\(Frames.colors.self)"
        }else if action == dbActions.PHP.frameStyle.update {
            scriptName = serverScriptNames.FRAMES.STYLES.update
            className = "\(Frames.style.self)"
        }else if action == dbActions.PHP.frameSize.update {
            scriptName = serverScriptNames.FRAMES.SIZES.update
            className = "\(Frames.sizes.self)"
        }else if action == dbActions.PHP.matteColors.update {
            scriptName = serverScriptNames.FRAMES.MATTECOLORS.update
            className = "\(Frames.matteColors.self)"
        }else if action == dbActions.PHP.photoSize.update {
            scriptName = serverScriptNames.FRAMES.PHOTOSIZES.update
            className = "\(Frames.photoSizes.self)"
        }else if action == dbActions.PHP.frameShapes.update {
            scriptName = serverScriptNames.FRAMES.SHAPES.update
            className = "\(Frames.shape.self)"
        }else if action == dbActions.PHP.products.update {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.products
            scriptName = serverScriptNames.FRAMES.PRODUCTS.update
            className = "\(Frames.products.self)"
        }else{ return completion(false,.script_NotFound(scriptname: scriptName)) }

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else {
            return completion(false,.script_CreationFailed(scriptname: scriptName))
        }
        
        waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)

            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["success"] as? Bool {

                    sharedFunc.ALERT().show(
                        title:"CMS \( success ?"SUCCESS" :"FAILURE" )",
                        style:.error,
                        msg:"\( dbActions.UPDATE.noun ) \( className ) \( success ?"successful" :"failed." )."
                    )
                    completion(success,success ?.none :.notUpdated(scriptname:scriptName))
                }else{
                    completion(false,.notUpdated(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func deleteRecord(id:String, action:String, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        var scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.components
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.frameColors.delete {
            scriptName = serverScriptNames.FRAMES.COLORS.delete
            className = "\(Frames.colors.self)"
        }else if action == dbActions.PHP.frameStyle.delete {
            scriptName = serverScriptNames.FRAMES.STYLES.delete
            className = "\(Frames.style.self)"
        }else if action == dbActions.PHP.frameSize.delete {
            scriptName = serverScriptNames.FRAMES.SIZES.delete
            className = "\(Frames.sizes.self)"
        }else if action == dbActions.PHP.matteColors.delete {
            scriptName = serverScriptNames.FRAMES.MATTECOLORS.delete
            className = "\(Frames.matteColors.self)"
        }else if action == dbActions.PHP.photoSize.delete {
            scriptName = serverScriptNames.FRAMES.PHOTOSIZES.delete
            className = "\(Frames.photoSizes.self)"
        }else if action == dbActions.PHP.frameShapes.delete {
            scriptName = serverScriptNames.FRAMES.SHAPES.delete
            className = "\(Frames.shape.self)"
        }else if action == dbActions.PHP.products.delete {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.products
            scriptName = serverScriptNames.FRAMES.PRODUCTS.delete
            className = "\(Frames.products.self)"
        }else{ return completion(false,.script_NotFound(scriptname: scriptName)) }

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else {
            return completion(false,.script_CreationFailed(scriptname: scriptName))
        }
        
        let params:Alamofire.Parameters = [
            "id" : id,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        waitHUD().showNow(msg: "\( dbActions.DELETE.verb ) \( className )...") 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["success"] as? Bool {

                    completion(success,success ?.none :.notDeleted(scriptname:scriptName))
                }else{
                    completion(false,.notDeleted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func addRecord(params:Alamofire.Parameters,action:String, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        var scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.components
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.frameColors.add {
            scriptName = serverScriptNames.FRAMES.COLORS.add
            className = "\(Frames.colors.self)"
        }else if action == dbActions.PHP.frameStyle.add {
            scriptName = serverScriptNames.FRAMES.STYLES.add
            className = "\(Frames.style.self)"
        }else if action == dbActions.PHP.frameSize.add {
            scriptName = serverScriptNames.FRAMES.SIZES.add
            className = "\(Frames.sizes.self)"
        }else if action == dbActions.PHP.matteColors.add {
            scriptName = serverScriptNames.FRAMES.MATTECOLORS.add
            className = "\(Frames.matteColors.self)"
        }else if action == dbActions.PHP.photoSize.add {
            scriptName = serverScriptNames.FRAMES.PHOTOSIZES.add
            className = "\(Frames.photoSizes.self)"
        }else if action == dbActions.PHP.frameShapes.add {
            scriptName = serverScriptNames.FRAMES.SHAPES.add
            className = "\(Frames.shape.self)"
        }else if action == dbActions.PHP.products.add {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.products
            scriptName = serverScriptNames.FRAMES.PRODUCTS.add
            className = "\(Frames.products.self)"
        }else{ return completion(false,.script_NotFound(scriptname: scriptName)) }

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else {
            return completion(false,.script_CreationFailed(scriptname: scriptName))
        }
        
        waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            
            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["success"] as? Bool {

                    sharedFunc.ALERT().show(
                        title:"CMS \( success ?"SUCCESS" :"FAILURE" )",
                        style:.error,
                        msg:"\( dbActions.INSERT.noun ) \( className ) \( success ?"successful" :"failed." )."
                    )
                    completion(success,success ?.none :.notInserted(scriptname:scriptName))
                }else{
                    completion(false,.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

// MARK: - *** STRUCTS ***
    struct SKU:Codable,Loopable {
        static let separator:String = "-"

        var frameSize:String
        var frameColor:String
        var frameShape:String
        var frameStyle:String
        var matteColor:String

        init (
            frameSize:String? = "",
            frameColor:String? = "",
            frameShape:String? = "",
            frameStyle:String? = "",
            matteColor:String? = ""
        ){
            self.frameSize = frameSize!
            self.frameColor = frameColor!
            self.frameShape = frameShape!
            self.frameStyle = frameStyle!
            self.matteColor = matteColor!
        }
        
        var formatted:String {
            return "\(self.frameSize)-\(self.frameColor)-\(self.frameShape)-\(self.frameStyle)-\(self.matteColor)"
        }
        
        var description:String {
            return "\(self.frameSize) \(self.frameShape) \(self.frameColor) frame in \(self.frameStyle) Style w/\(self.matteColor) matte."
        }
        
        // MARK: - *** FUNCTIONS ***
        func structFromString(SKUstring:String) -> SKU {
            let components = SKUstring.components(separatedBy: SKU.separator)
            
            if components.count == 5 {
                return SKU.init(
                    frameSize: components[0],
                    frameColor: components[1],
                    frameShape: components[2],
                    frameStyle: components[3],
                    matteColor: components[4]
                )
            }else{
                return SKU.init()
            }
        }
        
        func isValid() -> Bool {
            if self.frameSize.isEmpty ||
               self.frameColor.isEmpty ||
               self.frameShape.isEmpty ||
               self.frameStyle.isEmpty ||
               self.matteColor.isEmpty {
               
                return false
            }else{
                return true
            }
        }
    }
    
// MARK: - ******************************
// MARK: PRODUCTS
// MARK: ****************************** -
    struct products:Codable,Loopable {
        var id:Int // Primary Index.
        var SKU:String
        var name:String
        var description:String
        var photoSize:String // Link to photo size table
        var frameShape:String // Link to frame shape table
        var frameColor:String // Link to frame color table
        var frameSize:String // Link to frame size table
        var frameStyle:String // Link to frame style table
        var matteColor:String // Link to matte color table
        var frameMaterial:String // Link to frame material table
        var cost:String // Manufactured cost
        var price:String // selling price
        var taxable:String
        var reorder:String
        var qty:String
        var legacy:String
        var image:String
        var moltinID:String // Molitin ID
        var moltinSKU:String // Moltin Slug
        var active:String
        var notes:String
        
        init (
            id:Int? = -1,
            SKU:String? = "",
            name:String? = "",
            description:String? = "",
            photoSize:String? = "",
            frameShape:String? = "",
            frameColor:String? = "",
            frameSize:String? = "",
            frameStyle:String? = "",
            matteColor:String? = "",
            frameMaterial:String? = "",
            cost:String? = "0.00",
            price:String? = "0.00",
            taxable:String? = "1",
            reorder:String? = "0",
            qty:String? = "0",
            legacy:String? = "0",
            image:String? = "",
            moltinID:String? = "",
            moltinSKU:String? = "",
            active:String? = "1",
            notes:String? = ""
        ){
            self.id = id!
            self.SKU = SKU!
            self.name = name!
            self.description = description!
            self.photoSize = photoSize!
            self.frameShape = frameShape!
            self.frameColor = frameColor!
            self.frameSize = frameSize!
            self.frameStyle = frameStyle!
            self.matteColor = matteColor!
            self.frameMaterial = frameMaterial!
            self.cost = cost!
            self.price = price!
            self.taxable = taxable!
            self.reorder = reorder!
            self.qty = qty!
            self.legacy = legacy!
            self.image = image!
            self.moltinID = moltinID!
            self.moltinSKU = moltinSKU!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "").intValue
            self.SKU = dictionary["SKU"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.photoSize = dictionary["photoSize"] as? String ?? ""
            self.frameShape = dictionary["frameShape"] as? String ?? ""
            self.frameColor = dictionary["frameColor"] as? String ?? ""
            self.frameSize = dictionary["frameSize"] as? String ?? ""
            self.frameStyle = dictionary["frameStyle"] as? String ?? ""
            self.matteColor = dictionary["matteColor"] as? String ?? ""
            self.frameMaterial = dictionary["frameMaterial"] as? String ?? ""
            self.cost = dictionary["cost"] as? String ?? ""
            self.price = dictionary["price"] as? String ?? ""
            self.taxable = dictionary["taxable"] as? String ?? ""
            self.reorder = dictionary["reorder"] as? String ?? ""
            self.qty = dictionary["qty"] as? String ?? ""
            self.legacy = dictionary["legacy"] as? String ?? ""
            self.image = dictionary["image"] as? String ?? ""
            self.moltinID = dictionary["moltinID"] as? String ?? ""
            self.moltinSKU = dictionary["moltinSKU"] as? String ?? ""
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.products] {
            var arr:[Frames.products] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.products.init(dictionary: dict)) }
        
            return arr
        }

        struct prefTitles {
            static let SKU = "SKU"
            static let name = "name"
            static let Description = "Description"
            static let photoSize = "Photo Size"
            static let frameShape = "Frame Shape"
            static let frameColor = "Frame Color"
            static let frameSize = "Frame Size"
            static let frameStyle = "Frame Style"
            static let matteColor = "Matte Color"
            static let frameMaterial = "Frame Material"
            static let cost = "Cost"
            static let price = "Price"
            static let taxable = "Taxable"
            static let reorder = "Reorder (Min. Qty)"
            static let qty = "Quantity (In Stock)"
            static let legacy = "Quantity (In Stock)"
            static let image = "Quantity (In Stock)"
            static let moltinID = "Moltin ID (Legacy products only)"
            static let moltinSKU = "Moltin SKU (Legacy products only)"
            static let active = "Active (Available for ordering)"
            static let notes = "Notes"
        }
        
        struct prefKeys {
            static let id = "Frames.products.id"
            static let sku = "Frames.products.sku"
            static let name = "Frames.products.name"
            static let description = "Frames.products.description"
            static let photoSize = "Frames.products.photoSize"
            static let frameShape = "Frames.products.frameShape"
            static let frameColor = "Frames.products.frameColor"
            static let frameSize = "Frames.products.frameSize"
            static let frameStyle = "Frames.products.frameStyle"
            static let matteColor = "Frames.products.matteColor"
            static let frameMaterial = "Frames.products.frameMaterial"
            static let cost = "Frames.products.cost"
            static let price = "Frames.products.price"
            static let taxable = "Frames.products.taxable"
            static let reorder = "Frames.products.reorder"
            static let qty = "Frames.products.qty"
            static let legacy = "Frames.products.legacy"
            static let image = "Frames.products.image"
            static let moltinID = "Frames.products.moltinID"
            static let moltinSKU = "Frames.products.moltinSKU"
            static let active = "Frames.products.active"
            static let notes = "Frames.products.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "sku" : SKU,
                "name" : name,
                "description" : description,
                "photoSize" : photoSize,
                "frameShape" : frameShape,
                "frameColor" : frameColor,
                "frameSize" : frameSize,
                "frameStyle" : frameStyle,
                "matteColor" : matteColor,
                "frameMaterial" : frameMaterial,
                "cost" : cost,
                "price" : price,
                "taxable" : taxable,
                "reorder" : reorder,
                "qty" : qty,
                "legacy" : legacy,
                "image" : image,
                "moltinID" : moltinID,
                "moltinSKU" : moltinSKU,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** PRODUCTS FUNCTIONS ***
        func returnProductSkuFrom(photoSize:String,frameSize:String,frameColor:String) -> String? {
            let frameSizeToLookFor = "\(photoSize)-\(frameSize)"
            let SKU:String = CMS_products.filter({
                ($0.frameColor.uppercased() == frameColor.uppercased()) &&
                ($0.frameSize.uppercased() == frameSizeToLookFor.uppercased())
            }).first?.SKU ?? ""
            
            return SKU.isEmpty ?nil :SKU
        }

        func returnProductPrice(SKU: String) -> (price:Double,formatted:String) {
            let price:Double = CMS_products.filter({$0.SKU == SKU }).first?.price.doubleValue ?? 0.00
            let formatted:String = (price.truncatingRemainder(dividingBy: 1) == 0) ?"$\(Int(price))" :String(format:"$%0.2f",price)
            
            return (price,formatted)
        }

        func returnProductShape(SKU: String) -> (code:String,name:String,localized:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.frameShape ?? ""
            var name:String = CMS_frame_shapes.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            if name.uppercased().contains("RECT") { name = "Rectangular" }
            
            return (code,name,name.localized())
        }
        
        func returnProductColor(SKU: String) -> (code:String,name:String,localized:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.frameColor ?? ""
            let name:String = CMS_frame_colors.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            
            return (code,name,name.localized())
        }

        func returnProductMatteColor(SKU: String) -> (code:String,name:String,localized:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.matteColor ?? ""
            let name:String = CMS_matte_Colors.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            
            return (code,name,name.localized())
        }
        
        func returnProductPhotoSize(SKU: String) -> (code:String,name:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.photoSize ?? ""
            let name:String = CMS_photo_Sizes.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            
            return (code,name)
        }
        
        func returnProductFramedSize(SKU: String) -> (code:String,name:String,nameDecimal:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.frameSize ?? ""
            let name:String = CMS_frame_sizes.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            let height:String = CMS_frame_sizes.filter({ $0.code.uppercased() == code.uppercased() }).first?.height ?? ""
            let width:String = CMS_frame_sizes.filter({ $0.code.uppercased() == code.uppercased() }).first?.height ?? ""
            let nameDecimal = "\(height)x\(width)"

            return (code,name,nameDecimal)
        }
        
        func returnProductMaterial(SKU: String) -> (code:String,name:String,localized:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.frameMaterial ?? ""
            let name:String = CMS_frame_materials.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            
            return (code,name,name.localized())
        }
        
        func returnProductStyle(SKU: String) -> (code:String,name:String,localized:String) {
            let code:String = CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.frameStyle ?? ""
            let name:String = CMS_frame_styles.filter({ $0.code.uppercased() == code.uppercased() }).first?.name ?? ""
            
            return (code,name,name.localized())
        }
        
        func returnProductFormat(shape: String) -> Int {
            return CMS_frame_shapes.filter({ $0.code.uppercased() == shape }).first?.formatIndx ?? 0
        }
        
        func returnProductImg(SKU: String) -> UIImage {
            let name:String =  CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.image ?? ""
            let img:UIImage = UIImage(named: name ) ?? UIImage.init()
            
            simPrint().info("img Filename: \( name )",function:#function,line:#line)
            
            return img
        }
        
        func returnProductImgName(SKU: String) -> String {
            let name:String =  CMS_products.filter({ $0.SKU.uppercased() == SKU.uppercased() }).first?.image ?? ""

            return name
        }
        
        func isSlimLine(SKU: String) -> Bool {
            let records = CMS_products.filter({
                ($0.SKU.uppercased() == SKU.uppercased()) &&
                ($0.frameStyle.uppercased() == "SL")
            })
            
            return Bool(records.count > 0)
        }
        
        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Frames.products],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.PRODUCTS.list
            let className = Frames().name
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.products!)/\(scriptName)")
            else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }

            let params:Alamofire.Parameters = [
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]

            if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.products]>) in
                if showMsg! { waitHUD().hideNow() }

                switch response.result {
                case .success:
                    completion(true,response.result.value!,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            }
        }

        func inStock(showMsg:Bool? = false,SKU:String,completion: @escaping (Bool,[Frames.products],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.PRODUCTS.inStock
            let className = Frames().name
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.products!)/\(scriptName)")
            else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }

            let params:Alamofire.Parameters = [
                "SKU" : SKU,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]

            if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") } 
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
                    let items = Frames.products().returnArray(arrayOfDictionaries: results.records)
                    
                    completion(true,items,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            })
        }
    }
    
// MARK: -
// MARK: - ******************************
// MARK: FRAME SIZES
// MARK: ****************************** -
    struct sizes:Codable,Loopable {
        var id:String // Primary Index.
        var code:String
        var name:String
        var description:String
        var height:String
        var width:String
        var depth:String
        var weight:String
        var image:String
        var photoSize:String // Link to Photo Size table
        var minPhotoScale:Int
        var frameShape:String
        var frameStyle:String
        var frameMaterial:String
        var getStartedDisplayOrder:Int
        var active:String
        var notes:String
        
        init (
            id:String? = "",
            code:String? = "",
            name:String? = "",
            description:String? = "",
            height:String? = "",
            width:String? = "",
            depth:String? = "",
            weight:String? = "",
            image:String? = "",
            photoSize:String? = "",
            minPhotoScale:Int? = 1,
            frameShape:String? = "",
            frameStyle:String? = "",
            frameMaterial:String? = "",
            getStartedDisplayOrder:Int? = 0,
            active:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.code = code!
            self.name = name!
            self.description = description!
            self.height = height!
            self.width = width!
            self.depth = depth!
            self.weight = weight!
            self.image = image!
            self.photoSize = photoSize!
            self.minPhotoScale = minPhotoScale!
            self.frameShape = frameShape!
            self.frameStyle = frameStyle!
            self.frameMaterial = frameMaterial!
            self.getStartedDisplayOrder = getStartedDisplayOrder!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.height = dictionary["height"] as? String ?? ""
            self.width = dictionary["width"] as? String ?? ""
            self.depth = dictionary["depth"] as? String ?? ""
            self.weight = dictionary["weight"] as? String ?? ""
            self.image = dictionary["image"] as? String ?? ""
            self.photoSize = dictionary["photoSize"] as? String ?? ""
            self.minPhotoScale = (dictionary["minPhotoScale"] as? String ?? "").intValue
            self.frameShape = dictionary["frameShape"] as? String ?? ""
            self.frameStyle = dictionary["frameStyle"] as? String ?? ""
            self.frameMaterial = dictionary["frameMaterial"] as? String ?? ""
            self.getStartedDisplayOrder = (dictionary["getStartedDisplayOrder"] as? String ?? "").intValue
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.sizes] {
            var arr:[Frames.sizes] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.sizes.init(dictionary: dict)) }
        
            return arr
        }
        
        struct prefTitles {
            static let Code = "Code"
            static let Description = "Description"
            static let Name = "Name"
            static let PhotoSize = "Photo Size"
            static let MinPhotoScale = "Photo Scale (<= 5-Inch use 1, >5-inch use 2) "
            static let FrameShape = "Frame Shape"
            static let FrameStyle = "Frame Style"
            static let FrameMaterials = "Frame Materials"
            static let getStartedDisplayOrder = "Display Order (Get Started)"
            static let Image = "Image"
            static let Height = "Height (in decimal inches. ex: 4.25)"
            static let Width = "Width (in decimal inches. ex: 6.00)"
            static let Depth = "Depth (in decimal inches. ex: 0.50)"
            static let Weight = "Weight (in decimal pounds. ex: 1.70)"
        }

        struct prefKeys {
            static let id = "Frames.sizes.id"
            static let name = "Frames.sizes.name"
            static let description = "Frames.sizes.description"
            static let code = "Frames.sizes.code"
            static let width = "Frames.sizes.width"
            static let height = "Frames.sizes.height"
            static let depth = "Frames.sizes.depth"
            static let weight = "Frames.sizes.weight"
            static let image = "Frames.sizes.image"
            static let photoSize = "Frames.sizes.photoSize"
            static let minPhotoScale = "Frames.sizes.minPhotoScale"
            static let frameShape = "Frames.sizes.shape"
            static let frameStyle = "Frames.sizes.style"
            static let frameMaterials = "Frames.sizes.frameMaterials"
            static let getStartedDisplayOrder = "Frames.sizes.getStartedDisplayOrder"
            static let active = "Frames.sizes.active"
            static let notes = "Frames.sizes.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "width" : width,
                "height" : height,
                "depth" : depth,
                "weight" : weight,
                "image" : image,
                "photoSize" : photoSize,
                "minPhotoScale" : minPhotoScale,
                "frameShape" : frameShape,
                "frameStyle" : frameStyle,
                "frameMaterials" : frameMaterial,
                "getStartedDisplayOrder" : getStartedDisplayOrder,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Frames.sizes],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.size
            let className = Frames().name
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
                else {
                    return completion(false,[],.script_CreationFailed(scriptname: scriptName))
            }
            
            let params:Alamofire.Parameters = [
                "action" : dbActions.PHP.list,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.sizes]>) in
                if showMsg! { waitHUD().hideNow() }

                switch response.result {
                case .success:
                    completion(true,response.result.value!,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            }
        }
    }
    
//MARK: -
    struct matteColors:Codable,Loopable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var code:String
        var active:String
        var notes:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            code:String? = "",
            active:String? = "",
            notes:String? = ""
            ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.code = code!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.matteColors] {
            var arr:[Frames.matteColors] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.matteColors.init(dictionary: dict)) }
        
            return arr
        }
        
        struct prefKeys {
            static let id = "Frames.matteColors.id"
            static let name = "Frames.matteColors.name"
            static let description = "Frames.matteColors.description"
            static let code = "Frames.matteColors.code"
            static let active = "Frames.matteColors.active"
            static let notes = "Frames.matteColors.notes"
        }

        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Frames.matteColors],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.matteColor
            let className = Frames().name
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
                else {
                    return completion(false,[],.script_CreationFailed(scriptname: scriptName))
            }
            
            let params:Alamofire.Parameters = [
                "action" : dbActions.PHP.list,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
                .validate(statusCode: 200..<300)
                .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
                .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.matteColors]>) in
                    if showMsg! { waitHUD().hideNow() }
                    
                    switch response.result {
                    case .success:
                        completion(true,response.result.value!,.none)
                    case .failure(let error):
                        completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                    }
            }
        }
    }

//MARK: -
    struct photoSizes:Codable,Loopable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var code:String
        var active:String
        var notes:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            code:String? = "",
            active:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.code = code!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.photoSizes] {
            var arr:[Frames.photoSizes] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.photoSizes.init(dictionary: dict)) }
            
            return arr
        }
        
        struct prefKeys {
            static let id = "Frames.photoSizes.id"
            static let name = "Frames.photoSizes.name"
            static let description = "Frames.photoSizes.description"
            static let code = "Frames.photoSizes.code"
            static let active = "Frames.photoSizes.active"
            static let notes = "Frames.photoSizes.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Frames.photoSizes],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.PHOTOSIZES.List
            let className = Frames.photoSizes.self
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
                else {
                    return completion(false,[],.script_CreationFailed(scriptname: scriptName))
            }
            
            let params:Alamofire.Parameters = [
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
                .validate(statusCode: 200..<300)
                .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
                .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.photoSizes]>) in
                    if showMsg! { waitHUD().hideNow() }
                    
                    switch response.result {
                    case .success:
                        completion(true,response.result.value!,.none)
                    case .failure(let error):
                        completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                    }
            }
        }
    }

//MARK: -
    struct materials:Codable,Loopable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var code:String
        var active:String
        var notes:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            code:String? = "",
            active:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.code = code!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.materials] {
            var arr:[Frames.materials] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.materials.init(dictionary: dict)) }
            
            return arr
        }
        
        struct prefKeys {
            static let id = "Frames.materials"
            static let name = "Frames.materials.name"
            static let description = "Frames.materials.description"
            static let code = "Frames.materials.code"
            static let active = "Frames.materials.active"
            static let notes = "Frames.materials.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Frames.materials],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.MATERIALS.List
            let className = Frames.materials.self
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
            else {
                return completion(false,[],.script_CreationFailed(scriptname: scriptName))
            }
            
            let params:Alamofire.Parameters = [
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") }
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.materials]>) in
                if showMsg! { waitHUD().hideNow() }
                
                switch response.result {
                case .success:
                    completion(true,response.result.value!,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            }
        }
    }

//MARK: -
    struct colors:Codable,Loopable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var code:String
        var displayOrder:String
        var active:String
        var notes:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            code:String? = "",
            displayOrder:String? = "",
            active:String? = "",
            notes:String? = ""
            ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.code = code!
            self.displayOrder = displayOrder!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.displayOrder = dictionary["displayOrder"] as? String ?? ""
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.colors] {
            var arr:[Frames.colors] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.colors.init(dictionary: dict)) }
        
            return arr
        }
        
        struct prefKeys {
            static let id = "Frames.colors.id"
            static let name = "Frames.colors.name"
            static let description = "Frames.colors.description"
            static let code = "Frames.colors.code"
            static let displayOrder = "Frames.colors.displayOrder"
            static let active = "Frames.colors.active"
            static let notes = "Frames.colors.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "displayOrder" : displayOrder,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
        func multi(showMsg:Bool? = false,action:String,code:String? = "",id:String? = "",data:Frames.colors? = Frames.colors.init(), completion: @escaping (Bool,[Frames.colors],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.color
            let className = "Frame Color"
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
            else {
                return completion(false,[],.script_CreationFailed(scriptname: scriptName))
            }
            
            var params:Alamofire.Parameters = [
                "action" : action,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
            
            var action_noun = "", action_verb = ""
            if action == dbActions.PHP.exists {
                params.updateValue(code!, forKey: "code")
                action_noun = dbActions.UPDATE.noun
                action_verb = dbActions.UPDATE.verb
            }else if action == dbActions.PHP.edit {
                params.updateValue(data!.id, forKey: "id")
                params.updateValue(data!.name, forKey: "name")
                params.updateValue(data!.description, forKey: "description")
                params.updateValue(data!.code, forKey: "code")
                params.updateValue(data!.active, forKey: "active")
                params.updateValue(data!.notes, forKey: "notes")
                action_noun = dbActions.UPDATE.noun
                action_verb = dbActions.UPDATE.verb
            }else if action == dbActions.PHP.list {
                action_noun = dbActions.LIST.noun
                action_verb = dbActions.LIST.verb
            }else if action == dbActions.PHP.search {
                action_noun = dbActions.SEARCH.noun
                action_verb = dbActions.SEARCH.verb
            }
            
            if showMsg! { waitHUD().showNow(msg: "\( action_verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
// MARK: ├─➤ (Insert/Update/Delete)
            .responseJSON(completionHandler: { response in
                if showMsg! { waitHUD().hideNow() }
                
                switch response.result {
                case .success:
                    if let JSONdict = response.result.value as? [String:Any],
                       let success = JSONdict["success"] as? Bool {
                        if showMsg! {
                            sharedFunc.ALERT().show(
                                title:"CMS \( success ?"SUCCESS" :"FAILURE" )",
                                style:.error,
                                msg:"\( action_noun ) \( className ) \( success ?"successful" :"failed." )."
                            )
                        }
                        completion(success,[],success ?.none :.notUpdated(scriptname:scriptName))
                    }else{
                        completion(false,[],.notUpdated(scriptname:scriptName))
                    }
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            })
// MARK: ├─➤ (List/Search)
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.colors]>) in
                if showMsg! { waitHUD().hideNow() }
                
                switch response.result {
                case .success:
                    completion(true,response.result.value!,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            }
        }
    }

//MARK:-
    struct style:Codable,Loopable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var code:String
        var active:String
        var notes:String

        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            code:String? = "",
            active:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.code = code!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.style] {
            var arr:[Frames.style] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.style.init(dictionary: dict)) }
        
            return arr
        }
        
        struct prefKeys {
            static let id = "Frames.style.id"
            static let name = "Frames.style.name"
            static let description = "Frames.style.description"
            static let code = "Frames.style.code"
            static let width = "Frames.style.weight"
            static let height = "Frames.style.height"
            static let depth = "Frames.style.depth"
            static let weight = "Frames.style.weight"
            static let images = "Frames.style.images"
            static let active = "Frames.style.active"
            static let notes = "Frames.style.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }

        // MARK: - *** FUNCTIONS ***
        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Frames.style],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.FRAMES.style
            let className = Frames().name
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
            else {
                return completion(false,[],.script_CreationFailed(scriptname: scriptName))
            }

            let params:Alamofire.Parameters = [
                "action" : dbActions.PHP.list,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]

            if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            Alamofire.request(scriptURL, parameters:params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Frames.style]>) in
                if showMsg! { waitHUD().hideNow() }

                switch response.result {
                case .success:
                    completion(true,response.result.value!,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            }
        }
    }

//MARK:-
    struct shape:Codable,Loopable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var code:String
        var formatIndx:Int
        var active:String
        var notes:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            code:String? = "",
            formatIndx:Int? = 0,
            active:String? = "",
            notes:String? = ""
            ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.code = code!
            self.formatIndx = formatIndx!
            self.active = active!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.code = dictionary["code"] as? String ?? ""
            self.formatIndx = Int(dictionary["formatIndx"] as? String ?? "") ?? 0
            self.active = dictionary["active"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Frames.shape] {
            var arr:[Frames.shape] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Frames.shape.init(dictionary: dict)) }
            
            return arr
        }
        
        struct prefKeys {
            static let id = "Frames.shape.id"
            static let name = "Frames.shape.name"
            static let description = "Frames.shape.description"
            static let code = "Frames.shape.code"
            static let formatIndx = "Frames.shape.formatIndx"
            static let active = "Frames.shape.active"
            static let notes = "Frames.shape.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "code" : code,
                "formatIndx" : formatIndx,
                "active" : active,
                "notes" : notes,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
    }
}

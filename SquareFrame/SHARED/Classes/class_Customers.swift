/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Customers.swift
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
class Customers:NSObject,Loopable {
    let Version:String = "1.01"
    let name:String = "Customers"
    
    // MARK: - *** FUNCTIONS ***
    func searchByEmailOrAdd(showMsg:Bool? = false, email:String, completion: @escaping (Bool,Customers.customer,Customers.address,cmsError) -> Void) {
        var customerRec = Customers.customer.init()
        var addressRec = Customers.address.init()
        
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,customerRec,addressRec,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CUSTOMER.searchOrAdd
        let className = Customers().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.customers!)/\(scriptName)")
        else { return completion(false,customerRec,addressRec,.script_CreationFailed(scriptname: scriptName)) }
        
        if order.customer_countryCode.isEmpty { order.customer_countryCode = "US" }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") } 
        let params:Alamofire.Parameters = [
            "firstName": order.customer_firstName,
            "lastName": order.customer_lastName,
            "address1": order.customer_address1,
            "address2": order.customer_address2,
            "city": order.customer_city,
            "stateCode": order.customer_stateCode,
            "zip": sharedFunc.STRINGS().stripZipCodeFormatting(text: order.customer_zip),
            "countryCode": order.customer_countryCode,
            "phone": sharedFunc.STRINGS().stripPhoneNumFormatting(text: order.customer_phone),
            "email": email,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)

            switch response.result {
            case .success:
                let _ = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if let JSONdict = response.result.value as? [String:Any],
                   let customerRecords = JSONdict["customer"] as? [String:Any] {

                    addressRec = Customers.address.init()
                    if let addressRecords = JSONdict["address"] as? [String:Any] {
                        addressRec = Customers.address.init(dictionary: addressRecords)
                    }

                    customerRec = Customers.customer.init(dictionary: customerRecords)
                    let success = ((customerRec.id > 0) && (addressRec.id > 0))
                    
                    completion(success,customerRec,addressRec,.none)
                }else{
                    completion(false,customerRec,addressRec,.none)
                }
            case .failure(let error):
                completion(false,customerRec,addressRec,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func search(showMsg:Bool? = false, email:String, completion: @escaping (Bool,Customers.customer,Customers.address,cmsError) -> Void) {
        var customerRec = Customers.customer.init()
        var addressRec = Customers.address.init()
        
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,customerRec,addressRec,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CUSTOMER.search
        let className = Customers().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.customers!)/\(scriptName)")
        else { return completion(false,customerRec,addressRec,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") }
        let params:Alamofire.Parameters = [
            "email": email,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)

            switch response.result {
            case .success:
                let _ = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                if let JSONdict = response.result.value as? [String:Any],
                   let customerRecords = JSONdict["customer"] as? [String:Any],
                   let addressRecords = JSONdict["address"] as? [String:Any] {

                    customerRec = Customers.customer.init(dictionary: customerRecords)
                    addressRec = Customers.address.init(dictionary: addressRecords)
                    let success = ((customerRec.id > 0) && (addressRec.id > 0))
                    
                    completion(success,customerRec,addressRec,.none)
                }else{
                    completion(false,customerRec,addressRec,.none)
                }
            case .failure(let error):
                completion(false,customerRec,addressRec,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func mailingList_List(showMsg:Bool? = false, vc:UIViewController,completion: @escaping (Bool,[Customers.customer],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CUSTOMER.mailingList
        let className = Customers().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.mailingList!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") }
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response,scriptTitle: scriptName)
                if results.success {
                    let customers = Customers.customer().returnArray(arrayOfDictionaries:results.records)
                    completion(true,customers,.none)
                }else{
                    completion(false,[],.items_NotFound)
                }
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func componentsList(showMsg:Bool? = false,completion: @escaping (Bool,[String:[AnyObject]],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[:],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CUSTOMER.componentsList
        let className = Customers().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.customers!)/\(scriptName)")
        else { return completion(false,[:],.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") }
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any] {
                    let customers = Customers.customer().returnArray(arrayOfDictionaries:(JSONdict["customers"] as? [[String:Any]])!)
                    let addresses = Customers.address().returnArray(arrayOfDictionaries:(JSONdict["addresses"] as? [[String:Any]])!)

                    var items:[String:[AnyObject]] = [:]
                        items.updateValue(customers as [AnyObject], forKey: "Customers")
                        items.updateValue(addresses as [AnyObject], forKey: "Addresses")

                    completion(true,items,.none)
                }else{
                    completion(false,[:],.items_NotFound)
                }
            case .failure(let error):
                completion(false,[:],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func updateMailingList(vc:UIViewController,newSetting:Bool,completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.CUSTOMER.mailingListUpdate
        let className = "Customer"
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.customers!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }

        let params:Alamofire.Parameters = [
            "id" : customerInfo.ID!,
            "mailingList" : newSetting,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...")
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseString(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponseString(response)
            
            switch response.result {
            case .success:
                completion(true,.none)
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func updateRecord(vc:UIViewController, showMsg:Bool? = true, params:Alamofire.Parameters,action:String,completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        var scriptPath:String = ""
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.customer.update {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.customers
            scriptName = serverScriptNames.CUSTOMER.update
            className = "\(Customers.customer.self)"
        }else if action == dbActions.PHP.address.update {
            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.addresses
            scriptName = serverScriptNames.ADDRESSES.update
            className = "\(Customers.address.self)"
        }else{ return completion(false,.script_NotFound(scriptname: scriptName)) }
        
        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") }
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

                if showMsg! {
                    sharedFunc.ALERT().show(
                        title: "CMS \( results.success.isTrue ?"SUCCESS" :"FAILURE" )",
                        style:.error,
                        msg:"\( dbActions.UPDATE.noun ) \( className ) \( results.success.isTrue ?"successful" :"failed." )."
                    )
                }

                completion(results.success,results.success ?.none :.notUpdated(scriptname:scriptName))
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func deleteRecord(id:String, action:String, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        var scriptName:String = ""
        var className = ""
        if action == dbActions.PHP.frameColors.delete {
            scriptName = serverScriptNames.FRAMES.COLORS.delete
            className = "\(Frames.colors.self)"
        }else if action == dbActions.PHP.frameStyle.delete {
            scriptName = serverScriptNames.FRAMES.STYLES.delete
            className = "\(Frames.style.self)"
        }else{ return completion(false,.script_NotFound(scriptname: scriptName)) }
        
        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.components!)/\(scriptName)")
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
                
                Server().dumpURLfromResponse(response)
                
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

    func addCustomerWithAddress(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters, completion: @escaping (Bool,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
        
        let scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.customers
        let scriptName:String = serverScriptNames.CUSTOMER.addWithAddress
        let className = "Customer Account"

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
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["success"] as? Bool,
                   let customerID = JSONdict["customerID"] as? Int {

                    if showMsg! {
                        sharedFunc.ALERT().show(
                            title: "CMS \( success ?"SUCCESS" :"FAILURE" )",
                            style:.error,
                            msg:"\( dbActions.INSERT.noun ) \( className ) \( success ?"successful" :"failed." )."
                        )
                    }
                    
                    completion(success,success ?customerID :-1, success ?.none :.notInserted(scriptname:scriptName))
                }else{
                    completion(false,-1,.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
//    func addCustomer(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters, completion: @escaping (Bool,Int,cmsError) -> Void) {
//        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
//
//        let scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.customers
//        let scriptName:String = serverScriptNames.CUSTOMER.add
//        let className = "Customer Account"
//
//        URLCache.shared.removeAllCachedResponses()
//        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
//            else { return completion(false,-1,.script_CreationFailed(scriptname: scriptName)) }
//
//        if showMsg! { waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") }
//        Server().dumpParams(params,scriptName: scriptName)
//
//        Alamofire.request(scriptURL, parameters:params)
//        .validate(statusCode: 200..<300)
//        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
//        .responseJSON(completionHandler: { response in
//            waitHUD().hideNow()
//            Server().dumpURLfromResponse(response)
//
//            switch response.result {
//            case .success:
//                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
//
//                if let JSONdict = response.result.value as? [String:Any],
//                   let customerID = JSONdict["customerID"] as? Int {
//
//                    if showMsg! {
//                        sharedFunc.ALERT().show(
//                            title: "CMS \( results.success ?"SUCCESS" :"FAILURE" )",
//                            style:.error,
//                            msg:"\( dbActions.INSERT.noun ) \( className ) \( results.success ?"successful" :"failed." )."
//                        )
//                    }
//
//                    completion(results.success,results.success ?customerID :-1, results.success ?.none :.notInserted(scriptname:scriptName))
//                }else{
//                    completion(false,-1,.notInserted(scriptname:scriptName))
//                }
//            case .failure(let error):
//                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
//            }
//        })
//    }
    
    func addAddress(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters, completion: @escaping (Bool,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
        
        let scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.addresses
        let scriptName:String = serverScriptNames.ADDRESSES.add
        let className = "Addresses"
        
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
                    let addressID = JSONdict["addressID"] as? Int {
                    
                    if showMsg! {
                        sharedFunc.ALERT().show(
                            title: "CMS \( results.success ?"SUCCESS" :"FAILURE" )",
                            style:.error,
                            msg:"\( dbActions.INSERT.noun ) \( className ) \( results.success ?"successful" :"failed." )."
                        )
                    }
                    
                    completion(results.success,results.success ?addressID :-1, results.success ?.none :.notInserted(scriptname:scriptName))
                }else{
                    completion(false,-1,.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func updateCustomerWithAddress(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters, completion: @escaping (Bool,Int,Int,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,-1,.network_Unavailable) }
        
        let scriptPath:String = appInfo.COMPANY.SERVER.SCRIPTS.customers
        let scriptName:String = serverScriptNames.CUSTOMER.updateWithAddress
        let className = "Customer Account"

        URLCache.shared.removeAllCachedResponses()
        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
        else { return completion(false,-1,-1,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") } 
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
                   let success = JSONdict["success"] as? Bool,
                   let customerID = JSONdict["customerID"] as? Int,
                   let addressID = JSONdict["addressID"] as? Int {

                    if showMsg! {
                        sharedFunc.ALERT().show(
                            title: "CMS \( success ?"SUCCESS" :"FAILURE" )",
                            style:.error,
                            msg:"\( dbActions.UPDATE.noun ) \( className ) \( success ?"successful" :"failed." )."
                        )
                    }
                    
                    completion(success,customerID,addressID, success ?.none :.notUpdated(scriptname: scriptName))
                }else{
                    completion(false,-1,-1,.notUpdated(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,-1,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
//    func addRecord(vc:UIViewController? = nil, showMsg:Bool? = false,params:Alamofire.Parameters,action:String, completion: @escaping (Bool,cmsError) -> Void) {
//        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
//
//        var scriptPath:String = ""
//        var scriptName:String = ""
//        var className = ""
//        if action == dbActions.PHP.address.add {
//            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.addresses
//            scriptName = serverScriptNames.ADDRESSES.add
//            className = "\(Customers.address.self)"
//        }else if action == dbActions.PHP.customer.add {
//            scriptPath = appInfo.COMPANY.SERVER.SCRIPTS.customers
//            scriptName = serverScriptNames.CUSTOMER.add
//            className = "\(Customers.customer.self)"
//        }else{ return completion(false,.script_NotFound(scriptname: scriptName)) }
//
//        URLCache.shared.removeAllCachedResponses()
//        guard let scriptURL = URL(string: "\(scriptPath)/\(scriptName)")
//        else {
//            return completion(false,.script_CreationFailed(scriptname: scriptName))
//        }
//
//        if showMsg! { waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") }
//        Server().dumpParams(params,scriptName: scriptName)
//
//        Alamofire.request(scriptURL, parameters:params)
//        .validate(statusCode: 200..<300)
//        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
//        .responseJSON(completionHandler: { response in
//            waitHUD().hideNow()
//            Server().dumpURLfromResponse(response)
//
//            switch response.result {
//            case .success:
//                if let JSONdict = response.result.value as? [String:Any],
//                   let success = JSONdict["success"] as? Bool {
//
//                    if showMsg! {
//                        sharedFunc.ALERT().show(
//                            title: "CMS \( success ?"SUCCESS" :"FAILURE" )",
//                            style:.error,
//                            msg:"\( dbActions.INSERT.noun ) \( className ) \( success ?"successful" :"failed." )."
//                        )
//                    }
//                    completion(success,success ?.none :.notInserted(scriptname:scriptName))
//                }else{
//                    completion(false,.notInserted(scriptname:scriptName))
//                }
//            case .failure(let error):
//                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
//            }
//        })
//    }
    
    
    // MARK: - *** STRUCTS ***
    struct customer:Codable,Loopable {
        var id:Int // Primary Index.
        var firstName:String
        var lastName:String
        var phone:String
        var email:String
        var mailingList:Int
        var addressID:Int
        var moltinID:String
        var stripeID:String
        var notes:String

        init (
            id:Int? = -1,
            firstName:String? = "",
            lastName:String? = "",
            phone:String? = "",
            email:String? = "",
            mailingList:Int? = 1,
            addressID:Int? = -1,
            moltinID:String? = "",
            stripeID:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.firstName = firstName!.trimSpacesAndNewlines
            self.lastName = lastName!.trimSpacesAndNewlines
            self.phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone!.trimSpacesAndNewlines)
            self.email = email!.trimSpacesAndNewlines
            self.mailingList = mailingList!
            self.addressID = addressID!
            self.moltinID = moltinID!
            self.stripeID = stripeID!
            self.notes = notes!
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "").intValue
            self.firstName = dictionary["firstName"] as? String ?? ""
            self.lastName = dictionary["lastName"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.mailingList = (dictionary["mailingList"] as? String ?? "").intValue
            self.addressID = (dictionary["addressID"] as? String ?? "").intValue
            self.moltinID = dictionary["moltinID"] as? String ?? ""
            self.stripeID = dictionary["stripeID"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        
        func convertStructToDictionary(structure:Customers.customer) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id, forKey: "id")
                dict.updateValue(structure.firstName.trimSpacesAndNewlines, forKey: "firstName")
                dict.updateValue(structure.lastName.trimSpacesAndNewlines, forKey: "lastName")
                dict.updateValue(structure.phone.trimSpacesAndNewlines, forKey: "phone")
                dict.updateValue(structure.email.trimSpacesAndNewlines, forKey: "email")
                dict.updateValue(structure.mailingList, forKey: "mailingList")
                dict.updateValue(structure.addressID, forKey: "addressID")
                dict.updateValue(structure.moltinID, forKey: "moltinID")
                dict.updateValue(structure.stripeID, forKey: "stripeID")
                dict.updateValue(structure.notes, forKey: "notes")
            
            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Customers.customer] {
            var arr:[Customers.customer] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Customers.customer.init(dictionary: dict)) }
            
            return arr
        }
        
        struct prefKeys {
            static let id = "Customers.customer.id"
            static let firstName = "Customers.customer.firstName"
            static let lastName = "Customers.customer.lastName"
            static let phone = "Customers.customer.phone"
            static let email = "Customers.customer.email"
            static let mailingList = "Customers.customer.mailingList"
            static let addressID = "Customers.customer.addressID"
            static let moltinID = "Customers.customer.moltinID"
            static let stripeID = "Customers.customer.stripeID"
            static let notes = "Customers.customer.notes"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "firstName" : firstName,
                "lastName" : lastName,
                "phone" : sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone),
                "email" : email,
                "mailingList" : mailingList,
                "notes" : notes,
                "addressID":addressID,
                "moltinID" : moltinID,
                "stripeID" : stripeID,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }

        // MARK: - *** FUNCTIONS ***
    }

    
// MARK: - *********************************************************
// MARK: STRUCT: ADDRESS
// MARK: *********************************************************
    struct address:Codable,Loopable {
        var id:Int // Primary Index.
        var customerID:Int // Link to Customer
        var firstName:String
        var lastName:String
        var address1:String
        var address2:String
        var city:String
        var stateCode:String
        var zip:String
        var countryCode:String
        var phone:String
        var email:String
        var moltinID:String

        init (
            id:Int? = -1,
            customerID:Int? = -1,
            firstName:String? = "",
            lastName:String? = "",
            address1:String? = "",
            address2:String? = "",
            city:String? = "",
            stateCode:String? = "",
            zip:String? = "",
            countryCode:String? = "",
            phone:String? = "",
            email:String? = "",
            moltinID:String? = ""
        ){
            self.id = id!
            self.customerID = customerID!
            self.firstName = firstName!.trimSpacesAndNewlines
            self.lastName = lastName!.trimSpacesAndNewlines
            self.address1 = address1!.trimSpacesAndNewlines
            self.address2 = address2!.trimSpacesAndNewlines
            self.city = city!.trimSpacesAndNewlines
            self.stateCode = stateCode!.trimSpacesAndNewlines
            self.zip = sharedFunc.STRINGS().stripZipCodeFormatting(text: zip!.trimSpacesAndNewlines)
            self.countryCode = countryCode!.trimSpacesAndNewlines
            self.phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone!.trimSpacesAndNewlines)
            self.email = email!.trimSpacesAndNewlines
            self.moltinID = moltinID!.trimSpacesAndNewlines
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.customerID = (dictionary["customerID"] as? String ?? "-1").intValue
            self.firstName = dictionary["firstName"] as? String ?? ""
            self.lastName = dictionary["lastName"] as? String ?? ""
            self.address1 = dictionary["address1"] as? String ?? ""
            self.address2 = dictionary["address2"] as? String ?? ""
            self.city = dictionary["city"] as? String ?? ""
            self.stateCode = dictionary["stateCode"] as? String ?? ""
            self.zip = dictionary["zip"] as? String ?? ""
            self.countryCode = dictionary["countryCode"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.moltinID = dictionary["moltinID"] as? String ?? ""
        }

        func convertStructToDictionary(structure:Customers.address) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id, forKey: "id")
                dict.updateValue(structure.customerID, forKey: "customerID")
                dict.updateValue(structure.firstName.trimSpacesAndNewlines, forKey: "firstName")
                dict.updateValue(structure.lastName.trimSpacesAndNewlines, forKey: "lastName")
                dict.updateValue(structure.address1.trimSpacesAndNewlines, forKey: "address1")
                dict.updateValue(structure.address2.trimSpacesAndNewlines, forKey: "address2")
                dict.updateValue(structure.city.trimSpacesAndNewlines, forKey: "city")
                dict.updateValue(structure.stateCode.trimSpacesAndNewlines, forKey: "stateCode")
                dict.updateValue(structure.zip.trimSpacesAndNewlines, forKey: "zip")
                dict.updateValue(structure.countryCode.trimSpacesAndNewlines, forKey: "countryCode")
                dict.updateValue(structure.phone.trimSpacesAndNewlines, forKey: "phone")
                dict.updateValue(structure.email.trimSpacesAndNewlines, forKey: "email")
                dict.updateValue(structure.email.trimSpacesAndNewlines, forKey: "moltinID")

            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Customers.address] {
            var arr:[Customers.address] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Customers.address.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[Customers.address]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (address) in arr.append(Customers.address().convertStructToDictionary(structure: address) ) }
            
            return arr
        }
        
        func isFilledOut() -> Bool {
            return (
                self.firstName.isNotEmpty &&
                self.lastName.isNotEmpty &&
                self.address1.isNotEmpty &&
                self.city.isNotEmpty &&
                self.stateCode.isNotEmpty &&
                self.zip.isNotEmpty &&
                self.countryCode.isNotEmpty
            )
        }
        
        struct prefKeys {
            static let id = "Customers.address.id"
            static let customerID = "Customers.address.customerID"
            static let firstName = "Customers.address.firstName"
            static let lastName = "Customers.address.lastName"
            static let address1 = "Customers.address.address1"
            static let address2 = "Customers.address.address2"
            static let city = "Customers.address.city"
            static let stateCode = "Customers.address.stateCode"
            static let zip = "Customers.address.zip"
            static let countryCode = "Customers.address.countryCode"
            static let phone = "Customers.address.phone"
            static let email = "Customers.address.email"
            static let moltinID = "Customers.address.moltinID"
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "customerID" : customerID,
                "firstName" : firstName,
                "lastName" : lastName,
                "address1" : address1,
                "address2" : address2,
                "city" : city,
                "stateCode" : stateCode,
                "zip" : sharedFunc.STRINGS().stripZipCodeFormatting(text: zip),
                "countryCode" : countryCode,
                "phone" : sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone),
                "email" : email,
                "moltinID" : moltinID,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        // MARK: - *** FUNCTIONS ***
        func searchForMatch(showMsg:Bool? = false, address:Customers.address, completion: @escaping (Bool,Int,cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.ADDRESSES.searchForMatch
            let className = "Addresses"
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.addresses!)/\(scriptName)")
            else { return completion(false,-1,.script_CreationFailed(scriptname: scriptName)) }
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") } 
            let params:Alamofire.Parameters = address.params!
            
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
                    let addressID = results.found
                    simPrint().info("\( print(addressID) )",function:#function,line:#line)
                    completion(results.success,addressID,results.success ?.none :.items_NotFound)
                case .failure(let error):
                    completion(false,-1,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            })
        }

        func search(showMsg:Bool? = false, customerID:Int, completion: @escaping (Bool,[Customers.address],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.ADDRESSES.allByCustomerID
            let className = "Addresses"
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.addresses!)/\(scriptName)")
            else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( className )...") } 
            let params:Alamofire.Parameters = [
                "customerID": customerID,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]

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

                    if results.found > 0 {
                        completion(true,Customers.address().returnArray(arrayOfDictionaries: results.records),.none)
                    }else{
                        completion(false,[],.items_NotFound)
                    }
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            })
        }
        
        func addRecords(showMsg:Bool? = false,params:Alamofire.Parameters, completion: @escaping (Bool,cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.ADDRESSES.add
            let className = Customers.address.self
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.addresses!)/\(scriptName)")
            else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
            
            let params:Alamofire.Parameters = [
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" :appInfo.EDITION.appEdition!
            ]
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") } 
            Server().dumpParams(params,scriptName: scriptName)

            waitHUD().showNow(msg: "\( dbActions.INSERT.verb ) \( className )...") 
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
                            title: "CMS \( success ?"SUCCESS" :"FAILURE" )",
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

        func list(showMsg:Bool? = false,completion: @escaping (Bool,[Customers.address],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.ADDRESSES.search
            let className = Customers.address.self
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.addresses!)/\(scriptName)")
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
            .responseJSON(completionHandler: { response in
//            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Customers.address]>) in
                if showMsg! { waitHUD().hideNow() }
                
                print(response.request?.url ?? "")
                
                switch response.result {
                case .success:
                    let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)

                    if results.found > 0 {
                        completion(true,Customers.address().returnArray(arrayOfDictionaries: results.records),.none)
                    }else{
                        completion(false,[],.items_NotFound)
                    }
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            })
        }
    }
}

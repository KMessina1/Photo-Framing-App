/*--------------------------------------------------------------------------------------------------------------------------
     File: class_EmailAddresses.swift
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
class EmailAddresses:NSObject {
    let Version:String = "1.03"
    let name:String = "Email Addresses"
    
    struct PhPMailerStruct{
        var orders:String = ""
        var developer:String = ""
        var fulfillment:String = ""
        var manager:String = ""
        var info:String = ""
        var support:String = ""

        init(
            orders:String = "",
            developer:String = "",
            fulfillment:String = "",
            manager:String = "",
            info:String = "",
            support:String = ""
        ) {
            self.orders = orders
            self.developer = developer
            self.fulfillment = fulfillment
            self.manager = manager
            self.info = manager
            self.support = manager
        }
        
        var isFilledOut:Bool{
            return
                self.orders.isNotEmpty &&
                self.developer.isNotEmpty &&
                self.fulfillment.isNotEmpty &&
                self.manager.isNotEmpty &&
                self.info.isNotEmpty &&
                self.support.isNotEmpty
        }
    }
    
    struct emailAddressStruct:Codable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var address:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            address:String? = ""
        ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.address = address!
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "")
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.address = dictionary["address"] as? String ?? ""
        }
        
        func convertStructToDictionary(structure:EmailAddresses.emailAddressStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
            dict.updateValue(structure.id, forKey: "id")
            dict.updateValue(structure.name, forKey: "name")
            dict.updateValue(structure.description, forKey: "description")
            dict.updateValue(structure.address, forKey: "address")
            
            return dict
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [EmailAddresses.emailAddressStruct] {
            var arr:[EmailAddresses.emailAddressStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(EmailAddresses.emailAddressStruct.init(dictionary: dict)) }
            
            return arr
        }

        var params:Alamofire.Parameters? { return [
            "id" : id,
            "name" : name,
            "description" : description,
            "address" : address,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]}
    }
    
    // MARK: - *** FUNCTIONS ***
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[EmailAddresses.emailAddressStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.EMAILADDRESSES.list
        let className = EmailAddresses().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.mailer!)/\(scriptName)")
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
            if showMsg! { waitHUD().hideNow() }
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
            let success = results.success
            
            switch response.result {
            case .success:
                if success.isTrue {
                    let records = EmailAddresses.emailAddressStruct().returnArray(arrayOfDictionaries: results.records)
                    
                    if (records.count > 0) {
                        for record in records {
                            switch record.name.uppercased() {
                                case "ORDERS": mailerAddresses.orders = record.address
                                case "DEVELOPER": mailerAddresses.developer = record.address
                                case "FULFILLMENT": mailerAddresses.fulfillment = record.address
                                case "MANAGER": mailerAddresses.manager = record.address
                                case "INFO": mailerAddresses.info = record.address
                                case "SUPPORT": mailerAddresses.support = record.address
                                default: ()
                            }
                        }
                    }

                    completion(true,records,.none)
                }else{
                    completion(false,[],.notFound(scriptname: scriptName))
                }
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    func update(showMsg:Bool? = false,id:String, params:Alamofire.Parameters, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.EMAILADDRESSES.update
        let className = EmailAddresses().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.mailer!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") }
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
            let success = results.success
            
            switch response.result {
            case .success:
                if success.isTrue {
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
}

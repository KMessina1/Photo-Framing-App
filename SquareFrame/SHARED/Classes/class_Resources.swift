/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Resources.swift
   Author: Kevin Messina
  Created: Apr 29, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class Resources:NSObject {
    var Version: String { return "1.00" }
    var name: String { return "Resources" }
    
// MARK: - *********************************************************
// MARK: FUNCTIONS
// MARK: *********************************************************
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[Resources.ResourcesStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.RESOURCES.list
        let className = ScriptLogs().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.resources!)/\(scriptName)")
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
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                let items = Resources.ResourcesStruct().returnArray(arrayOfDictionaries:results.records)
                
                completion(true,items,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
   

// MARK: - *********************************************************
// MARK: STRUCTS
// MARK: *********************************************************
    struct ResourcesStruct:Codable,Loopable {
        var id:Int! // Primary Index
        var name:String!
        var websiteURL:String!
        var service:String!
        var login:String!
        var password:String!
        var notes:String!
        var active:Bool!

        init (
            id:Int? = -1,
            name:String? = "",
            websiteURL:String? = "",
            service:String? = "",
            login:String? = "",
            password:String? = "",
            notes:String? = "",
            active:Bool? = false
        ){
            self.id = id!
            self.name = name!
            self.websiteURL = websiteURL!
            self.service = service!
            self.login = login!
            self.password = password!
            self.notes = notes!
            self.active = active!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id!,
                "name" : name!,
                "websiteURL" : websiteURL!,
                "service" : service!,
                "login" : login!,
                "password" : password!,
                "notes" : notes!,
                "active" : active!
            ]
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.name = dictionary["name"] as? String ?? ""
            self.websiteURL = dictionary["websiteURL"] as? String ?? ""
            self.service = dictionary["service"] as? String ?? ""
            self.login = dictionary["login"] as? String ?? ""
            self.password = dictionary["password"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
            self.active = (dictionary["active"] as? String ?? "0").boolValue
        }
        

        func convertStructToDictionary(structure:Resources.ResourcesStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id!, forKey: "id")
                dict.updateValue(structure.name!, forKey: "name")
                dict.updateValue(structure.websiteURL!, forKey: "websiteURL")
                dict.updateValue(structure.service!, forKey: "service")
                dict.updateValue(structure.login!, forKey: "login")
                dict.updateValue(structure.password!, forKey: "password")
                dict.updateValue(structure.notes!, forKey: "notes")
                dict.updateValue(structure.active!, forKey: "active")

            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Resources.ResourcesStruct] {
            var arr:[Resources.ResourcesStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Resources.ResourcesStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[Resources.ResourcesStruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (item) in arr.append(Resources.ResourcesStruct().convertStructToDictionary(structure: item) ) }
            
            return arr
        }
    }
}

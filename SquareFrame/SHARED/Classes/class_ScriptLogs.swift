/*--------------------------------------------------------------------------------------------------------------------------
     File: class_ScriptLogs.swift
   Author: Kevin Messina
  Created: Apr 6, 2018
 Modified: Aug 27, 2018

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class ScriptLogs:NSObject {
    var Version: String { return "1.01" }
    var name: String { return "ScriptLogs" }
    
// MARK: - *********************************************************
// MARK: FUNCTIONS
// MARK: *********************************************************
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[stringAndCountStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.SCRIPTLOGS.list
        let className = ScriptLogs().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.scriptLogs!)/\(scriptName)")
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
                let items = stringAndCountStruct().returnArray(arrayOfDictionaries:results.records)
                
                completion(true,items,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
   
    func listCategory(
        showMsg:Bool? = false,
        category:String,
        date:String,
        limit:Int? = 500,
        completion: @escaping (Bool,[ScriptLogsStruct],cmsError) -> Void)
    {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
         
         URLCache.shared.removeAllCachedResponses()
         let scriptName = serverScriptNames.SCRIPTLOGS.listCategory
         let className = ScriptLogs().name
         guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.scriptLogs!)/\(scriptName)")
         else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
         
         if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") }

         let params:Alamofire.Parameters = [
             "category":category,
             "date":date,
             "limit":limit!,
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
                 let items = ScriptLogsStruct().returnArray(arrayOfDictionaries:results.records)
                 
                 completion(true,items,.none)
             case .failure(let error):
                 completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
             }
         })
     }
    

// MARK: - *********************************************************
// MARK: STRUCTS
// MARK: *********************************************************
    struct categories {
        static let name:[String] = [
            "All",
            "Accounts",
            "Addresses",
            "Coupons",
            "CMS Services",
            "Customers",
            "Knowledgebase",
            "Mailer",
            "Mailing List",
            "Orders",
            "Payments",
            "ScriptLogs"
        ]
    }

    struct ScriptLogsStruct:Codable,Loopable {
        var id:Int! // Primary Index
        var orderID:Int!
        var dateAndTime:String!
        var date:String!
        var time:String!
        var success:Bool!
        var category:String!
        var script:String!
        var callingApp:String!
        var stack:String!

        init (
            id:Int? = -1,
            orderID:Int? = 0,
            dateAndTime:String? = "",
            date:String? = "",
            time:String? = "",
            success:Bool? = false,
            category:String? = "",
            script:String? = "",
            callingApp:String? = "",
            stack:String? = ""
        ){
            self.id = id!
            self.orderID = orderID!
            self.dateAndTime = dateAndTime!
            self.date = date!
            self.time = time!
            self.success = success!
            self.category = category!
            self.script = script!
            self.callingApp = callingApp!
            self.stack = stack!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id!,
                "orderID" : orderID!,
                "dateAndTime" : dateAndTime!,
                "time" : time!,
                "success" : success!,
                "category" : category!,
                "script" : script!,
                "callingApp" : callingApp!,
                "stack" : stack!,
                "appVersion" : Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.orderID = (dictionary["orderID"] as? String ?? "-1").intValue
            self.dateAndTime = dictionary["dateAndTime"] as? String ?? ""
            self.date = dictionary["date"] as? String ?? ""
            self.time = dictionary["time"] as? String ?? ""
            self.success = (dictionary["success"] as? String ?? "").boolValue
            self.category = dictionary["category"] as? String ?? ""
            self.script = dictionary["script"] as? String ?? ""
            self.callingApp = dictionary["callingApp"] as? String ?? ""
            self.stack = dictionary["stack"] as? String ?? ""
        }

        func convertStructToDictionary(structure:ScriptLogs.ScriptLogsStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id!, forKey: "id")
                dict.updateValue(structure.orderID!, forKey: "orderID")
                dict.updateValue(structure.dateAndTime!, forKey: "dateAndTime")
                dict.updateValue(structure.date!, forKey: "date")
                dict.updateValue(structure.time!, forKey: "time")
                dict.updateValue(structure.success!, forKey: "success")
                dict.updateValue(structure.category!, forKey: "category")
                dict.updateValue(structure.script!, forKey: "script")
                dict.updateValue(structure.callingApp!, forKey: "callingApp")
                dict.updateValue(structure.stack!, forKey: "stack")

            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [ScriptLogs.ScriptLogsStruct] {
            var arr:[ScriptLogs.ScriptLogsStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(ScriptLogs.ScriptLogsStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[ScriptLogs.ScriptLogsStruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (item) in arr.append(ScriptLogs.ScriptLogsStruct().convertStructToDictionary(structure: item) ) }
            
            return arr
        }
    }
}

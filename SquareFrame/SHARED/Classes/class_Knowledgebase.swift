/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Knowledgebase.swift
   Author: Kevin Messina
  Created: Apr 6, 2018
 Modified: Aug 26, 2018

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class Knowledgebase:NSObject {
    var Version: String { return "1.00" }
    var name: String { return "Knowledgebase" }
    
// MARK: - *********************************************************
// MARK: FUNCTIONS
// MARK: *********************************************************
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[Knowledgebase.knowledgebaseStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.KNOWLEDGEBASE.list
        let className = Knowledgebase().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.knowledgebase!)/\(scriptName)")
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
                let items = Knowledgebase.knowledgebaseStruct().returnArray(arrayOfDictionaries:results.records)
                
                completion(true,items,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
   

// MARK: - *********************************************************
// MARK: STRUCTS
// MARK: *********************************************************
    struct assignTo {
        enum num:Int { case Administrator,Developer,Fulfillment }
        static let name:[String] = ["Administrator","Developer","Fulfillment"]
    }
    
    struct participants {
        enum num:Int { case Administrator,Developer,Fulfillment }
        static let name:[String] = ["Administrator","Developer","Fulfillment"]
    }
    
    struct categories {
        enum num:Int { case addresses,coupons,customers,frameGallery,orders,other,payments }
        static let name:[String] = ["Addresses","Coupons","Customers","Frame Gallery","Orders","Other","Payments"]
    }
    
    struct subCategories {
        enum num:Int { case documents }
        static let name:[String] = ["Documents","Best Practice","Information","Miscellaneous","Other"]
    }
    
    struct subSubCategories {
        enum num:Int { case photos,orderConf,company,shipment }
        static let name:[String] = ["Photos","Order Confirmation","Company Order Docs","Shipment Confirmation",
                                    "Miscellaneous","Best Practice","Other"]
    }
    
    struct apps {
        enum num:Int { case SFAdmin,SFAppStore,CMS,Other }
        static let name:[String] = ["SF-Admin","SF AppStore","SF-Admin, SF AppStore","CMS","Other"]
    }
    
    struct knowledgebaseStruct:Codable,Loopable {
        var id:Int! // Primary Index
        var app:String! //enum
        var category:String! //enum
        var subCategory:String!  //enum
        var subSubCategory:String! //enum
        var task:String!
        var assignTo:String! //enum
        var participants:String! //set
        var requirements:String!
        var suggestions:String!
        var instructions:String!
        var notes:String!

        init (
            id:Int? = -1,
            app:String? = "",
            category:String? = "",
            subCategory:String? = "",
            subSubCategory:String? = "",
            task:String? = "",
            assignTo:String? = "",
            participants:String? = "",
            requirements:String? = "",
            suggestions:String? = "",
            instructions:String? = "",
            notes:String? = ""
        ){
            self.id = id!
            self.app = app!
            self.category = category!
            self.subCategory = subCategory!
            self.subSubCategory = subSubCategory!
            self.task = task!
            self.assignTo = assignTo!
            self.participants = participants!
            self.requirements = requirements!
            self.suggestions = suggestions!
            self.instructions = instructions!
            self.notes = notes!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id!,
                "app" : app!,
                "category" : category!,
                "subCategory" : subCategory!,
                "subSubCategory" : subSubCategory!,
                "task" : task!,
                "assignTo" : assignTo!,
                "participants" : participants!,
                "requirements" : requirements!,
                "suggestions" : suggestions!,
                "instructions" : instructions!,
                "notes" : notes!,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.app = dictionary["app"] as? String ?? ""
            self.category = dictionary["category"] as? String ?? ""
            self.subCategory = dictionary["subCategory"] as? String ?? ""
            self.subSubCategory = dictionary["subSubCategory"] as? String ?? ""
            self.task = dictionary["task"] as? String ?? ""
            self.assignTo = dictionary["assignTo"] as? String ?? ""
            self.participants = dictionary["participants"] as? String ?? ""
            self.requirements = dictionary["requirements"] as? String ?? ""
            self.suggestions = dictionary["suggestions"] as? String ?? ""
            self.instructions = dictionary["instructions"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
        }
        

        func convertStructToDictionary(structure:Knowledgebase.knowledgebaseStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id!, forKey: "id")
                dict.updateValue(structure.app!, forKey: "app")
                dict.updateValue(structure.category!, forKey: "category")
                dict.updateValue(structure.subCategory!, forKey: "subCategory")
                dict.updateValue(structure.task!, forKey: "task")
                dict.updateValue(structure.assignTo!, forKey: "assignTo")
                dict.updateValue(structure.participants!, forKey: "participants")
                dict.updateValue(structure.requirements!, forKey: "requirements")
                dict.updateValue(structure.suggestions!, forKey: "suggestions")
                dict.updateValue(structure.instructions!, forKey: "instructions")
                dict.updateValue(structure.notes!, forKey: "notes")

            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Knowledgebase.knowledgebaseStruct] {
            var arr:[Knowledgebase.knowledgebaseStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Knowledgebase.knowledgebaseStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[Knowledgebase.knowledgebaseStruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (item) in arr.append(Knowledgebase.knowledgebaseStruct().convertStructToDictionary(structure: item) ) }
            
            return arr
        }
    }
}

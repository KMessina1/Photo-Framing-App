/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Teams.swift
   Author: Kevin Messina
  Created: Apr 6, 2018
 Modified: Aug 29, 2018

 ©2018-2020Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class Teams:NSObject {
    var Version: String { return "1.00" }
    var name: String { return "Teams" }
    
// MARK: - *********************************************************
// MARK: FUNCTIONS
// MARK: *********************************************************
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[Teams.TeamsStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.TEAMS.list
        let className = Teams().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.teams!)/\(scriptName)")
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
                let items = Teams.TeamsStruct().returnArray(arrayOfDictionaries:results.records)
                
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
        enum num:Int { case all,software,graphics,server,database,fulfillment,socialMedia,marketing,webDesign,other }
        
        static let name:[String] = [
            "All","Software","Graphics","Server","Database","Fulfillment","Social Media","Marketing","Web Design","Other"
        ]
    }
    
    struct TeamsStruct:Codable,Loopable {
        var id:Int! // Primary Index
        var firstName:String!
        var lastName:String!
        var address1:String!
        var address2:String!
        var city:String!
        var state:String!
        var zip:String!
        var country:String!
        var email:String!
        var phone:String!
        var websiteURL:String!
        var company:String!
        var category:String! //enum
        var title:String!
        var skills:String!
        var history:String!
        var notes:String!
        var active:Bool!

        init (
            id:Int? = -1,
            firstName:String? = "",
            lastName:String? = "",
            address1:String? = "",
            address2:String? = "",
            city:String? = "",
            state:String? = "",
            zip:String? = "",
            country:String? = "",
            email:String? = "",
            phone:String? = "",
            websiteURL:String? = "",
            company:String? = "",
            category:String? = "",
            title:String? = "",
            skills:String? = "",
            history:String? = "",
            notes:String? = "",
            active:Bool? = false
        ){
            self.id = id!
            self.firstName = firstName!
            self.lastName = lastName!
            self.address1 = address1!
            self.address2 = address2!
            self.city = city!
            self.state = state!
            self.zip = zip!
            self.country = country!
            self.email = email!
            self.phone = phone!
            self.websiteURL = websiteURL!
            self.company = company!
            self.category = category!
            self.title = title!
            self.skills = skills!
            self.history = history!
            self.notes = notes!
            self.active = active!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id!,
                "firstName" : firstName!,
                "lastName" : lastName!,
                "address1" : address1!,
                "address2" : address2!,
                "city" : city!,
                "state" : state!,
                "zip" : zip!,
                "country" : country!,
                "email" : email!,
                "phone" : phone!,
                "websiteURL" : websiteURL!,
                "company" : company!,
                "category" : category!,
                "title" : title!,
                "skills" : skills!,
                "history" : history!,
                "notes" : notes!,
                "active" : active!,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.firstName = dictionary["firstName"] as? String ?? ""
            self.lastName = dictionary["lastName"] as? String ?? ""
            self.address1 = dictionary["address1"] as? String ?? ""
            self.address2 = dictionary["address2"] as? String ?? ""
            self.city = dictionary["city"] as? String ?? ""
            self.state = dictionary["state"] as? String ?? ""
            self.zip = dictionary["zip"] as? String ?? ""
            self.country = dictionary["country"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.websiteURL = dictionary["websiteURL"] as? String ?? ""
            self.company = dictionary["company"] as? String ?? ""
            self.category = dictionary["category"] as? String ?? ""
            self.title = dictionary["title"] as? String ?? ""
            self.skills = dictionary["skills"] as? String ?? ""
            self.history = dictionary["history"] as? String ?? ""
            self.notes = dictionary["notes"] as? String ?? ""
            self.active = (dictionary["active"] as? String ?? "").boolValue
        }
        

        func convertStructToDictionary(structure:Teams.TeamsStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id!, forKey: "id")
                dict.updateValue(structure.firstName!, forKey: "firstName")
                dict.updateValue(structure.lastName!, forKey: "lastName")
                dict.updateValue(structure.address1!, forKey: "address1")
                dict.updateValue(structure.address2!, forKey: "address2")
                dict.updateValue(structure.city!, forKey: "city")
                dict.updateValue(structure.state!, forKey: "state")
                dict.updateValue(structure.zip!, forKey: "zip")
                dict.updateValue(structure.country!, forKey: "country")
                dict.updateValue(structure.email!, forKey: "email")
                dict.updateValue(structure.phone!, forKey: "phone")
                dict.updateValue(structure.websiteURL!, forKey: "websiteURL")
                dict.updateValue(structure.category!, forKey: "category")
                dict.updateValue(structure.company!, forKey: "company")
                dict.updateValue(structure.title!, forKey: "title")
                dict.updateValue(structure.skills!, forKey: "skills")
                dict.updateValue(structure.history!, forKey: "history")
                dict.updateValue(structure.notes!, forKey: "notes")
                dict.updateValue(structure.active!, forKey: "active")

            return dict
        }

        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Teams.TeamsStruct] {
            var arr:[Teams.TeamsStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Teams.TeamsStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[Teams.TeamsStruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (item) in arr.append(Teams.TeamsStruct().convertStructToDictionary(structure: item) ) }
            
            return arr
        }
    }
}

/*--------------------------------------------------------------------------------------------------------------------------
     File: class_FAQ.swift
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
class FAQs:NSObject {
    let Version:String = "1.01"
    let name:String = "FAQ"
    
    struct FAQstruct:Codable,Loopable {
        var id:Int! // Primary Index.
        var displayOrder:Int! // Order of appearance to sort by.
        var title_en:String! // English Title
        var body_en:String! // English Title
        var title_es:String! // Spanish Title
        var body_es:String! // Spanish Title
        
        init (
            id:Int? = -1,
            displayOrder:Int? = 0,
            title_en:String? = "",
            body_en:String? = "",
            title_es:String? = "",
            body_es:String? = ""
        ){
            self.id = id!
            self.displayOrder = displayOrder!
            self.title_en = title_en!
            self.body_en = body_en!
            self.title_es = title_es!
            self.body_es = body_es!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id!,
                "displayOrder" : displayOrder!,
                "title_en" : title_en!,
                "body_en" : body_en!,
                "title_es" : title_es!,
                "body_es" : body_es!,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
        
        init(dictionary:[String:Any]) {
            self.id = (dictionary["id"] as? String ?? "-1").intValue
            self.displayOrder = (dictionary["displayOrder"] as? String ?? "-1").intValue
            self.title_en = dictionary["title_en"] as? String ?? ""
            self.body_en = dictionary["body_en"] as? String ?? ""
            self.title_es = dictionary["title_es"] as? String ?? ""
            self.body_es = dictionary["body_es"] as? String ?? ""
        }
        
        
        func convertStructToDictionary(structure:FAQs.FAQstruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.id!, forKey: "id")
                dict.updateValue(structure.displayOrder!, forKey: "displayOrder")
                dict.updateValue(structure.title_en!, forKey: "title_en")
                dict.updateValue(structure.body_en!, forKey: "body_en")
                dict.updateValue(structure.title_es!, forKey: "title_es")
                dict.updateValue(structure.body_es!, forKey: "body_es")
            
            return dict
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [FAQs.FAQstruct] {
            var arr:[FAQs.FAQstruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(FAQs.FAQstruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[FAQs.FAQstruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (item) in arr.append(FAQs.FAQstruct().convertStructToDictionary(structure: item) ) }
            
            return arr
        }
    }
    
    struct categories {
        enum num:Int { case SQFrame }
        static let name:[String] = ["SQFrame"]
    }


// MARK: - *** FUNCTIONS ***
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[FAQs.FAQstruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.FAQ.list
        let className = FAQs().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.faq!)/\(scriptName)")
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
                let items = FAQs.FAQstruct().returnArray(arrayOfDictionaries:results.records)
                
                completion(true,items,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Passcodes.swift
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
class Passcodes:NSObject {
    let Version:String = "1.01"
    let name:String = "Passcodes"
    
    struct passcodeStruct:Codable {
        var id:String // Primary Index.
        var name:String
        var description:String
        var passcode:String
        
        init (
            id:String? = "",
            name:String? = "",
            description:String? = "",
            passcode:String? = ""
        ){
            self.id = id!
            self.name = name!
            self.description = description!
            self.passcode = passcode!
        }
        
        var params:Alamofire.Parameters? {
            return [
                "id" : id,
                "name" : name,
                "description" : description,
                "passcode" : passcode,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp" : appInfo.EDITION.appEdition!
            ]
        }
    }
    
// MARK: - *** FUNCTIONS ***
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[Passcodes.passcodeStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.PASSCODES.list
        let className = Passcodes().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.accounts!)/\(scriptName)")
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
        .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Passcodes.passcodeStruct]>) in
            if showMsg! { waitHUD().hideNow() }

            switch response.result {
            case .success:
                completion(true,response.result.value!,.none)
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        }
    }

    func update(showMsg:Bool? = false,id:String, params:Alamofire.Parameters, vc:UIViewController, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.PASSCODES.update
        let className = Passcodes().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.accounts!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( className )...") }
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
        
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)

                if results.success {
                    if showMsg! {
                        sharedFunc.ALERT().show(
                            title:"CMS \( results.success ?"SUCCESS" :"FAILURE" )",
                            style: results.success ?.success :.error,
                            msg:"\( dbActions.UPDATE.noun ) \( className ) \( results.success ?"successful" :"failed." )."
                        )
                    }

                    completion(results.success,results.success ?.none :.account_mismatch)
                }else{
                    completion(false,.account_notUpdated(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

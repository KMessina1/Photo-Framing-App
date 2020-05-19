/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Mailer.swift
   Author: Kevin Messina
  Created: Feb. 12, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class Mailer:NSObject {
    static let Version:String = "1.01"
    static let name:String = "Mailer"

    func displayErrorMsg(_ error:cmsError,vc:UIViewController) {
        let alert = UIAlertController(title: "CMS MAILER ERROR",message: "\(error.description).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in })
        vc.present(alert, animated: true)
    }
}

// MARK: -
class CustomerTracking:NSObject {
    let Version:String = "1.01"
    let name:String = "Customer: Tracking"
    
// MARK: - *** FUNCTIONS ***
    func send(params:Alamofire.Parameters, vc:UIViewController, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.EMAIL.CUSTOMER.tracking
        guard let scriptURL = URL(string:"\(appInfo.COMPANY.SERVER.phpMailScriptsFolder!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        waitHUD().showNow(msg: "\( dbActions.SEND.verb ) \( CustomerTracking().name )...") 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
        
            switch response.result {
            case .success:
                let _ = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                sharedFunc.ALERT().show(
                    title:"MAILER success",
                    style:.error,
                    msg:"\( dbActions.SEND.noun ) \( CustomerTracking().name ) successful."
                )
                completion(true,.none)
            case .failure(let error):
                if let err = response.result.error as? AFError {
                    Server().displayAlamoFireError(err,scriptTitle: scriptName)
                }else{
                    let msg = "Error Code: \(error._code)\n\n\(error.localizedDescription)"
                    simPrint().success(" |--> \(msg)",function:#function,line:#line)
                    sharedFunc.ALERT().show(
                        title:"MAILER ERROR",
                        style:.error,
                        msg:msg
                    )
                    completion(false,.alamoFire_failed(error:msg))
                }
            }
        })
    }
}

class CustomerOrderDocs:NSObject {
    let Version:String = "1.01"
    let name:String = "Customer: Order Docs"
    
// MARK: - *** FUNCTIONS ***
    func reSendToCompany(params:Alamofire.Parameters, vc:UIViewController, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.EMAIL.COMPANY.resendOrderFiles
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.phpMailScriptsFolder!)/\(scriptName)") else { return }

        waitHUD().showNow(msg: "\( dbActions.RESEND.verb ) \( CustomerOrderDocs().name )...")
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)
        
            switch response.result {
            case .success:
                let _ = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                sharedFunc.ALERT().show(
                    title:"MAILER success",
                    style:.error,
                    msg:"\( dbActions.RESEND.noun ) \( CustomerOrderDocs().name ) successful."
                )
                completion(true,.none)
            case .failure(let error):
                if let err = response.result.error as? AFError {
                    Server().displayAlamoFireError(err,scriptTitle: scriptName)
                }else{
                    let msg = "Error Code: \(error._code)\n\n\(error.localizedDescription)"
                    simPrint().success(" |--> \(msg)",function:#function,line:#line)
                    sharedFunc.ALERT().show(
                        title:"MAILER ERROR",
                        style:.error,
                        msg:msg
                    )
                    completion(false,.alamoFire_failed(error:msg))
                }
            }
        })
    }
}

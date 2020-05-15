/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_SalesTaxRestAPI.swift
  Author: Kevin Messina
 Created: September 7, 2016
Modified:
 
©2016-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES: Requires TaxJar account: https://app.taxjar.com/sign_in/
 
 2018_01_28 - Converted to closure/block process with returned value instead of callback.
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftyJSON
import Alamofire

@objc(CAS_SalesTax) class CAS_SalesTax:NSObject {
    var Version:String! { return "2.03" }
    
    struct TaxableState:Codable,Loopable {
        var id:Int!
        var name:String!
        var code:String!
        
        init (
            id:Int? = -1,
            name:String? = "",
            code:String? = ""
        ){
            self.id = id!
            self.name = name!
            self.code = code!
        }
        
        enum CodingKeys:String,CodingKey {
            case id,name,code
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try values.decode(String.self, forKey: .id).intValue
            self.name = try values.decode(String.self, forKey: .name)
            self.code = try values.decode(String.self, forKey: .code)
        }

        func list(showMsg:Bool? = false,completion: @escaping (Bool,[CAS_SalesTax.TaxableState],cmsError) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.SALESTAX.getTaxableStates
            let className = "Taxable State"
            guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.tax!)/\(scriptName)")
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
            .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[CAS_SalesTax.TaxableState]>) in
                if showMsg! { waitHUD().hideNow() }
                print(response.request?.url ?? "")
                
                switch response.result {
                case .success:
                    completion(true,response.result.value!,.none)
                case .failure(let error):
                    completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
                }
            }
        }
    }
    
    func getSalesTax(
        zipcode:String,
        rappleMsg:String? = "Searching TaxRates...",
        vc:UIViewController,
    completion: @escaping (Bool,Double) -> Void) {
        
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() {
            completion(false,0.00)
            return
        }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName:String = "Get TaxJar Sales Tax Rate"

        if zipcode.isNotEmpty {
            let headers: HTTPHeaders = ["Authorization": "Token token=\"\(SALESTAX.apiKey!)\""]
            
            Alamofire.request("\(SALESTAX.rateByZipcodeURL!)\(zipcode)",method: .get,headers: headers)
            .responseJSON { response in
// MARK: ├─➤ Alamo Response
                waitHUD().hideNow()

                switch response.result {
                case .success:
                    if let dict = response.result.value as? [String: Any?],
                       let taxString = (dict["rate"] as? [String: Any])?["combined_rate"] as? String,
                       let taxRate = Double(taxString) {
                        
                        simPrint().info("\( String(format: "\n\nTAXJAR CALCULATED TAX: %0.4f %%\n",taxRate) )",function:#function,line:#line)

                        if taxRate > 0.01 {
                            completion(true,taxRate)
                        }else{
                            completion(false,0.00)
                        }
                    }else{
                        completion(false,0.00)
                    }
                case .failure(let error):
// MARK: ├─➤ Alamo Errors
                    if error._code == NSURLErrorTimedOut {
                        sharedFunc.ALERT().show(title: "COMMUNICATIONS ERROR", style: .error, msg: "\n\(scriptName.uppercased())\n\ntimed-out with no response.")
                        simPrint().error("\n\n !! \(scriptName.uppercased())\n\ntimed-out with no response.",function:#function,line:#line)
                    }else{
                        if let err = response.result.error as? AFError {
                            Server().displayAlamoFireError(err,scriptTitle: scriptName)
                        }else{
                            simPrint().error("|--> \(scriptName) Failed: Sales Tax Rate not found.",function:#function,line:#line)
                            sharedFunc.ALERT().show(title: "SEARCH FAILED",
                                                    style: .serverError,
                                                    msg: "Error Code: \(error._code)\n\n\(error.localizedDescription)",
                                                    img: #imageLiteral(resourceName: "CAS_Server").recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                            )
                        }
                    }
                    
                    completion(false,0.00)
                }
            }
        }
    }
}

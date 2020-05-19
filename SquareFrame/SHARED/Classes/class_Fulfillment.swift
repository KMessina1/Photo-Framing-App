/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Fulfillment.swift
   Author: Kevin Messina
  Created: Apr 18, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire


// MARK: - *** STRUCT ***
public struct Fulfillment:Codable,Loopable {
    let Version:String = "1.01"
    let name:String = "Fulfillment"

    var id:Int!
    var company:String!
    var street1:String!
    var street2:String!
    var city:String!
    var stateCode:String!
    var zip:String!
    var countryCode:String!
    var phone:String!
    var defaultShippingPrice:Decimal!

    init (
        id:Int? = 0,
        company:String? = "",
        street1:String? = "",
        street2:String? = "",
        city:String? = "",
        stateCode:String? = "",
        zip:String? = "",
        countryCode:String? = "",
        phone:String? = "",
        defaultShippingPrice:Decimal? = 0.00
    ){
        self.id = id!
        self.company = company!
        self.street1 = street1!
        self.street2 = street2!
        self.city = city!
        self.stateCode = stateCode!
        self.zip = zip!
        self.countryCode = countryCode!
        self.phone = phone!
        self.defaultShippingPrice = defaultShippingPrice!
    }

    enum CodingKeys:String,CodingKey {
        case id,company,street1,street2,city,stateCode,zip,countryCode,phone,defaultShippingPrice
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id).intValue
        self.company = try values.decode(String.self, forKey: .company)
        self.street1 = try values.decode(String.self, forKey: .street1)
        self.street2 = try values.decode(String.self, forKey: .street2)
        self.city = try values.decode(String.self, forKey: .city)
        self.stateCode = try values.decode(String.self, forKey: .stateCode)
        self.zip = try values.decode(String.self, forKey: .zip)
        self.countryCode = try values.decode(String.self, forKey: .countryCode)
        self.phone = try values.decode(String.self, forKey: .phone)
        self.defaultShippingPrice = try Decimal(values.decode(String.self, forKey: .defaultShippingPrice).doubleValue)
    }

    // MARK: - *** FUNCTIONS ***
    func list(showMsg:Bool? = false,completion: @escaping (Bool,[Fulfillment],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.FULFILLMENT.getInfo
        let className = Fulfillment.self
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.fulfillment!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        Server().dumpParams(params,scriptName: scriptName) 
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseDecodableObject(keyPath: "records", decoder: jsonDecoder) { (response: DataResponse<[Fulfillment]>) in
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

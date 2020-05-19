/*--------------------------------------------------------------------------------------------------------------------------
     File: class_CustomerInfo.swift
   Author: Kevin Messina
  Created: Apr 17, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class CustomerInfo:Codable,Loopable {
    let Version:String = "1.01"
    let name:String = "Customer: Info"

    var ID:Int!
    var firstName:String!
    var lastName:String!
    var email:String!
    var phone:String!
    var mailingList:Bool!
    var address:Customers.address!

    init(
        ID:Int? = -1,
        firstName:String? = "",
        lastName:String? = "",
        email:String? = "",
        phone:String? = "",
        mailingList:Bool? = true,
        address:Customers.address? = Customers.address.init()
    ){
        self.ID = ID!
        self.firstName = firstName!
        self.lastName = lastName!
        self.email = email!
        self.phone = phone!
        self.mailingList = mailingList!
        self.address = address!
    }
    
    func isFilledOut() -> Bool {
        if customerInfo == nil {
            return false
        }
        
        return (
            (customerInfo.ID < 1) &&
            customerInfo.firstName.isNotEmpty &&
            customerInfo.lastName.isNotEmpty &&
            customerInfo.email.isNotEmpty &&
            customerInfo.phone.isNotEmpty &&
            customerInfo.address.address1.isNotEmpty &&
            customerInfo.address.city.isNotEmpty &&
            customerInfo.address.stateCode.isNotEmpty &&
            customerInfo.address.zip.isNotEmpty &&
            customerInfo.address.countryCode.isNotEmpty
        )
    }
    
    func isFilledOutWithoutID() -> Bool {
        if customerInfo == nil {
            return false
        }
        
        return (
            customerInfo.firstName.isNotEmpty &&
            customerInfo.lastName.isNotEmpty &&
            customerInfo.email.isNotEmpty
        )
    }
    
    var paramsFromCustomerInfoStruct:Alamofire.Parameters? {
        return [
            "customerID" : customerInfo.ID!,
            "firstName" : customerInfo.firstName!,
            "lastName" : customerInfo.lastName!,
            "phone" : sharedFunc.STRINGS().stripPhoneNumFormatting(text: customerInfo.phone!),
            "email" : customerInfo.email!,
            "addressID" : customerInfo.address.id,
            "address1" : customerInfo.address.address1,
            "address2" : customerInfo.address.address2,
            "city" : customerInfo.address.city,
            "stateCode" : customerInfo.address.stateCode,
            "zip" : sharedFunc.STRINGS().stripZipCodeFormatting(text: customerInfo.address.zip),
            "countryCode" : customerInfo.address.countryCode,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
    }
}


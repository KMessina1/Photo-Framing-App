/*--------------------------------------------------------------------------------------------------------------------------
     File: CMS_Globals_Globals.swift
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


// MARK: - *** GLOBAL CONSTANTS ***
public let jsonDecoder = JSONDecoder()

var CMS_defaulShipingRate:Decimal = 5.00
var mailerAddresses = EmailAddresses.PhPMailerStruct.init()
var shippingAddresses:[Customers.address] = []


// MARK: ├─➤ SalesTax
struct SALESTAX { // Uses TaxJar
    static let apiKey:String! = "a60873023c5f4fcf98dd2fd9641656c9"
    static let rateByZipcodeURL:String! = "https://api.taxjar.com/v2/rates/"
}

// MARK: ├─➤ Shipping
struct SHIPPING { // Uses Shippo
    struct APIKEY { // Shipping Calculation, requires CAS_eCommerce library
        static let siteURL:String! = "https://api.goshippo.com/"
        static let test:String! = "shippo_test_dbba9bf66994e34039790c61d2200867edf9ddb5"
        static let live:String! = "shippo_live_48661478a86be14569cf581e1508f0430d52ab92"
    }
}

// MARK: - ******************************
// MARK: CMS CLASS
// MARK: ****************************** -

class CMS:NSObject {
    let Version:String = "1.01"
    let name:String = "CMS Globals"
    
    func displayErrorMsg(_ error:cmsError,vc:UIViewController) {
        let alert = UIAlertController(title: "CMS SERVER ERROR",message: "\(error.description)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in })
        vc.present(alert, animated: true)
    }
    
    func processError(error:Error,scriptName:String) -> String {
        if let err = error as? AFError {
            Server().displayAlamoFireError(err,scriptTitle: scriptName)
            return err.errorDescription ?? ""
        }else{
            let msg = "Error Code: \(error._code)\n\n\(error.localizedDescription)"
            simPrint().error("|--> \(msg)",function:#function,line:#line)
            sharedFunc.ALERT().show(
                title:"CMS ERROR",
                style:.error,
                msg:msg
            )
            return msg
        }
    }
}

enum cmsError:Error {
    var description:String {
        var errorTxt:String = ""
        switch self {
        // ALAMO FIRE
        case .alamoFire_failed (let description): errorTxt = description
        // CODEABLE OBJECTS
        case .notInCodeableObjectFormat (let description): errorTxt = description
        // PASSCODES
        case .account_mismatch: errorTxt = "Passcode mismatch, access denied.\n\nRemember passcodes are case sensitive. Check capitalization."
        case .account_notUpdated (let description): errorTxt = description
        case .account_notLoggedIn (let description): errorTxt = description
        // RECORDS
        case .notCompleted (let description): errorTxt = "\((description)) - Order was not added."
        case .notUpdated (let description): errorTxt = "\((description)) - Item was not updated."
        case .notInserted (let description): errorTxt = "\((description)) - Item was not added."
        case .notDeleted (let description): errorTxt = "\((description)) - Item was not deleted."
        case .notFound (let description): errorTxt = "\((description)) - Item was not found."
        // SCRIPTS
        case .script_CreationFailed (let description): errorTxt = description
        case .script_NotFound (let description): errorTxt = description
        // Files
        case .files_NotFound: errorTxt = "Files not found."
        case .orderFiles_NotFound: errorTxt = "Order Files not found."
        // OTHER
        default: errorTxt = ""
        }
        
        return errorTxt
    }
    
    // ALAMO FIRE
    case alamoFire_failed(error:String)
    // CODEABLE OBJECTS
    case notInCodeableObjectFormat(struct:String)
    // PASSCODES
    case account_notUpdated(scriptname:String)
    case account_notLoggedIn(issue:String)
    case account_mismatch
    // RECORDS
    case notUpdated(scriptname:String)
    case notCompleted(scriptname:String)
    case notInserted(scriptname:String)
    case notDeleted(scriptname:String)
    case notFound(scriptname:String)
    // SCRIPTS
    case script_CreationFailed(scriptname:String)
    case script_NotFound(scriptname:String)
    // Files
    case files_NotFound
    case orderFiles_NotFound
    // OTHER
    case none
    case items_NotFound
    case network_Unavailable
}







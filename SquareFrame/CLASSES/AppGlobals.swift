/*--------------------------------------------------------------------------------------------------------------------------
 File: AppGlobals.swift
 Author: Kevin Messina
 Created: May 7, 2017

 ©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 --------------------------------------------------------------------------------------------------------------------------*/

import Alamofire

// MARK: - *** GLOBAL CONSTANTS ***

// MARK: ├─➤ Customers
var customerInfo:CustomerInfo!

// MARK: ├─➤ Instagram
var photos:[Photo] = [Photo].init()

// MARK: ├─➤ Alamo Fire
var AFmanager:Alamofire.SessionManager!
var AFuploadError:Bool = false
var AFdownloadError:Bool = false

// MARK: ├─➤ Orders
var CMS_cart:Cart!
var CMS_item:Orders.itemStruct!
var tempItem:TempItem!
var item:Item!
var order:Orders.orderStruct = Orders.orderStruct.init()
var selectedCoupon:Coupons.couponStruct = Coupons.couponStruct.init()
var selectedPayment:CREDITCARD.creditCARD = CREDITCARD.creditCARD.init()

// MARK: ├─➤ PDF Parameters
var pdfPageSize:PDF.PageSize_Settings!
var pdfCurrentVals:PDF.current!
var pdfAuthorInfo:[AnyHashable:Any]! = [:]


// MARK: - *** GLOBAL ENUM CONSTANTS ***
// MARK: ├─➤ Instagram
enum photoSource:Int { case UNSELECTED,PHOTOS }

let SQUARE = "Square"
let RECTANGLE = "Rectangle"
let RECTANGULAR = "Rectangular"
let STANDARD = "Standard"
let SLIMLINE = "Slimline"


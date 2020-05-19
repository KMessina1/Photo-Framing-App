/*--------------------------------------------------------------------------------------------------------------------------
    File: CMS_Pref_Keys.swift
  Author: Kevin Messina
 Created: Apr 10, 2018
 
 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 --------------------------------------------------------------------------------------------------------------------------*/


struct prefKeys {
    let Version:String = "1.01"
    let name:String = "Pref Keys"

    // MARK: -
    struct appVersion {
        static let lastLaunchVersion = "appVersion.lastLaunchVersion"
        static let settingsBundleVersion = "sbVersion"
    }
    
    // MARK: -
    struct selected {
        static let color = "selected.color"
        static let size = "selected.size"
        static let style = "selected.style"
    }
    
    // MARK: -
    struct infoOverlay {
        static let hasShown = "INFO_OVERLAY"
    }
    
    // MARK: -
    struct PDF {
        static let attachmentName = "PDF_AttachmentName"
        static let path = "PDF_ServerBasedFilenameAndPath"
    }
    
    // MARK: -
    struct Archive {
        static let orderInfo = "orderInfo"
        static let localCartInfo = "localCartInfo"
        static let customerInfo = "customerInfo"
        static let photosInfo = "photosInfo"
        static let passcode = "passcode"
        static let creditCard = "creditCard"
    }
    
    // MARK: -
    struct BillTo {
        static let firstName = "Account_BillingInfo.FirstName"
        static let lastName = "Account_BillingInfo.LastName"
        static let addr1 = "Account_BillingInfo.Addr1"
        static let addr2 = "Account_BillingInfo.Addr2"
        static let city = "Account_BillingInfo.City"
        static let state = "Account_BillingInfo.State"
        static let stateCode = "Account_BillingInfo.StateCode"
        static let zip = "Account_BillingInfo.Zip"
        static let country = "Account_BillingInfo.CountryName"
        static let countryCode = "Account_BillingInfo.CountryCode"
        static let phone = ""
    }
    
    // MARK: -
    struct Cart {
        static let itemCount = "cart.itemCount"
        static let uniqueItemCount = "cart.uniqueItemCount"
        static let subtotal = "cart.subTotal"
        static let taxRate = "cart.taxRate"
        static let salesTax = "cart.salesTax"
        static let shipping = "cart.shipping"
        static let total = "cart.total"
    }
    
    // MARK: -
    struct MyInfo {
        static let firstName = "Account_MyInfo.FirstName"
        static let lastName = "Account_MyInfo.LastName"
        static let addr1 = "Account_MyInfo.Addr1"
        static let addr2 = "Account_MyInfo.Addr2"
        static let city = "Account_MyInfo.City"
        static let state = "Account_MyInfo.State"
        static let stateCode = "Account_MyInfo.StateCode"
        static let zip = "Account_MyInfo.Zip"
        static let country = "Account_MyInfo.CountryName"
        static let countryCode = "Account_MyInfo.CountryCode"
        static let phone = "Account_MyInfo.Phone"
        static let email = "Account_MyInfo.Email"
        static let mailingList = "Account_MyInfo.mailingList"
        static let groupID = "Account_MyInfo.groupID"
        static let customerID = "Account_MyInfo.customerID"
        static let token = "settings_Token"
        static let orders_qty = "Account_MyInfo.orders_qty"
        static let orders_amt = "Account_MyInfo.orders_amt"
    }
    
    
    // MARK: -
    struct OrderInfo {
        static let giftMessage = "order.giftMessage"
        static let giftMessageOnOff = "order.giftMessageOnOff"
        static let progress = "order.progress"
        static let progressCode = "order.progressCode"
        static let issue = "order.issue"
        static let issueCode = "order.issueCode"
        static let status = "order.status"
        static let statusCode = "order.statusCode"
        static let number = "order.orderNum"
        static let date = "order.orderDate"
        static let dateFull = "order.orderDateFull"
        static let time = "order.time"
        static let itemsCount = "order.itemsCount"
        static let subTotal = "order.subTotal"
        static let tax = "order.tax"
        static let total = "order.total"
        static let coupon = "order.coupon" // Decodable Struct
        static let discount = "order.discount"
        static let photos_count = "order.photos_count"
    }
    
    // MARK: -
    struct Coupon {
        static let code = "coupon.code"
        static let name = "coupon.name"
        static let description = "coupon.description"
        static let limit = "coupon.limitQty"
        static let redeemed = "coupon.redeemedQty"
        static let remaining = "coupon.remainingQty"
        static let effective = "coupon.effectiveDate"
        static let expiration = "coupon.expirationDate"
        static let discount = "coupon.discount"
        static let type = "coupon.type"
        static let scope = "coupon.scope"
        static let limitOnePer = "coupon.limitOnePer"
        static let status = "coupon.status"
    }
    
    // MARK: -
    struct Payment {
        static let name = "payment.name"
        static let number = "payment.number"
        static let type = "payment.type"
        static let typeCode = "payment.typeCode"
        static let expiration = "payment.expiration"
        static let expMonth = "payment.expMonth"
        static let expYear = "payment.expYear"
        static let cvn = "payment.cvn"
        static let nickname = "payment.nickname"
        static let isDefault = "payment.isDefault"
    }
    
    // MARK: -
    struct Passcodes {
        static let alreadyEntered = "passcode.alreadyEntered"
    }
    
    // MARK: -
    struct ServerEmail {
        static let from = "SF_ORDEREMAIL_FROM"
        static let to = "SF_ORDEREMAIL_TO"
        static let orders = "SF_ORDEREMAIL_ORDERS"
    }
    
    // MARK: -
    struct Shipping {
        static let date = "shipping.date"
        static let type = "shipping.type"
        static let amount = "shipping.amount"
        static let method = "shipping.method"
        static let company = "shipping.company"
        static let companyCode = "shipping.companyCode"
        static let tracking = "shipping.tracking"
        static let delivered = "shipping.delivered"
    }
    
    // MARK: -
    struct ShipTo {
        static let firstName = "shipTo.firstName"
        static let lastName = "shipTo.lastName"
        static let addr1 = "shipTo.addr1"
        static let addr2 = "shipTo.addr2"
        static let city = "shipTo.city"
        static let state = "shipTo.state"
        static let stateCode = "shipTo.stateCode"
        static let zip = "shipTo.zip"
        static let country = "shipTo.country"
        static let countryCode = "shipTo.countryCode"
        static let phone = "shipTo.phone"
        static let email = "shipTo.email"
    }
    
    // MARK: -
    struct photoSource {
        static let current = "PhotoSource.Current"
    }
}

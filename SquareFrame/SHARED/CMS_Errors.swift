/*--------------------------------------------------------------------------------------------------------------------------
    File: CMS_Errors.swift
  Author: Kevin Messina
 Created: Apr 10, 2018
Modified:
 
 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/


enum orderError:Error {
    var description:String {
        var errorTxt:String = ""
        switch self {
        // ALAMO FIRE
        case .alamoFire_failed (let description): errorTxt = description
        // COUPONS
        case .redemption_NotAdded (let description): errorTxt = description
        case .redemption_NotFound (let description): errorTxt = description
        case .coupon_NotFound (let description): errorTxt = description
        case .coupon_NotRedeemed (let description): errorTxt = description
        case .coupon_NotAdded (let description): errorTxt = description
        case .coupon_NotDeleted (let description): errorTxt = description
        case .coupon_NotUpdated (let description): errorTxt = description
        // EMAILS
        case .serverEmail_NotSent (let description): errorTxt = description
        // FILES
        case .file_NotUploaded (let description): errorTxt = description
        case .folder_NotCreated (let description): errorTxt = description
        // MOLTIN
        case .order_BypassPaymentFailed (let description): errorTxt = description
        // PAYMENT
        case .payment_declined (let description): errorTxt = description
        // PDF's
        case .pdfs_NotDeleted (let description): errorTxt = description
        case .pdfs_NotCopied (let description): errorTxt = description
        case .pdfs_NotCreated (let description): errorTxt = description
        case .pdfs_NotFound (let description): errorTxt = description
        // PHOTOS
        case .photo_NotRenamed (let description): errorTxt = description
        case .photo_NotUploaded (let description): errorTxt = description
        // SCRIPTS
        case .script_CreationFailed (let description): errorTxt = description
        // OTHER
        default: errorTxt = ""
        }
        
        return errorTxt
    }
    
    // ALAMO FIRE
    case alamoFire_failed(error:String)
    // CART
    case cart_NotCreated
    // COUPONS
    case redemption_NotAdded(couponCode:String)
    case redemption_NotFound(couponCode:String)
    case coupon_NotFound(couponCode:String)
    case coupon_NotRedeemed(couponCode:String)
    case coupon_NotAdded(couponCode:String)
    case coupon_NotDeleted(couponCode:String)
    case coupon_NotUpdated(couponCode:String)
    // CUSTOMERS
    case customer_NotCreated
    // EMAILS
    case serverEmail_NotSent(recipient:String)
    case serverEmail_AddressesNotFound
    // FILES
    case file_NotUploaded(filename:String)
    case folder_NotCreated(filename:String)
    // MOLTIN
    case order_BypassPaymentFailed(orderNumber:String)
    // PAYMENT
    case payment_declined(error:String)
    // PDF's
    case pdfs_NotDeleted(filename:String)
    case pdfs_NotCopied(filename:String)
    case pdfs_NotCreated(filename:String)
    case pdfs_NotFound(filename:String)
    // PHOTOS
    case photo_NotRenamed(filename:String)
    case photo_NotUploaded(filename:String)
    // SCRIPTS
    case script_CreationFailed(scriptname:String)
    // OTHER
    case none
    case items_NotFound
    case network_Unavailable
}





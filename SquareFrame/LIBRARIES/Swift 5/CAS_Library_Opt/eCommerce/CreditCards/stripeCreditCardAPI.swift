/*--------------------------------------------------------------------------------------------------------------------------
    File: stripeCreditCardAPI.swift
  Author: Kevin Messina
 Created: Apr 6, 2018
Modified:

©2018-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES: Requires Stripe account: https://stripe.com/docs/mobile/ios
--------------------------------------------------------------------------------------------------------------------------*/

import Stripe

// MARK: ├─➤ Stripe Credit Card Processing
public let creditCardImgs_Mono = [#imageLiteral(resourceName: "Visa_Mono"),#imageLiteral(resourceName: "Mastercard_Mono"),#imageLiteral(resourceName: "AmericanExpress_Mono"),#imageLiteral(resourceName: "Discover_Mono"),#imageLiteral(resourceName: "applePay_Mono"),#imageLiteral(resourceName: "Diners_Mono"),#imageLiteral(resourceName: "Maestro_Mono"),#imageLiteral(resourceName: "JCB_Mono")]
public let creditCardImgs_Color = [#imageLiteral(resourceName: "Visa_Large"),#imageLiteral(resourceName: "Mastercard_Large"),#imageLiteral(resourceName: "Amex_Large"),#imageLiteral(resourceName: "Discover_Large"),#imageLiteral(resourceName: "applePay_Large"),#imageLiteral(resourceName: "Diners_Large"),#imageLiteral(resourceName: "Maestro_Large"),#imageLiteral(resourceName: "JCB_Large")]

struct CREDITCARD { // STRIPE Credit Card Processing API
    struct creditCARD:Codable,Loopable {
        var stripeID:String!
        var brand:String!
        var last4:String!
        var expMonth:String!
        var expYear:String!
        var type:String!
        var country:String!
        var imageNum:Int!
        var applePay:Bool!
        
        init(
            stripeID:String? = "",
            brand:String? = "",
            last4:String? = "",
            expMonth:String? = "",
            expYear:String? = "",
            type:String? = "",
            country:String? = "",
            imageNum:Int? = 0,
            applePay:Bool? = false
        ){
            self.stripeID = stripeID!
            self.brand = brand!
            self.last4 = last4!
            self.expMonth = expMonth!
            self.expYear = expYear!
            self.type = type!
            self.country = country!
            self.imageNum = imageNum!
            if self.applePay != nil {
                self.applePay = applePay!
            }else{
                self.applePay = false
            }
        }
        
        enum CodingKeys:String,CodingKey {
            case stripeID,brand,last4,expMonth,expYear,type,country,imageNum,applePay
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.stripeID = try values.decode(String.self, forKey: .stripeID)
            self.brand = try values.decode(String.self, forKey: .brand)
            self.last4 = try values.decode(String.self, forKey: .last4)
            self.expMonth = try values.decode(String.self, forKey: .expMonth)
            self.expYear = try values.decode(String.self, forKey: .expYear)
            self.type = try values.decode(String.self, forKey: .type)
            self.country = try values.decode(String.self, forKey: .country)
            self.imageNum = try values.decode(Int.self, forKey: .imageNum)
            self.applePay = try values.decode(Bool.self, forKey: .applePay)
        }
    }
    
    struct IMAGES {
        struct Mono {
            static let Visa = #imageLiteral(resourceName: "Visa_Mono")
            static let MasterCard = #imageLiteral(resourceName: "Mastercard_Mono")
            static let AmericanExpress = #imageLiteral(resourceName: "AmericanExpress_Mono")
            static let Discover = #imageLiteral(resourceName: "Discover_Mono")
            static let ApplePay = #imageLiteral(resourceName: "applePay_Mono")
            static let DinersClub = #imageLiteral(resourceName: "Diners_Mono")
            static let Maestro = #imageLiteral(resourceName: "Maestro_Mono")
            static let JCB = #imageLiteral(resourceName: "JCB_Mono")

            let arr = [Visa,MasterCard,AmericanExpress,Discover,ApplePay,DinersClub,Maestro,JCB]
        }
        struct Color {
            static let Visa = #imageLiteral(resourceName: "Visa_Large")
            static let MasterCard = #imageLiteral(resourceName: "Mastercard_Large")
            static let AmericanExpress = #imageLiteral(resourceName: "Amex_Large")
            static let Discover = #imageLiteral(resourceName: "Discover_Large")
            static let ApplePay = #imageLiteral(resourceName: "applePay_Large")
            static let DinersClub = #imageLiteral(resourceName: "Diners_Large")
            static let Maestro = #imageLiteral(resourceName: "Maestro_Large")
            static let JCB = #imageLiteral(resourceName: "JCB_Large")

            let arr = [Visa,MasterCard,AmericanExpress,Discover,ApplePay,DinersClub,Maestro,JCB]
        }
    }
    
    struct NAMES {
        static let Visa = "Visa"
        static let MasterCard = "MasterCard"
        static let AmericanExpress = "American Express"
        static let Discover = "Discover"
        static let ApplePay = "ApplePay"
        static let DinersClub = "Diners Club"
        static let Maestro = "Maestro"
        static let JCB = "JCB"

        // The following should have no spaces.
        static let arr = [Visa,MasterCard,"AmericanExpress",Discover,ApplePay,"DinersClub",Maestro,JCB]
    }

    struct TEST_TOKENS { // Test Tokens
        static let visa:String! = "tok_visa" // Visa
        static let visa_Debit:String! = "tok_visa_debit" // Visa (Debit)
        static let mastercard:String! = "tok_mastercard" // Mastercard
        static let mastercard_Debit:String! = "tok_mastercard_debit" // Mastercard (Debit)
        static let mastercard_Prepaid:String! = "tok_mastercard_prepaid" // Mastercard (Prepaid)
        static let amex:String! = "tok_amex" //American Express
        static let discover:String! = "tok_discover" // Discover
        static let diners:String! = "tok_diners" // Diners Club
        static let jcb:String! = "tok_jcb" // JCB
        static let error_CVN:String! = "tok_chargeDeclinedIncorrectCvc"
        static let error_CVN2:String! = "tok_cvcCheckFail"
        static let error_Expired:String! = "tok_chargeDeclinedExpiredCard"
        static let error_Declined:String! = "tok_chargeDeclined"
        static let error_HighRisk:String! = "tok_chargeDeclinedFraudulent"
        static let error_Processing:String! = "tok_chargeDeclinedProcessingError"
        static let error_BadNumber:String! = "4242424242424241"
    }
    
    struct TEST_CARDS { // Test Cards
        static let visa:String! = "4242424242424242" // Visa
        static let visa_Debit:String! = "4000056655665556" // Visa (Debit)
        static let mastercard:String! = "5555555555554444" // Mastercard
        static let mastercard_2:String! = "2223003122003222" // Mastercard Series 2
        static let mastercard_Debit:String! = "5200828282828210" // Mastercard (Debit)
        static let mastercard_Prepaid:String! = "5105105105105100" // Mastercard (Prepaid)
        static let amex:String! = "378282246310005" //American Express
        static let amex2:String! = "371449635398431" //American Express
        static let discover:String! = "6011111111111117" // Discover
        static let discover2:String! = "6011000990139424" // Discover
        static let diners:String! = "30569309025904" // Diners Club
        static let diners2:String! = "38520000023237" // Diners Club
        static let jcb:String! = "3530111333300000" // JCB
        static let unionPay:String! = "6200000000000005" // Union Pay
        static let error_CVN:String! = "4000000000000101"
        static let error_Expired:String! = "4000000000000069"
        static let error_Declined:String! = "4000000000000002"
        static let error_HighRisk:String! = "4100000000000019"
        static let error_Processing:String! = "4000000000000119"
        static let error_BadNumber:String! = "4242424242424241"
    }
    
    func setupStripe() {
// KM: 2020_02_16 - Deprecated Stripe API
//        STPPaymentConfiguration.shared().companyName = appInfo.COMPANY.name
//        STPPaymentConfiguration.shared().canDeletePaymentOptions = true
////        STPPaymentConfiguration.shared().createCardSources = true
//        STPPaymentConfiguration.shared().publishableKey = appInfo.COMPANY.FINANCE.STRIPE_API_KEY.live
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = appInfo.COMPANY.FINANCE.APPLEPAY.merchantID
// KM: 2020_02_16 - Updated Stripe API
        Stripe.setDefaultPublishableKey(appInfo.COMPANY.FINANCE.STRIPE_API_KEY.live)
        STPAPIClient.shared().publishableKey = appInfo.COMPANY.FINANCE.STRIPE_API_KEY.live
        STPAPIClient.shared().configuration.companyName = appInfo.COMPANY.name
        STPAPIClient.shared().configuration.appleMerchantIdentifier = appInfo.COMPANY.FINANCE.APPLEPAY.merchantID
        STPAPIClient.shared().configuration.canDeletePaymentOptions = true
    }
    
    func setupStripeTheme() {
        STPTheme.default().accentColor = appInfo.COMPANY.FINANCE.STRIPE_THEME.accentColor
        STPTheme.default().primaryBackgroundColor = appInfo.COMPANY.FINANCE.STRIPE_THEME.primaryBackgroundColor
        STPTheme.default().secondaryBackgroundColor = appInfo.COMPANY.FINANCE.STRIPE_THEME.secondaryBackgroundColor
        STPTheme.default().errorColor = appInfo.COMPANY.FINANCE.STRIPE_THEME.errorColor
        STPTheme.default().primaryForegroundColor = appInfo.COMPANY.FINANCE.STRIPE_THEME.primaryForegroundColor
        STPTheme.default().secondaryForegroundColor = appInfo.COMPANY.FINANCE.STRIPE_THEME.secondaryForegroundColor
        if appInfo.COMPANY.FINANCE.STRIPE_THEME.font != nil { STPTheme.default().font = appInfo.COMPANY.FINANCE.STRIPE_THEME.font }
        if appInfo.COMPANY.FINANCE.STRIPE_THEME.emphasisFont != nil { STPTheme.default().emphasisFont = appInfo.COMPANY.FINANCE.STRIPE_THEME.emphasisFont }
    }
}

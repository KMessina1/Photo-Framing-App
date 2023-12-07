/*--------------------------------------------------------------------------------------------------------------------------
   File: AppInfo.swift
 Author: Kevin Messina
Created: January 23, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: - Converted to Swift 3.0 on September 19, 2016
       - Montserrat Font: https://www.fontsquirrel.com/fonts/montserrat
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBALS ***
/* Assign Custom Classes */

/* Assign Global Variables */
let gEncryptionKey:UInt8! = 28
var gAppColor:UIColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
var gAppColorIsLight = gAppColor.isLight()

struct APPTHEME {
    struct colors {
        let tint:UIColor = UIColor(named: "appTintColor") ?? gAppColor
        let backgroundColor:UIColor = UIColor(named: "appBackground") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    struct gradients {
        struct appBackground {
            static let gradientTop:UIColor = UIColor(named: "appGradientTop") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let gradientBottom:UIColor = UIColor(named: "appGradientBottom") ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            let colors:[UIColor] = [
                gradientTop.withAlphaComponent(0.05),
                gradientTop.withAlphaComponent(0.1),
                gradientTop.withAlphaComponent(0.15),
                gradientTop.withAlphaComponent(0.2),
                gradientTop.withAlphaComponent(0.3)
            ]
            
            let locations:[NSNumber] = [0.0, 0.33, 0.5, 0.66, 1.0]
        }
    }
    
    static let selectedColor:UIColor        = #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1)
    static let selectedColorDark:UIColor    = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
    static let borderColor_Active:UIColor   = gAppColor
    static let borderColor_Inactive:UIColor = gAppColor.withAlphaComponent(0.66)
    static let placeholderColor:UIColor     = gAppColor
    static let textColor:UIColor            = gAppColor
    static let appLocked:[UIColor]          = [#colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1).withAlphaComponent(0.05),
                                               #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1).withAlphaComponent(0.1),
                                               #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1).withAlphaComponent(0.15),
                                               #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1).withAlphaComponent(0.2),
                                               #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1).withAlphaComponent(0.3)]
    static let alert_ButtonEnabled:UIColor = gAppColor
    static let alert_ButtonDisabled:UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    static let alert_ButtonCancel:UIColor = #colorLiteral(red: 0.9987408519, green: 0.1733306944, blue: 0.3358413577, alpha: 1)
    static let alert_TintColor:UIColor = gAppColor
}

struct Font_Montserrat {
    static let regular      = "Montserrat-Regular"
    static let extraBold    = "Montserrat-ExtraBold"
    static let black        = "Montserrat-Black"
    static let medium       = "Montserrat-Medium"
    static let bold         = "Montserrat-Bold"
    static let light        = "Montserrat-Light"
    static let semiBold     = "Montserrat-SemiBold"
    static let extraLight   = "Montserrat-ExtraLight"
    static let thin         = "Montserrat-Thin"
}

struct APPFONTS {
    let PDFTitles            = UIFont(name: Font.Avenir.Book.regular, size: 24)
    let PDFInfo              = UIFont(name: Font.Avenir.Light.regular, size: 18)
    let screenTitles         = UIFont(name: Font_Montserrat.regular, size: 24)
    let menuTitles           = UIFont(name: Font_Montserrat.regular, size: 18)
    let buttonTitles         = UIFont(name: Font_Montserrat.regular, size: 14)
    let buttonTitles_Large   = UIFont(name: Font_Montserrat.regular, size: 18)
    let barButtonTitles      = UIFont(name: Font_Montserrat.regular, size: 14)
    let navBarTitles         = UIFont(name: Font_Montserrat.light, size: 14)
    let text_Reg             = UIFont(name: Font_Montserrat.regular, size: 14)
    let text_Light           = UIFont(name: Font_Montserrat.light, size: 14)
    let text_Bold            = UIFont(name: Font_Montserrat.bold, size: 14)
    let text_Thin            = UIFont(name: Font_Montserrat.thin, size: 14)
}


// MARK: - *** APPINFO CLASS ***
final class appInfo {
    enum kAppIDNum:Int { case kSF }

    // MARK: ├─➤ 🔑 Keychain
    struct KEYCHAIN:Loopable {
        static let key = "token"
    }

    
// MARK: ├─➤ Company
    struct COMPANY {
        struct WEBSITE_URLS {
            static let company:String! = EDITION.URLs().website
            static let Shippo:String! = "https://app.goshippo.com/orders"
            static let taxJar:String! = "https://app.taxjar.com/sign_in/"
            static let stripe:String! = "https://dashboard.stripe.com/login"
            static let USPS_Tracking:String! = "https://tools.usps.com/go/TrackConfirmAction_input?origTrackNum="
        }
        
        struct SOCIALMEDIA_URLS {
            static let faceBook:String! = EDITION.URLs().faceBook
            static let instagram:String! = EDITION.URLs().instagram
            static let linkedIn:String! = EDITION.URLs().linkedIn
            static let pinterest:String! = EDITION.URLs().pinterest
            static let twitter:String! = EDITION.URLs().twitter
            static let youTube:String! = EDITION.URLs().youTube
        }

        struct SERVER {
            struct SCRIPTS {
            }
        }
        
        struct FINANCE {
            struct APPLEPAY {
                static let merchantID:String = "merchant.com.sqframe"
            }
            
            // PRODUCTION CHECK: ✅ MAKE SURE LIVE KEYS FOR PRODUCTION
            struct STRIPE_API_KEY { // Published Key: App SDK Uses these keys
                static let test:String! = "pk_test_..."
                static let live:String! = "pk_live_..."
            }
            
            struct STRIPE_SECRET_KEY { // Secret Key: PhP SDK and Scripts use these keys
                static let test:String! = "sk_test_..."
                static let live:String! = "sk_live_..."
            }
            
            struct STRIPE_THEME {
                static let accentColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                static let primaryBackgroundColor:UIColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                static let secondaryBackgroundColor:UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                static let errorColor:UIColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                static let primaryForegroundColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                static let secondaryForegroundColor:UIColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                static let font:UIFont? = nil
                static let emphasisFont:UIFont? = nil
            }
        }
        
        struct ORDERS {
            static let email:String! = "mailto:..."
            static let giftMsg:String! = "giftMsgPreview.pdf"
            static let lastOrder:String! = "lastOrder.pdf"
            static let order:String! = "Order_"
            static let orderConfirmation:String! = "OrderConfirmation_"
        }
    }

    struct PHOTOS {
        static let SF_Customer_Photos:String! = "App Photos"
    }
    
// MARK: ├─➤ Shortcut Info
    struct SHORTCUTS {
        static let titles:[String] = EDITION.appShortcuts.titles().arr
        static let subTitles:[String] = EDITION.appShortcuts.subTitles().arr
        static let imageNames:[String] = EDITION.appShortcuts.imageNames().arr
        static let tabIndeces:[Int] = EDITION.appShortcuts.tabIndices().arr
        static let VCs = EDITION.appShortcuts.VCs().arr
    }

// MARK: ├─➤ Copyright
    struct COPYRIGHT {
        static let year:String!   = EDITION.copyrightYears
        static let rights:String! = "All Rights Reserved."
    }

// MARK: ├─➤ Instagram
    struct INSTAGRAM { // Instagram Transactions, requires CAS_Instagram library
        static let clientID:String!             = "..."
        static let clientSecret:String!         = "..."
        static let usersURL:String!             = "https://api.instagram.com/v1/users/self/"
        static let loginURL:String!             = "https://www.instagram.com/accounts/login/"
        static let authorizeURL:String!         = "https://api.instagram.com/oauth/authorize/"
        static let permissionsScope:String!     = "basic" //"basic+public_content+follower_list"
        static let privacyPolicyURL:String!     = "https://..."
        struct PHOTOS {
            static let all      = "https://api.instagram.com/v1/users/self/media/recent"
            static let recents  = "https://api.instagram.com/v1/users/self/media/recent"
            static let liked    = "https://api.instagram.com/v1/users/self/media/liked"
        }
        static let redirectURI:String!          = "https://..."
    }
    
// MARK: ├─➤ Databases
    struct DB {
        /* Default database for user data in documents */
        static let dataDescription:String! = "Application Data"
        static let dataName:String! = "data.db"
        static let data:String! = sharedFunc.FILES().dirDocuments(fileName: dataName)
        static let dataDescription_FAQ:String! = "FAQ Data"
        static let dataName_FAQ:String! = "FAQ.db"
        static let data_FAQ:String! = sharedFunc.FILES().dirMainBundle(fileName: dataName_FAQ)

        /* Array of all above items for About screens */
        static let arrayOf = [
            [dataDescription,DB.data,sharedFunc.FILES().dirDocuments(fileName: DB.dataName)],
            [dataDescription_FAQ,DB.data_FAQ,sharedFunc.FILES().dirMainBundle(fileName: DB.dataName_FAQ)]
        ]
        
        #if canImport(oldSQL)
            static let arrayOfVersions = [
                [dataDescription,DB.data,sharedFunc.SQL().DB_Version(DBPath:data).verString],
                [dataDescription_FAQ,DB.data_FAQ,sharedFunc.SQL().DB_Version(DBPath:data_FAQ).verString]
            ]
        #else
            static let arrayOfVersions:[String] = []
        #endif
    }
    
    
// MARK: ├─➤ Editions
    struct EDITION {
        // MARK: ├───➤ App Info
        static let target:String!               = "TARGET_SF"
        static let revision:String!             = "a"
        static let name:String!                 = "Photo Framing"
        static let fullName:String!             = "Photo Framing App"
        static let appID:String!                = "SF"
        static let appEdition:String!           = sharedFunc.APP().isAdhocMode() ?"App (R&D)" :"App"
        static let appIDNum:Int!                = appInfo.kAppIDNum.kSF.rawValue
        static let supportedLanguages:String!   = kLANGUAGES.english + "," + kLANGUAGES.spanish
        static let whatsNewFilename:String!     = "WhatIsNew_SF.plist"
        static let helpFilename:String!         = "Help_SF.plist"
        static let copyrightYears:String!       = "2016-2019"
        static var color_Text:String!           = "Tungsten"

        // MARK: ├───➤ AppStore
        struct appStore {
            static let appleID:String! = "1123158538"
            static let URL:String! = "itms-apps://itunes.apple.com/us/app/id\(appleID!)"
            static let ext_URL:String! = "https://itunes.apple.com/us/app/id\(appleID!)"
        }
        
        // MARK: ├───➤ SHORTCUT INFO
        struct appShortcuts {
            struct titles {
                static let open_1:String! = "shortcut_Open_1_Title".localized()
                static let open_2:String! = "shortcut_Open_2_Title".localized()
                static let open_3:String! = "shortcut_Open_3_Title".localized()
                static let open_4:String! = "shortcut_Open_4_Title".localized()

                let arr:[String] = [open_1, open_2, open_3, open_4]
            }
            struct subTitles {
                static let open_1:String! = "shortcut_Open_1_Subtitle".localized()
                static let open_2:String! = "shortcut_Open_2_Subtitle".localized()
                static let open_3:String! = "shortcut_Open_3_Subtitle".localized()
                static let open_4:String! = "shortcut_Open_4_Subtitle".localized()
                
                let arr:[String] = [open_1, open_2, open_3, open_4]
            }
            struct VCs {
                static let open_1 = gBundle.instantiateViewController(withIdentifier: "VC_frameGallery") as! VC_frameGallery
                static let open_2 = gBundle.instantiateViewController(withIdentifier: "VC_getStarted") as! VC_getStarted
                static let open_3 = gBundle.instantiateViewController(withIdentifier: "VC_Orders") as! VC_Orders
                static let open_4 = gBundle.instantiateViewController(withIdentifier: "VC_Account") as! VC_Account

                let arr = [open_1, open_2, open_3, open_4]
            }
            struct tabIndices {
                static let open_1:Int = 0
                static let open_2:Int = 1
                static let open_3:Int = 2
                static let open_4:Int = 3
                
                let arr:[Int] = [open_1, open_2, open_3, open_4]
            }
            struct imageNames {
                static let open_1:String! = "appShortcut_1"
                static let open_2:String! = "appShortcut_2"
                static let open_3:String! = "appShortcut_3"
                static let open_4:String! = "appShortcut_4"
                
                let arr:[String] = [open_1, open_2, open_3, open_4]
            }
        }
        
        // MARK: ├───➤ SOCIAL MEDIA
        struct URLs {
            let faceBook:String! = "https://facebook.com/..."
            let instagram:String! = "https://www.instagram.com/..."
            let linkedIn:String! = ""
            let pinterest:String! = "https://www.pinterest.com/..."
            let twitter:String! = "https://twitter.com/..."
            let website:String! = "https://www..."
            let youTube:String! = ""
        }

        // MARK: ├───➤ THIRD PARTY PARAMS
        static let fabricAPIKey:String! = "..."
    }
    
    func getEdition() -> String {
        #if TARGET_SF
            return "SF"
        #else
            sharedFunc.ALERT().show(
                title:"EDITION ERROR",
                style:.error,
                msg:"Failed to set the current Edition of the app. Contact company tech support."
            )
            return "???"
        #endif
    }
}

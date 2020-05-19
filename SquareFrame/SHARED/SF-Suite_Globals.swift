/*--------------------------------------------------------------------------------------------------------------------------
       File: SF-Suite_Globals.swift
     Author: Kevin Messina
    Created: Sep. 11, 2018
 Modified:
 
 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES: These are shared app settings for all apps in the suite.
 --------------------------------------------------------------------------------------------------------------------------*/

// MARK: ├─➤ TEST USERS
struct testUsers {
    var id:Int
    var name:String
    var displayName:String

    init (
        id:Int = -1,
        name:String = "",
        displayName:String? = ""
    ){
        self.id = id
        self.name = name
        self.displayName = "\( name ) (TestID:\( id ))"
    }
}

let testers = [ // Add users here...
    testUsers(id: 90, name: "Kevin Messina"),
    testUsers(id: 91, name: "Stephen Smith"),
    testUsers(id: 99998, name: "xCode (ID# SIM)"),
    testUsers(id: 99999, name: "AdHoc (ID# R&D)")
]

// MARK: ├─➤ PRODUCTS/COMPONENTS
var CMS_frameGalleryTitle:String = ""
var CMS_frame_colors:[Frames.colors] = []
var CMS_matte_Colors:[Frames.matteColors] = []
var CMS_photo_Sizes:[Frames.photoSizes] = []
var CMS_products:[Frames.products] = []
var CMS_frame_shapes:[Frames.shape] = []
var CMS_frame_sizes:[Frames.sizes] = []
var CMS_frame_styles:[Frames.style] = []
var CMS_frame_materials:[Frames.materials] = []
var CMS_emailAddresses:[EmailAddresses.emailAddressStruct] = []
var CMS_FAQList:[FAQs.FAQstruct] = []
var CMS_Frames_Square:[Frames.sizes] = []
var CMS_Frames_Rect:[Frames.sizes] = []
var CMS_TaxableStates:[CAS_SalesTax.TaxableState] = []
var localCart:LocalCart!

// MARK: ├─➤ App Images URLS
struct serverImgs {
    let Version:String = "1.01"
    let name:String = "Server Images"

    static let url = URL(string: appInfo.COMPANY.SERVER.assets!)
    
    struct FRAMES {
        struct gallery {
            static let url = serverImgs.url!.appendingPathComponent("frameGallery")
            static let path = url.path
            static let folderName = path.lastPathComponent
            static let folderPath = "assets/" + folderName
        }
        
        struct carousel {
            static let url = serverImgs.url!.appendingPathComponent("frameCarousel")
            static let path = url.path
            static let folderName = path.lastPathComponent
            static let folderPath = "assets/" + folderName
        }
    }
    
    struct APP {
        static let url = serverImgs.url!.appendingPathComponent("appImages")
        static let path = url.path
        static let folderName = path.lastPathComponent
        static let folderPath = "assets/" + folderName
    }
}

struct cachedImgs {
    static let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("Caches")
        .appendingPathComponent("images")
    
    struct FRAMES {
        struct gallery {
            static let url = cachedImgs.url.appendingPathComponent("frameGallery")
            static let path = url.path
            static let folderName = path.lastPathComponent
        }
        
        struct carousel {
            static let url = cachedImgs.url.appendingPathComponent("frameCarousel")
            static let path = url.path
            static let folderName = path.lastPathComponent
        }
    }
    
    struct APP {
        static let url = cachedImgs.url.appendingPathComponent("app")
        static let path = url.path
        static let folderName = path.lastPathComponent
    }
}


// MARK: ├─➤ Keychain
extension appInfo.KEYCHAIN {
    struct ACCOUNT {
        static let instagram = "SQInsta"
        static let app = "squareframe"
    }
}

// MARK: ├─➤ Company
extension appInfo.COMPANY {
    static let shortName:String!     = "Squareframe"
    static let name:String!          = "Squareframe LLC"
    static let location:String!      = "Decatur, GA USA"
    
    struct SUPPORT {
        static let url:String!      = "https://sqframeapp.com/"
        struct EMAIL {
            static let customer:String!    = "support@sqframe.com"
            static let technical:String!    = "techsupport@sqframe.com"
        }
    }
}

// MARK: ├─➤ Server
extension appInfo.COMPANY.SERVER {
    static let baseFolder                   = "https://sqframe.com/client-tools/squareframe"
    static let CMSbaseFolder:String!        = baseFolder + "/scripts/cms"
    
    static let phpMailScriptsFolder:String! = baseFolder + "/scripts/phpMailer"
    static let moltinScriptsFolder:String!  = baseFolder + "/MoltinScripts"
    static let ordersFolder:String!         = baseFolder + "/Orders"
    static let scriptsFolder:String!        = baseFolder + "/scripts"
    static let uploadsFolder:String!        = baseFolder + "/uploads"
    static let assets:String!               = baseFolder + "/assets"
    
    struct LOGIN {
        static let name:String!         = "519913af-3723-44d5-82a5-c0ad18028cf6"
        static let password:String!     = "6whGh3FCMHYNqZgq6kxwUajAWCLmAbYdrnRDRM72CdaMdMTB3k"
    }
}

// MARK: ├─➤ Scripts
extension appInfo.COMPANY.SERVER.SCRIPTS {
    static let baseFolder = appInfo.COMPANY.SERVER.CMSbaseFolder!
    static let scriptsFolder = appInfo.COMPANY.SERVER.scriptsFolder!

    static let accounts:String!         = baseFolder + "/accounts"
    static let addresses:String!        = baseFolder + "/addresses"
    static let admin:String!            = baseFolder + "/admin"
    static let appImages:String!        = baseFolder + "/appImages"
    static let cart:String!             = baseFolder + "/cart"
    static let components:String!       = baseFolder + "/components"
    static let coupons:String!          = baseFolder + "/coupons"
    static let customers:String!        = baseFolder + "/customers"
    static let faq:String!              = baseFolder + "/faq"
    static let files:String!            = baseFolder + "/files"
    static let frameGallery:String!     = baseFolder + "/frameGallery"
    static let fulfillment:String!      = baseFolder + "/fulfillment"
    static let knowledgebase:String!    = baseFolder + "/knowledgebase"
    static let mailer:String!           = baseFolder + "/mailer"
    static let mailingList:String!      = baseFolder + "/mailingList"
    static let orders:String!           = baseFolder + "/orders"
    static let products:String!         = baseFolder + "/products"
    static let resources:String!        = baseFolder + "/resources"
    static let scriptLogs:String!       = baseFolder + "/scriptLogs"
    static let services:String!         = baseFolder + "/services"
    static let stripe:String!           = scriptsFolder + "/stripe"
    static let tax:String!              = baseFolder + "/tax"
    static let teams:String!            = baseFolder + "/teams"
}

// MARK: ├─➤ Instagram
struct INSTAGRAM { // Instagram Transactions, requires CAS_Instagram library
    static let clientID:String!             = "1211cb15ebef4bc3831cd851db28d22a"
    static let clientSecret:String!         = "9292c83a2f054469b9695a26114a4adb"
    static let usersURL:String!             = "https://api.instagram.com/v1/users/self/"
    static let loginURL:String!             = "https://www.instagram.com/accounts/login/"
    static let authorizeURL:String!         = "https://api.instagram.com/oauth/authorize/"
    static let permissionsScope:String!     = "basic"
    static let privacyPolicyURL:String!     = "https://sqframeapp.com/?page_id=9298&v=7516fd43adaa"
    struct PHOTOS {
        static let all      = "https://api.instagram.com/v1/users/self/media/recent"
        static let recents  = "https://api.instagram.com/v1/users/self/media/recent"
        static let liked    = "https://api.instagram.com/v1/users/self/media/liked"
    }
//    static let OLDredirectURI:String! = "http://www.sqframe.com" // Deprecated
    static let redirectURI:String! = "https://sqframeapp.com"
}




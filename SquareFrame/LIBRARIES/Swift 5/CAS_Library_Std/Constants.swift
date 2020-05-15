/*--------------------------------------------------------------------------------------------------------------------------
 File: Constants.swift
 Author: Kevin Messina
 Created: August 6, 2015
 
 ©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES: Converted to Swift 3.0 on September 16, 2016
 --------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit

let M_PI = Double.pi
enum reservedTags:Int { case alert_Email=900,blurView }

/// *** GLOBAL CONSTANT STRUCTS & ENUMS ***
@objc(Constants) class Constants:NSObject {
// MARK: - *** VERSION INFO ***
    var Version:String! { return "2.04" }

    func getLibraryVersions() -> [[String:String]] {
        var arrLibraries:[[String:String]]! = []

        if NSClassFromString("Popover_About") != nil {
            arrLibraries.append(["Name":"About","Version":Popover_About().Version])
        }
        
        if NSClassFromString("CASAlertView") != nil {
            arrLibraries.append(["Name":"Alert","Version":CASAlertView().Version])
        }
        
        if NSClassFromString("VC_ContactUs") != nil {
            arrLibraries.append(["Name":"Contact Us","Version":VC_ContactUs().Version])
        }
        
        if NSClassFromString("Controls") != nil {
            arrLibraries.append(["Name":"Controls","Version":Controls().Version])
        }
        
        if NSClassFromString("Constants") != nil {
            arrLibraries.append(["Name":"Constants","Version":Constants().Version])
        }
        
        if NSClassFromString("DeviceList") != nil {
            arrLibraries.append(["Name":"Devices","Version":DeviceList().Version])
        }
        
        if NSClassFromString("Extensions") != nil {
            arrLibraries.append(["Name":"Extensions","Version":Extensions().Version])
        }
        
        if NSClassFromString("sharedFunc") != nil {
            arrLibraries.append(["Name":"Functions","Version":sharedFunc().Version])
        }
        
        if NSClassFromString("VC_Help") != nil {
            arrLibraries.append(["Name":"Help","Version":VC_Help().Version])
        }
        
        if NSClassFromString("Jurisdictions") != nil {
            arrLibraries.append(["Name":"Jurisdictions","Version":Jurisdictions().Version])
        }
        
        if NSClassFromString("Languages") != nil {
            arrLibraries.append(["Name":"Languages","Version":Languages().Version])
        }
        
        if NSClassFromString("Popover_Picker") != nil {
            arrLibraries.append(["Name":"Picker","Version":Popover_Picker().Version])
        }
        
        if NSClassFromString("Popover_Table") != nil {
            arrLibraries.append(["Name":"Tables","Version":Popover_Table().Version])
        }
        
        if NSClassFromString("sharedFunc") != nil {
            arrLibraries.append(["Name":"Shared Funcs","Version":sharedFunc().Version])
        }
        
        if NSClassFromString("TextFieldEffects") != nil {
            arrLibraries.append(["Name":"Text Effects","Version":TextFieldEffects().Version])
        }
        
        if NSClassFromString("waitHUD") != nil {
            arrLibraries.append(["Name":"Wait HUD","Version":waitHUD().Version])
        }
        
        if NSClassFromString("VC_WhatIsNew") != nil {
            arrLibraries.append(["Name":"What's New","Version":VC_WhatIsNew().Version])
        }
        
        return arrLibraries
    }

    func getFabricVersion() -> (namesAndVersions:[[String]],names:[String],versions:[String]) {
        var Names:[String]! = []
        var Versions:[String]! = []
        var arrItems:[String]! = []
        var arrVers:[String]! = []
        var arrNames:[String]! = []
        var NamesAndVersions:[[String]]! = []
        
        arrItems = ["Answers","Fabric","Crashlytics"]
        arrNames = ["Fabric:Answers","Fabric:Beta","Fabric:Crashlytics"]
        arrVers = ["Installed","Installed","Installed"]
        
        for i in 0..<arrItems.count {
            if NSClassFromString(arrItems[i]) != nil {
                NamesAndVersions.append([arrNames[i],arrVers[i]])
                Names.append(arrNames[i])
                Versions.append(arrVers[i])
            }
        }
        
        return (NamesAndVersions,Names,Versions)
    }
}

// MARK: - *** CONSTANTS ***
// MARK: ├─➤ eCommerce Constants
public enum creditCardTypes:Int { case visa,mastercard,amex,discover }
public let creditCardImgs:[String] = [creditCardNames.visa,creditCardNames.mastercard,creditCardNames.amex,creditCardNames.discover]
public let creditCardImgs_Large:[String] = ["Visa_Large","Mastercard_Large","Amex_Large","Discover_Large"]

public struct creditCardNames {
    static let visa:String          = "Visa"
    static let mastercard:String    = "Mastercard"
    static let amex:String          = "American Express"
    static let discover:String      = "Discover"

    static let arr:[String] = [creditCardNames.visa,creditCardNames.mastercard,creditCardNames.amex,creditCardNames.discover]
}

public struct creditCardNameCodes {
    static let visa:String          = "VISA"
    static let mastercard:String    = "MC"
    static let amex:String          = "AMEX"
    static let discover:String      = "DISC"
    
    static let arr:[String] = [
        creditCardNameCodes.visa,
        creditCardNameCodes.mastercard,
        creditCardNameCodes.amex,
        creditCardNameCodes.discover
    ]
}


/// Audio System Sounds
// MARK: ├─➤ Audio System Sounds
public struct systemSounds {
    struct mail {
        static let received:UInt32 = 1000
        static let sent:UInt32 = 1001
    }
    
    struct voicemail {
        static let received:UInt32 = 1002
        static let voicemail:UInt32 = 1015
    }
    
    struct SMS {
        static let received:UInt32 = 1003
        static let sent:UInt32 = 1004
        static let alert1:UInt32 = 1007
        static let alert2:UInt32 = 1008
        static let alert3:UInt32 = 1009
        static let alert4:UInt32 = 1010
        static let received1:UInt32 = 1012
        static let received5:UInt32 = 1013
        static let received6:UInt32 = 1014
        static let anticipate:UInt32 = 1020
        static let bloom:UInt32 = 1021
        static let calypso :UInt32 = 1022
        static let chooChoo:UInt32 = 1023
        static let descent:UInt32 = 1024
        static let fanfare:UInt32 = 1025
        static let ladder:UInt32 = 1026
        static let minuet:UInt32 = 1027
        static let newsFlash:UInt32 = 1028
        static let noir:UInt32 = 1029
        static let sherwoodForrest:UInt32 = 1030
        static let spell:UInt32 = 1031
        static let suspense:UInt32 = 1032
        static let telepgraph:UInt32 = 1033
        static let tiptoes:UInt32 = 1034
        static let typewriters:UInt32 = 1035
        static let update:UInt32 = 1036
    }
    
    struct calendar {
        static let alert:UInt32 = 1005
    }
    
    struct device {
        static let lowPower:UInt32 = 1006
        static let vibrate:UInt32 = 1011
        static let beepBeep:UInt32 = 1106
        static let ringerChanged:UInt32 = 1107
        static let photoShutter:UInt32 = 1108
        static let shakeToShuffle:UInt32 = 11
    }

    struct tweet {
        static let sent:UInt32 = 1016
    }
    
    struct USSD {
        static let alert:UInt32 = 1050
    }
    
    struct SIM_Toolkit {
        static let callDropped:UInt32 = 1051
        static let generalBeep:UInt32 = 1052
        static let negativeACK:UInt32 = 1053
        static let positiveACK:UInt32 = 1054
        static let SMS:UInt32 = 1055
        static let tink:UInt32 = 1057
        static let busy:UInt32 = 1070
        static let congestion:UInt32 = 1071
        static let pathACK:UInt32 = 1072
        static let error:UInt32 = 1073
        static let callWaiting:UInt32 = 1074
        static let keytone:UInt32 = 1075
    }
    
    struct lockScreen {
        static let lock:UInt32 = 1100
        static let unlock:UInt32 = 1101
        static let failed:UInt32 = 1102
        static let keypress1:UInt32 = 1103
        static let keypress2:UInt32 = 1104
        static let keypress3:UInt32 = 1105
    }
    
    struct Recording {
        static let recordBegin:UInt32 = 1110
        static let recordEnd:UInt32 = 1111
        static let JBLbegin:UInt32 = 1112
        static let JBLconfirm:UInt32 = 1113
        static let JBLcancel:UInt32 = 1114
        static let JBLAmbiguous:UInt32 = 1115
        static let JBLNoMatch:UInt32 = 1116
        static let videoBeginRecord:UInt32 = 1117
        static let videoEndRecord:UInt32 = 1118
    }
    
    struct videoCalls {
        static let invitationAccepted:UInt32 = 1150
        static let ringing:UInt32 = 1151
        static let ended:UInt32 = 1152
        static let callWaiting:UInt32 = 1153
        static let callUpgrade:UInt32 = 1154
    }
    
    struct phone {
        static let dtmf0:UInt32 = 1200
        static let dtmf1:UInt32 = 1201
        static let dtmf2:UInt32 = 1202
        static let dtmf3:UInt32 = 1203
        static let dtmf4:UInt32 = 1204
        static let dtmf5:UInt32 = 1205
        static let dtmf6:UInt32 = 1206
        static let dtmf7:UInt32 = 1207
        static let dtmf8:UInt32 = 1208
        static let dtmf9:UInt32 = 1209
        static let dtmfStar:UInt32 = 1210
        static let dtmfPound:UInt32 = 1211
        static let longLowShortHigh:UInt32 = 1254
        static let shortDoubleHigh:UInt32 = 1255
        static let shortLowHigh:UInt32 = 1256
        static let shortDoubleLow:UInt32 = 1257
        static let shortDoubleLow2:UInt32 = 1258
        static let middle9HosrtDoubleLow:UInt32 = 1259
    }

    struct generalSounds {
        static let voicemail:UInt32 = 1300
        static let receivedMsg:UInt32 = 1301
        static let newMail:UInt32 = 1302
        static let mailSent:UInt32 = 1303
        static let alarm:UInt32 = 1304
        static let lock:UInt32 = 1305
        static let tock:UInt32 = 1306
        static let smsRcvd1:UInt32 = 1307
        static let smsRcvd2:UInt32 = 1308
        static let smsRcvd3:UInt32 = 1309
        static let smsRcvd4:UInt32 = 1310
        static let vibrate:UInt32 = 1311
        static let smsReceived1:UInt32 = 1312
        static let smsReceived5:UInt32 = 1313
        static let smsReceived6:UInt32 = 1314
        static let voicemail2:UInt32 = 1315
        static let anticipate:UInt32 = 1320
        static let bloom:UInt32 = 1321
        static let calypso:UInt32 = 1322
        static let choChoo:UInt32 = 1323
        static let descent:UInt32 = 1324
        static let fanFare:UInt32 = 1325
        static let ladder:UInt32 = 1326
        static let minuet:UInt32 = 1327
        static let newsFlash:UInt32 = 1328
        static let noir:UInt32 = 1329
        static let sherwoodForrest:UInt32 = 1330
        static let spell:UInt32 = 1331
        static let suspense:UInt32 = 1332
        static let telegraph:UInt32 = 1333
        static let tiptoes:UInt32 = 1334
        static let typewriters:UInt32 = 1335
        static let update:UInt32 = 1336
        static let ringervibechanged:UInt32 = 1350
        static let silentvibechanged:UInt32 = 1351
        static let vibrate2:UInt32 = 4095
    }
}


/// UIActivityIndicator actions
// MARK: ├─➤ statusCodes_HTTP
public func statusCodes_HTTP(_ code:Int) -> String {
    switch code {
        case 100: return "Continue"
        case 101: return "Switching Protocols"
        
        case 200: return "OK"
        case 201: return "Created"
        case 202: return "Accepted"
        case 203: return "Non-Authoritative Information"
        case 204: return "No Content"
        case 205: return "Reset Content"
        case 206: return "Partial Content"
        
        case 300: return "Multiple Choices"
        case 301: return "Moved Permanently"
        case 302: return "Moved Temporarily"
        case 303: return "See Other"
        case 304: return "Not Modified"
        case 305: return "Use Proxy"
        
        case 400: return "Bad Request"
        case 401: return "Unauthorized"
        case 402: return "Payment Required"
        case 403: return "Forbidden"
        case 404: return "Not Found"
        case 405: return "Method Not Allowed"
        case 406: return "Not Acceptable"
        case 407: return "Proxy Authentication Required"
        case 408: return "Request Time-out"
        case 409: return "Conflict"
        case 410: return "Gone"
        case 411: return "Length Required"
        case 412: return "Precondition Failed?"
        case 413: return "Request Entity Too Large"
        case 414: return "Request-URI Too Large"
        case 415: return "Unsupported Media Type"
        
        case 500: return "Internal Server Error"
        case 501: return "Not Implemented"
        case 502: return "Bad Gateway"
        case 503: return "Service Unavailable"
        case 504: return "Gateway Time-out"
        case 505: return "HTTP Version not supported"
        
        default: return "Unknown status code \(code) returned."
    }
}

/// UIActivityIndicator actions
// MARK: ├─➤ kAction
public enum kAction { case start,stop}

/// CAS_AlertView Types
/// NOTE: Don't change the order, they are significant to maintain current CAS client app interoperability across versions. 
/// Add to the end for new types.
// MARK: ├─➤ CAS_AlertView Type
public enum CASAlertViewType:Int { case success,error,notice,warning,info,edit,wait,notAvail,iap,confirm,construction,serverError }

/// Vertical Alignment settings for CAS_UILabel objects
// MARK: ├─➤ kAlign
public enum kAlign { case center,top,bottom,fill }

/// Horizontal Alignment settings for CAS_UILabel objects
// MARK: ├─➤ kAlignment
public enum kAlignment { case left,right,center }

// MARK: -
/// Alpha settings for UIView objects
public struct kAlpha {
    static let transparent  = CGFloat(0.0)
    static let semiDark     = CGFloat(0.25)
    static let semiOpaque   = CGFloat(0.5)
    static let semiLight    = CGFloat(0.75)
    static let opaque       = CGFloat(1.0)

    static let clear        = CGFloat(0.0)
    static let quarter      = CGFloat(0.25)
    static let third        = CGFloat(0.33)
    static let half         = CGFloat(0.5)
    static let twothirds    = CGFloat(0.66)
    static let threequarter = CGFloat(0.75)
    static let solid        = CGFloat(1.0)
}

// MARK: -
/// BLUR EFFECT Constants
public struct kBLUR {
    static let LIGHT_SUBTLE   = 4
    static let LIGHT          = 0
    static let LIGHT_EXTRA    = 1
    static let DARK_SUBTLE    = 5
    static let DARK           = 2
    static let DARK_EXTRA     = 6
    static let DARK_VERY      = 7
    static let TINT           = 3
}

// MARK: -
/// Character sets (Valid for comparison/usage)
public struct kCharSet {
    struct TITLES {
        static let alpha:String        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
        static let alphaNumeric:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ "
        static let tableIndex:String   = "*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }

    struct VALID {
        static let chars:String         = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '-/:;()$&@.,?![]{}#%^*+=_|~<>\""
        static let alphaOnly:String     = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        static let numeric:String       = "0123456789.,"
        static let decimalPad:String    = "0123456789."
        static let numbersOnly:String   = "0123456789"
        static let dateOnly:String      = "0123456789/"
        static let alphaNumeric:String  = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        static let emailAddress:String  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz 0123456789!#$%&'*+-/=?^_`{|}~"
        static let tableIndex:String    = "*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    }
}

// MARK: -
/// DATE FORMAT Constants
public struct kDateFormat {
    static let UNIX:String                         = "yyyy-MM-dd HH:mm:ss VV"
    static let SQL:String                          = "yyyy-MM-dd HH:mm:ss Z"
    static let DATE:String                         = "yyyy-MM-dd HH:mm:ss Z"
    static let HTML_HDR_RESPONSE:String            = "EEE, d MMM yyyy Z"
    static let d_MMM_YYYY:String                   = "d MMM yyyy"
    static let d_MMM_yyyy_EEE:String               = "d MMM yyyy (EEE)"
    static let d_MMM_yyyy_EEE_at_hmm_a:String      = "d MMM yyyy (EEE) @ h:mm a"
    static let d_MMM_yyyy_EEE_hmm_a:String         = "d MMM yyyy (EEE) h:mm a"
    static let d_MMM_yyyy_EEEE:String              = "d MMM yyyy (EEEE)"
    static let d_MMM_yyyy_EEEE_at_hmm_a:String     = "d MMM yyyy (EEEE) @ h:mm a"
    static let d_MMM_yyyy_EEEE_hmm_a:String        = "d MMM yyyy (EEEE) h:mm a"
    static let dd_MMM_YYYY:String                  = "dd MMM yyyy"
    static let EEE_MMM_d_yyyy:String               = "EEE MMM d, yyyy"
    static let EEE_MMMM_d_yyyy:String              = "EEE MMMM d, yyyy"
    static let EEEE_MMM_d_yyyy:String              = "EEEE MMM d, yyyy"
    static let EEEE_MMMM_d_yyyy:String             = "EEEE MMMM d, yyyy"
    static let MM:String                           = "MM"
    static let MMddyyyy:String                     = "MM/dd/yyyy"
    static let MMddyyyy_hmm_a:String               = "MM/dd/yyyy h:mm a"
    static let MMM:String                          = "MMM"
    static let MMM_d_yyyy:String                   = "MMM d, yyyy"
    static let MMM_d_yyyy_EEE:String               = "MMM d, yyyy (EEE)"
    static let MMM_d_yyyy_EEE_at_hmm_a:String      = "MMM d, yyyy (EEE.) @ h:mm a"
    static let MMM_d_yyyy_EEE_hmm_a:String         = "MMM d, yyyy (EEE.) h:mm a"
    static let MMM_d_yyyy_EEEE:String              = "MMM d, yyyy (EEEE)"
    static let MMM_d_yyyy_EEEE_at_hmm_a:String     = "MMM d, yyyy (EEEE) @ h:mm a"
    static let MMM_d_yyyy_EEEE_hmm_a:String        = "MMM d, yyyy (EEEE) h:mm a"
    static let MMM_dd_yyyy:String                  = "MMM dd, yyyy"
    static let yyyy:String                         = "yyyy"
    static let yyyyMMd:String                      = "yyyy-MM-d"
    static let yyyyMMdd:String                     = "yyyy-MM-dd"
    static let yyyyMMdd_hmmss_a:String             = "yyyy-MM-dd h:mm:ss a"
    static let yyyyMMdd_HHmmss:String              = "yyyy-MM-dd_HH-mm-ss"
    static let yyyyMMdd_HHmmss_Z:String            = "yyyy-MM-dd HH:mm:ss Z"
    static let yyyyMMMdd:String                    = "yyyy-MMM-dd"
}

// MARK: -
/// HTML Constants
public struct kHTML {
    static let bold = "<b>"
    static let unbold = "</b>"
    static let italic = "<i>"
    static let unitalic = "</i>"
    static let lineFeed = "</br>"
    static let lineFeed1 = "</br>"
    static let lineFeed2 = "</br></br>"
    static let lineFeed3 = "</br></br></br>"
}

// MARK: -
/// IMAGE FILTER Constants
public struct kIMG_FILTERS {
    static let BLOOM       = "CIBloom"
    static let BLUR        = "CIGaussianBlur"
    static let BRIGHTNESS  = "Brightness"
    static let BUMP        = "CIBumpDistortion"
    static let CONTROLS    = "CIColorControls"
    static let EXPOSURE    = "CIExposureAdjust"
    static let HIGHLIGHT   = "CIHighlightShadowAdjust"
    static let GAMMA       = "CIGammaAdjust"
    static let GLOOM       = "CIGloom"
    static let HUE         = "CIHueAdjust"
    static let LUMINOSITY  = "CISharpenLuminance"
    static let PIXELLATE   = "CIPixellate"
    static let POSTERIZE   = "CIColorPosterize"
    static let SEPIA       = "CISepiaTone"
    static let SHARPEN     = "CIUnsharpMask"
    static let VIBRANCE    = "CIVibrance"
    static let VIGNETTE    = "CIVignette"
    static let WHITEPOINT  = "CIWhitePointAdjust"
}

// MARK: -
/// JSON Constants
public struct kJSON {
    static let boundary = "---------------------------14737809831466499882746641449"
}

// MARK: -
/// SPPORTED LANGUAGES Constants
public struct kLANGUAGES {
    static let arabic:String!               = "ar"
    static let chinese_simplified:String!   = "zh-hans"
    static let english:String!              = "en"
    static let french:String!               = "fr"
    static let hindi:String!                = "hi"
    static let italian:String!              = "it"
    static let japanese:String!             = "ja"
    static let portuguese:String!           = "pt"
    static let russian:String!              = "ru"
    static let spanish:String!              = "es"
}

// MARK: -
/// MAPPING Constants
public struct kMAPS {
    static let MAPTYPE_STANDARD  = 0
    static let MAPTYPE_SATELLITE = 1
    static let MAPTYPE_HYBRID    = 2
    static let ZOOM_TO_PIN       = 0.0025
    static let ZOOM_TO_AREA      = 0.05
    static let ZOOM_TO_REGION    = 0.9
    static let ZOOM_TO_COUNTRY   = 35.0
}

// MARK: -
/// HTML MIME Types
public struct kMimeTypeValues {
    static let CSV:String!          = "text/csv"
    static let Img_JPG:String!      = "image/jpeg"
    static let Img_PNG:String!      = "image/png"
    static let PDF:String!          = "application/pdf"
    static let Text:String!         = "text/csv"
    static let ZipArchive:String!   = "application/zip"
}

// MARK: - kMimeTypes
public enum kMimeTypes { case csv,img_JPG,img_PNG,pdf,text,zipArchive }

// MARK: -
public struct kMonths {
    static let January  = 1
    static let Jan      = 1
    static let February = 2
    static let Feb      = 2
    static let March    = 3
    static let Mar      = 3
    static let April    = 4
    static let Apr      = 4
    static let May      = 5
    static let June     = 6
    static let Jun      = 6
    static let July     = 7
    static let Jul      = 7
    static let August   = 8
    static let Aug      = 8
    static let September = 9
    static let Sep      = 9
    static let October  = 10
    static let Oct      = 10
    static let November = 11
    static let Nov      = 11
    static let December = 12
    static let Dec      = 12
}

// MARK: -
/// SCREEN RATIO Constants
public struct kSCREEN_RATIO {
    static let ratio3_4:String!  = "3:4"
    static let ratio4_3:String!  = "4:3"
    static let ratio16_9:String! = "16:9"
    static let ratio3_5:String!  = "3:5"
}

// MARK: -
/// SCREEN SIZE Constants
public struct kSCREEN_SIZE {
    static let mm_38:Float!     = 38
    static let mm_40:Float!     = 40
    static let mm_42:Float!     = 42
    static let mm_44:Float!     = 44
    static let inch_3_5:Float!  = 3.5
    static let inch_4:Float!    = 4.0
    static let inch_4_7:Float!  = 4.7
    static let inch_5_5:Float!  = 5.5
    static let inch_5_8:Float!  = 5.8
    static let inch_6_1:Float!  = 6.1
    static let inch_6_5:Float!  = 6.5
    static let inch_7_9:Float!  = 7.9
    static let inch_9_7:Float!  = 9.7
    static let inch_10_5:Float!  = 10.5
    static let inch_12_9:Float! = 12.9
}

// MARK: -
/// TIME FORMAT Constants
public struct kTimeFormat {
    static let hmm_a        = "h:mm a"
    static let hmm          = "h:mm"
    static let hmmss        = "h:mm:ss"
    static let hmmss_a      = "h:mm:ss a"
    static let mss          = "m:ss"
    static let mssS         = "m:ss:S"
    static let mssSS        = "m:ss:SS"
}

// MARK: - *** CLASS DEFINITIONS ***
public enum senderCategoryTypes:Int { case
    addressList,
    cart,
    colorList,
    countryList,
    creditCardList,
    imgList,
    jurisdictionList,
    list,
    list_Add_Edit_Delete,
    menuList,
    none,
    simpleList,
    currencyList,
    fileList,
    date,
    multiColList
}

class SENDER_INFO:Loopable {
    var Key:String! = ""
    var Placeholder:String! = ""
    var Title:String! = ""
    var `Type`:String! = ""
    var Category:senderCategoryTypes! = senderCategoryTypes.none
    var ValueText:String! = ""
    var NotificationCallbackName:String! = ""
    var NotificationCallbackForEdit:String = ""
    var Value:Double! = 0.0
    var SelectedItem:Int! = 0
    var isEditable:Bool! = false
    var Data:NSArray! = []
    var multiData:[[String]] = []
    var multiDataRecords:[[String:AnyObject]] = []
    var multiDataSelections:[String] = []
    var multiDataWidths:[Int] = []
    var multiDataColors:[UIColor] = []
    var multiDataReliantPlaceholder = ""
    var RecentData:NSArray! = []
    var date:Date! = Date()
    var dateMaxIsToday:Bool! = true
    var decimalPlaces:Int! = 0
    var SQL_Database:String! = ""
    var SQL_Tablename:String! = ""
    var SQL_Fieldname:String! = ""
    var SQL_Categoryname:String! = ""
    var thumbnails:[UIImage]! = []
    var img:UIImage! = UIImage()
}

public struct EDITION {
// MARK: ├─➤ DICTIONARY OF PARAMETER NAMES
    struct Keys { // Maintains a dictionary of parameter names
        static let AppID = "appID"
        static let AppIDNum = "appIDNum"
        static let Edition = "edition"
        static let Target = "target"
        static let Revision = "revision"
        static let Name = "name"
        static let FullName = "fullName"
        static let CopyrightYears = "copyrightYears"
        static let appShortcut_1 = "appShortcut_1"
        static let appShortcut_2 = "appShortcut_2"
        static let appShortcut_3 = "appShortcut_3"
        static let appShortcut_4 = "appShortcut_4"
        static let Color_Text = "color_Text"
        static let Color = "color"
        static let SupportedLanguages = "supportedLanguages"
        static let AppStore_URL = "appStore_URL"
        static let AppStoreExt_URL = "appStoreExt_URL"
        static let AppStoreAppleID = "appStoreAppleID"
        static let WhatsNewFilename = "whatsNewFilename"
        static let HelpFilename = "helpFilename"
        static let FabricAPIKey = "fabricAPIKey"
        static let Website_URL = "website_URL"
        static let YouTube_URL = "youTube_URL"
        static let FaceBook_URL = "faceBook_URL"
        static let Twitter_URL = "twitter_URL"
        static let LinkedIn_URL = "linkedIn_URL"
        static let GooglePlus_URL = "googlePlus_URL"
        static let Pinterest_URL = "pinterest_URL"
        static let Instagram_URL = "instagram_URL"
        static let BookLink = "bookLink"
    }
    
// MARK: ├─➤ PARAMETERS
    // App
    var appID:String = ""
    var appIDNum:Int = 0
    var edition:String = ""
    var target:String = ""
    var revision:String = ""
    var name:String = ""
    var fullName:String = ""
    var copyrightYears:String = ""
    // Icons
    var appShortcut_1:String = ""
    var appShortcut_2:String = ""
    var appShortcut_3:String = ""
    var appShortcut_4:String = ""
    // Theme
    var color_Text:String = ""
    var color:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    // Languages
    var supportedLanguages:String = ""
    // App Store
    var appStore_URL:String = ""
    var appStoreExt_URL:String = ""
    var appStoreAppleID:String = ""
    // Help
    var whatsNewFilename:String = ""
    var helpFilename:String = ""
    // 3rd Party Params
    var fabricAPIKey:String = ""
    // URL's
    var website_URL:String = ""
    var youTube_URL:String = ""
    var faceBook_URL:String = ""
    var twitter_URL:String = ""
    var linkedIn_URL:String = ""
    var googlePlus_URL:String = ""
    var pinterest_URL:String = ""
    var instagram_URL:String = ""
    var bookLink:String = ""

// MARK: ├─➤ INIT
    init(dictionary:[String:AnyObject]) {
        if let temp = dictionary[Keys.AppID] as? String { appID = temp }
        if let temp = dictionary[Keys.AppIDNum] as? Int { appIDNum = temp }
        if let temp = dictionary[Keys.AppStore_URL] as? String { appStore_URL = temp }
        if let temp = dictionary[Keys.AppStoreAppleID] as? String { appStoreAppleID = temp }
        if let temp = dictionary[Keys.AppStoreExt_URL] as? String { appStoreExt_URL = temp }
        if let temp = dictionary[Keys.BookLink] as? String { bookLink = temp }
        if let temp = dictionary[Keys.Color] as? UIColor { color = temp }
        if let temp = dictionary[Keys.Color_Text] as? String { color_Text = temp }
        if let temp = dictionary[Keys.CopyrightYears] as? String { copyrightYears = temp }
        if let temp = dictionary[Keys.Edition] as? String { edition = temp }
        if let temp = dictionary[Keys.FabricAPIKey] as? String { fabricAPIKey = temp }
        if let temp = dictionary[Keys.FaceBook_URL] as? String { faceBook_URL = temp }
        if let temp = dictionary[Keys.FullName] as? String { fullName = temp }
        if let temp = dictionary[Keys.GooglePlus_URL] as? String { googlePlus_URL = temp }
        if let temp = dictionary[Keys.HelpFilename] as? String { helpFilename = temp }
        if let temp = dictionary[Keys.Instagram_URL] as? String { instagram_URL = temp }
        if let temp = dictionary[Keys.LinkedIn_URL] as? String { linkedIn_URL = temp }
        if let temp = dictionary[Keys.Name] as? String { name = temp }
        if let temp = dictionary[Keys.appShortcut_1] as? String { appShortcut_1 = temp }
        if let temp = dictionary[Keys.appShortcut_2] as? String { appShortcut_2 = temp }
        if let temp = dictionary[Keys.appShortcut_3] as? String { appShortcut_3 = temp }
        if let temp = dictionary[Keys.appShortcut_4] as? String { appShortcut_4 = temp }
        if let temp = dictionary[Keys.Pinterest_URL] as? String { pinterest_URL = temp }
        if let temp = dictionary[Keys.Revision] as? String { revision = temp }
        if let temp = dictionary[Keys.SupportedLanguages] as? String { supportedLanguages = temp }
        if let temp = dictionary[Keys.Target] as? String { target = temp }
        if let temp = dictionary[Keys.Twitter_URL] as? String { twitter_URL = temp }
        if let temp = dictionary[Keys.Website_URL] as? String { website_URL = temp }
        if let temp = dictionary[Keys.WhatsNewFilename] as? String { whatsNewFilename = temp }
        if let temp = dictionary[Keys.YouTube_URL] as? String { youTube_URL = temp }
    }
    
// MARK: ├─➤ DECODER
    init(coder unarchiver: NSCoder) {
        // App
        appID = unarchiver.decodeObject(forKey: Keys.AppID) as? String ?? ""
        appIDNum = unarchiver.decodeInteger(forKey: Keys.AppIDNum)
        edition = unarchiver.decodeObject(forKey: Keys.Edition) as? String ?? ""
        target = unarchiver.decodeObject(forKey: Keys.Target) as? String ?? ""
        revision = unarchiver.decodeObject(forKey: Keys.Revision) as? String ?? ""
        name = unarchiver.decodeObject(forKey: Keys.Name) as? String ?? ""
        fullName = unarchiver.decodeObject(forKey: Keys.FullName) as? String ?? ""
        copyrightYears = unarchiver.decodeObject(forKey: Keys.CopyrightYears) as? String ?? ""
        // Icons
        appShortcut_1 = unarchiver.decodeObject(forKey: Keys.appShortcut_1) as? String ?? ""
        appShortcut_2 = unarchiver.decodeObject(forKey: Keys.appShortcut_2) as? String ?? ""
        appShortcut_3 = unarchiver.decodeObject(forKey: Keys.appShortcut_3) as? String ?? ""
        appShortcut_4 = unarchiver.decodeObject(forKey: Keys.appShortcut_4) as? String ?? ""
        // Theme
        color_Text = unarchiver.decodeObject(forKey: Keys.Color_Text) as? String ?? ""
        color = unarchiver.decodeObject(forKey: Keys.Color) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // Languages
        supportedLanguages = unarchiver.decodeObject(forKey: Keys.SupportedLanguages) as? String ?? ""
        // App Store
        appStore_URL = unarchiver.decodeObject(forKey: Keys.AppStore_URL) as? String ?? ""
        appStoreExt_URL = unarchiver.decodeObject(forKey: Keys.AppStoreExt_URL) as? String ?? ""
        appStoreAppleID = unarchiver.decodeObject(forKey: Keys.AppStoreAppleID) as? String ?? ""
        // Help
        whatsNewFilename = unarchiver.decodeObject(forKey: Keys.WhatsNewFilename) as? String ?? ""
        helpFilename = unarchiver.decodeObject(forKey: Keys.HelpFilename) as? String ?? ""
        // 3rd Party Params
        fabricAPIKey = unarchiver.decodeObject(forKey: Keys.FabricAPIKey) as? String ?? ""
        // URL's
        website_URL = unarchiver.decodeObject(forKey: Keys.Website_URL) as? String ?? ""
        youTube_URL = unarchiver.decodeObject(forKey: Keys.YouTube_URL) as? String ?? ""
        faceBook_URL = unarchiver.decodeObject(forKey: Keys.FaceBook_URL) as? String ?? ""
        twitter_URL = unarchiver.decodeObject(forKey: Keys.Twitter_URL) as? String ?? ""
        linkedIn_URL = unarchiver.decodeObject(forKey: Keys.LinkedIn_URL) as? String ?? ""
        googlePlus_URL = unarchiver.decodeObject(forKey: Keys.GooglePlus_URL) as? String ?? ""
        pinterest_URL = unarchiver.decodeObject(forKey: Keys.Pinterest_URL) as? String ?? ""
        instagram_URL = unarchiver.decodeObject(forKey: Keys.Instagram_URL) as? String ?? ""
        bookLink = unarchiver.decodeObject(forKey: Keys.BookLink) as? String ?? ""
    }
    
// MARK: ├─➤ ENCODER
    func encode(with archiver: NSCoder) {
        // App
        archiver.encode(appID, forKey: Keys.AppID)
        archiver.encode(appIDNum, forKey: Keys.AppIDNum)
        archiver.encode(edition, forKey: Keys.Edition)
        archiver.encode(target, forKey: Keys.Target)
        archiver.encode(revision, forKey: Keys.Revision)
        archiver.encode(name, forKey: Keys.Name)
        archiver.encode(fullName, forKey: Keys.FullName)
        archiver.encode(copyrightYears, forKey: Keys.CopyrightYears)
        // Icons
        archiver.encode(appShortcut_1, forKey: Keys.appShortcut_1)
        archiver.encode(appShortcut_2, forKey: Keys.appShortcut_2)
        archiver.encode(appShortcut_3, forKey: Keys.appShortcut_3)
        archiver.encode(appShortcut_4, forKey: Keys.appShortcut_4)
        // Theme
        archiver.encode(color_Text, forKey: Keys.Color_Text)
        archiver.encode(color, forKey: Keys.Color)
        // Languages
        archiver.encode(supportedLanguages, forKey: Keys.SupportedLanguages)
        // App Store
        archiver.encode(appStore_URL, forKey: Keys.AppStore_URL)
        archiver.encode(appStoreExt_URL, forKey: Keys.AppStoreExt_URL)
        archiver.encode(appStoreAppleID, forKey: Keys.AppStoreAppleID)
        // Help
        archiver.encode(whatsNewFilename, forKey: Keys.WhatsNewFilename)
        archiver.encode(helpFilename, forKey: Keys.HelpFilename)
        // 3rd Party Params
        archiver.encode(fabricAPIKey, forKey: Keys.FabricAPIKey)
        // URL's
        archiver.encode(website_URL, forKey: Keys.Website_URL)
        archiver.encode(youTube_URL, forKey: Keys.YouTube_URL)
        archiver.encode(faceBook_URL, forKey: Keys.FaceBook_URL)
        archiver.encode(twitter_URL, forKey: Keys.Twitter_URL)
        archiver.encode(linkedIn_URL, forKey: Keys.LinkedIn_URL)
        archiver.encode(googlePlus_URL, forKey: Keys.GooglePlus_URL)
        archiver.encode(pinterest_URL, forKey: Keys.Pinterest_URL)
        archiver.encode(instagram_URL, forKey: Keys.Instagram_URL)
        archiver.encode(bookLink, forKey: Keys.BookLink)
    }
}


// MARK: - *** DEVELOPER DEFINITIONS ***
/// Developer information
struct kDeveloper {
    static let Name:String!                     = "Creative App Solutions"
    static let Location:String!                 = "NEW YORK - USA       www.CreativeApps.US"
    static let URL:String!                      = "https://www.CreativeApps.US"
    static let Device_UserName:String!          = "Kevin Messina"
    static let Device_EMail:String!             = "KMWeb@Mac.com"
    static let Device_UDID_iPhone5s:String!     = "761cccf2cbfd07a2f4a7dc4e35f5e1c67711a8e1"
    static let Device_UDID_iPhone6sPlus:String! = "a4eb631086b0a43dac3b3b1faa83ca8339f8ccea"
    static let Device_UDID_iPad3:String!        = "8dbca97d213e2e8ec2309e5f44bb7e81be220ee9"
    static let Device_UDID_iPadAir2:String!     = "3aa3c4642fc5d6a5bb3fd29f044e207c3434236a"
    static let Device_UDID_iPadPro_12_9:String! = "ed41f1cd4eda1d374aac52a49285593eea6e0332"
    static let Device_UDID_Watch:String!        = "d73a1e241c7cf6396acafb036826bd11bf3e8250"
}


// MARK: - *** ERROR DEFINITIONS ***
// MARK: DataEntryIssue
enum DataEntryIssue:Error { case tooLong,invalidChar,blank,invalidEmailAddress }
// MARK: SQL_Issue
enum SQL_Issue:Error { case failure }


// MARK: - *** FONT DEFINITIONS ***
public struct Font {
    public func printAllNamesToConsole() {
        for family: String in UIFont.familyNames {
            if isSim { print("\(family)") }
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("├─➤ \(names)")
            }
        }
    }
    
    public struct AcademyEngravedLET {
        public static let regular = "AcademyEngravedLetPlain"
    }
    public struct AlNile {
        public static let regular = "AlNile"
        public static let bold = "AlNile-Bold"
    }
    public struct AmericanTypewriter {
        public static let regular = "AmericanTypewriter"
        public static let bold = "AmericanTypewriter-Bold"
        public static let light = "AmericanTypewriter-Light"
        public struct Condensed {
            public static let regular = "AmericanTypewriter-Condensed"
            public static let bold = "AmericanTypewriter-CondensedBold"
            public static let light = "AmericanTypewriter-CondensedLight"
        }
    }
    public struct AppleColorEmoji {
        public static let regular = "AppleColorEmoji"
    }
    public struct AppleSDGothicNeo {
        public static let regular = "AppleSDGothicNeo-Regular"
        public static let medium = "AppleSDGothicNeo-Medium"
        public static let bold = "AppleSDGothicNeo-Bold"
        public static let thin = "AppleSDGothicNeo-Thin"
        public static let light = "AppleSDGothicNeo-Light"
        public static let ultraLight = "AppleSDGothicNeo-UltraLight"
        public static let semibold = "AppleSDGothicNeo-SemiBold"
    }
    public struct Arial {
        public static let regular = "ArialMT"
        public static let bold = "Arial-BoldMT"
        public struct Italic {
            public static let regular = "Arial-ItalicMT"
            public static let bold = "Arial-BoldItalicMT"
        }
    }
    public struct ArialHebrew {
        public static let regular = "ArialHebrew"
        public static let bold = "ArialHebrew-Bold"
        public static let light = "ArialHebrew-Light"
    }
    public struct ArialRoundedMTBold {
        public static let regular = "ArialRoundedMTBold"
    }
    public struct Avenir {
        public static let italic = "Avenir-Oblique"
        public static let regular = "Avenir-Roman"
        public struct Black {
            public static let regular = "Avenir-Black"
            public static let italic = "Avenir-BlackOblique"
        }
        public struct Book {
            public static let regular = "Avenir-Book"
            public static let italic = "Avenir-BookOblique"
        }
        public struct Heavy {
            public static let regular = "Avenir-Heavy"
            public static let italic = "Avenir-HeavyOblique"
        }
        public struct Light {
            public static let regular = "Avenir-Light"
            public static let italic = "Avenir-LightOblique"
        }
        public struct Medium {
            public static let regular = "Avenir-Medium"
            public static let italic = "Avenir-MediumOblique"
        }
    }
    public struct AvenirNext {
        public struct Bold {
            public static let regular = "AvenirNext-Bold"
            public static let italic = "AvenirNext-BoldItalic"
        }
        public struct DemiBold {
            public static let regular = "AvenirNext-DemiBold"
            public static let italic = "AvenirNext-DemiBoldItalic"
        }
        public struct Heavy {
            public static let regular = "AvenirNext-Heavy"
            public static let italic = "AvenirNext-HeavyItalic"
        }
        public static let italic = "AvenirNext-Italic"
        public static let regular = "AvenirNext-Regular"
        public struct Medium {
            public static let regular = "AvenirNext-Medium"
            public static let italic = "AvenirNext-MediumItalic"
        }
        public struct UltraLight {
            public static let regular = "AvenirNext-UltraLight"
            public static let italic = "AvenirNext-UltraLightItalic"
        }
    }
    public struct AvenirNextCondensed {
        public struct Bold {
            public static let regular = "AvenirNextCondensed-Bold"
            public static let italic = "AvenirNextCondensed-BoldItalic"
        }
        public struct DemiBold {
            public static let regular = "AvenirNextCondensed-DemiBold"
            public static let italic = "AvenirNextCondensed-DemiBoldItalic"
        }
        public struct Heavy {
            public static let regular = "AvenirNextCondensed-Heavy"
            public static let italic = "AvenirNextCondensed-HeavyItalic"
        }
        public static let italic = "AvenirNextCondensed-Italic"
        public static let regular = "AvenirNextCondensed-Regular"
        public struct Medium {
            public static let regular = "AvenirNextCondensed-Medium"
            public static let italic = "AvenirNextCondensed-MediumItalic"
        }
        public struct UltraLight {
            public static let regular = "AvenirNextCondensed-UltraLight"
            public static let italic = "AvenirNextCondensed-UltraLightItalic"
        }
    }
    public struct BanglaSangamMN {
        public static let regular = "BanglaSangamMN"
        public static let bold = "BanglaSangamMN-Bold"
    }
    public struct Baskerville {
        public struct Bold {
            public static let regular = "Baskerville-Bold"
            public static let italic = "Baskerville-BoldItalic"
        }
        public static let italic = "Baskerville-Italic"
        public struct SemiBold {
            public static let regular = "Baskerville-SemiBold"
            public static let italic = "Baskerville-SemiBoldItalic"
        }
    }
    public struct BodoniOrnaments {
        public static let regular = "BodoniOrnaments"
    }
    public struct Bodoni72 {
        public static let bold = "BodoniSvtyTwoITCTT-Bold"
        public struct Book {
            public static let regular = "BodoniSvtyTwoITCTT-Book"
            public static let italic = "BodoniSvtyTwoITCTT-BookItalic"
        }
    }
    public struct Bodoni72Oldstyle {
        public static let bold = "BodoniSvtyTwoOSITCTT-Bold"
        public struct Book {
            public static let regular = "BodoniSvtyTwoOSITCTT-Book"
            public static let italic = "BodoniSvtyTwoOSITCTT-BookItalic"
        }
    }
    public struct Bodoni72Smallcaps {
        public static let regular = "BodoniSvtyTwoSCITCTT-Book"
    }
    public struct BradleyHand {
        public static let regular = "BradleyHandITCTT-Bold"
    }
    public struct ChalkboardSE {
        public static let regular = "ChalkboardSE-Regular"
        public static let bold = "ChalkboardSE-Bold"
        public static let light = "ChalkboardSE-Light"
    }
    public struct Chalkduster {
        public static let regular = "Chalkduster"
    }
    public struct Cochin {
        public static let regular = "Cochin"
        public static let italic = "Cochin-Italic"
        public struct Bold {
            public static let regular = "Cochin-Bold"
            public static let italic = "Cochin-BoldItalic"
        }
    }
    public struct Copperplate {
        public static let regular = "Copperplate"
        public static let bold = "Copperplate-Bold"
        public static let light = "Copperplate-Italic"
    }
    public struct Courier {
        public static let regular = "Courier"
        public static let italic = "Courier-Oblique"
        public struct Bold {
            public static let regular = "Courier-Bold"
            public static let italic = "Courier-BoldOblique"
        }
    }
    public struct CourierNew {
        public static let regular = "CourierNewPSMT"
        public static let italic = "CourierNewPS-ItalicMT"
        public struct Bold {
            public static let regular = "CourierNewPS-BoldMT"
            public static let italic = "CourierNewPS-ItalicMT"
        }
    }
    public struct DIN_Alternate {
        public static let bold = "DINAlternate-Bold"
    }
    public struct DIN_Condensed {
        public static let bold = "DINCondensed-Bold"
    }
    public struct Damascus {
        public static let regular = "Damascus"
        public static let bold = "DamascusBold"
        public static let light = "DamascusLight"
        public static let medium = "DamascusMedium"
        public static let semiBold = "DamascusSemiBold"
    }
    public struct DevanagariSangamMN {
        public static let regular = "DevanagariSangamMN"
        public static let bold = "DevanagariSangamMN-Bold"
    }
    public struct Didot {
        public static let regular = "Didot"
        public static let bold = "Didot-Bold"
        public static let italic = "Didot-Italic"
    }
    public struct DiwanMishafi {
        public static let regular = "DiwanMishafi"
    }
    public struct EuphemiaUCAS {
        public static let regular = "EuphemiaUCAS"
        public static let bold = "EuphemiaUCAS-Bold"
        public static let italic = "EuphemiaUCAS-Italic"
    }
    public struct Farah {
        public static let regular = "Farah"
    }
    public struct Futura {
        public struct Condensed {
            public static let regular = "Futura-CondensedMedium"
            public static let italic = "Futura-CondensedExtraBold"
        }
        public struct Medium {
            public static let regular = "Futura-Medium"
            public static let italic = "Futura-MediumItalic"
        }
    }
    public struct GeezaPro {
        public static let regular = "GeezaPro"
        public static let bold = "GeezaPro-Bold"
    }
    public struct Georgia {
        public static let regular = "Georgia"
        public static let bold = "Georgia-Bold"
        public struct Italic {
            public static let regular = "Georgia-Italic"
            public static let bold = "Georgia-BoldItalic"
        }
    }
    public struct GilSans {
        public static let regular = "GilSans"
        public static let italic = "GilSans-Italic"
        public struct SemiBold {
            public static let regular = "GillSans-SemiBold"
            public static let bold = "GillSans-SemiBoldItalic"
        }
        public struct Bold {
            public static let regular = "GillSans-Bold"
            public static let bold = "GillSans-BoldItalic"
            public static let ultraBold = "GillSans-UltraBold"
        }
        public struct Light {
            public static let regular = "GillSans-Light"
            public static let bold = "GillSans-LightItalic"
        }
    }
    public struct GujaratiSangamMN {
        public static let regular = "GujaratiSangamMN"
        public static let italic = "GujaratiSangamMN-Bold"
    }
    public struct GurmukhiMN {
        public static let regular = "GurmukhiMN"
        public static let italic = "GurmukhiMN-Bold"
    }
    public struct HeitiSC {
        public static let light = "STHeitiSC-Light"
        public static let medium = "STHeitiSC-Medium"
    }
    public struct HeitiTC {
        public static let light = "STHeitiTC-Light"
        public static let medium = "STHeitiTC-Medium"
    }
    public struct Helvetica {
        public static let regular = "Helvetica"
        public static let italic = "Helvetica-Oblique"
        public struct Bold {
            public static let bold = "Helvetica-Bold"
            public static let italic = "Helvetica-BoldItalic"
        }
        public struct Light {
            public static let regular = "Helvetica-Light"
            public static let bold = "Helvetica-LightItalic"
        }
    }
    public struct HelveticaNeue {
        public static let regular = "HelveticaNeue"
        public static let italic = "HelveticaNeue-Italic"
        public struct Bold {
            public static let bold = "HelveticaNeue-Bold"
            public static let italic = "HelveticaNeue-BoldItalic"
        }
        public struct Condensed {
            public static let black = "HelveticaNeue-CondensedBlack"
            public static let bold = "HelveticaNeue-CondensedBold"
        }
        public struct Light {
            public static let regular = "HelveticaNeue-Light"
            public static let italic = "HelveticaNeue-LightItalic"
        }
        public struct Medium {
            public static let regular = "HelveticaNeue-Medium"
            public static let italic = "HelveticaNeue-MediumItalic"
        }
        public struct UltraLight {
            public static let regular = "HelveticaNeue-UltraLight"
            public static let italic = "HelveticaNeue-UltraLightItalic"
        }
        public struct Thin {
            public static let regular = "HelveticaNeue-Thin"
            public static let italic = "HelveticaNeue-ThinItalic"
        }
    }
    public struct HiraginoMinchoProN {
        public static let regular = "HiraMinProN-W3"
        public static let bold = "HiraMinProN-W6"
    }
    public struct HiraginoSans {
        public static let regular = "HiraginoSans-W3"
        public static let bold = "HiraginoSans-W6"
    }
    public struct HoeflerText {
        public static let regular = "HoeflerText-Regular"
        public static let italic = "HoeflerText-Italic"
        public struct Black {
            public static let regular = "HoeflerText-Black"
            public static let italic = "HoeflerText-BlackItalic"
        }
    }
    public struct IowanOldStyle {
        public static let regular = "IowanOldStyle-Roman"
        public static let italic = "IowanOldStyle-Italic"
        public struct Bold {
            public static let regular = "IowanOldStyle-Bold"
            public static let italic = "IowanOldStyle-BoldItalic"
        }
    }
    public struct Kailasa {
        public static let regular = "Kailasa"
        public static let bold = "Kailasa-Bold"
    }
    public struct KannadaSangamMN {
        public static let regular = "KannadaSangamMN"
        public static let bold = "KannadaSangamMN-Bold"
    }
    public struct KhmerSangamMN {
        public static let regular = "KhmerSangamMN"
    }
    public struct KohinoorBangla {
        public static let light = "KohinoorBangla-Light"
        public static let regular = "KohinoorBangla-Regular"
        public static let semiBold = "KohinoorBangla-SemiBold"
    }
    public struct KohinoorTelugu {
        public static let light = "KohinoorTelugu-Light"
        public static let regular = "KohinoorTelugu-Regular"
        public static let semiBold = "KohinoorTelugu-SemiBold"
    }
    public struct LaoSangamMN {
        public static let light = "LaoSangamMN"
    }
    public struct MalayalamSangamMN  {
        public static let regular = "MalayalamSangamMN"
        public static let bold = "MalayalamSangamMN-Bold"
    }
    public struct Menlo {
        public static let regular = "Menlo-Regular"
        public static let italic = "Menlo-Italic"
        public struct Bold {
            public static let regular = "Menlo-Bold"
            public static let italic = "Menlo-BoldItalic"
        }
    }
    public struct Marion {
        public static let regular = "Marion-Regular"
        public static let bold = "Marion-Bold"
        public static let italic = "Marion-Italic"
    }
    public struct MarkerFelt {
        public static let thin = "MarkerFelt-Thin"
        public static let wide = "MarkerFelt-Wide"
    }
    public struct Noteworthy {
        public static let light = "Noteworthy-Light"
        public static let bold = "Noteworthy-Bold"
    }
    public struct Optima {
        public static let regular = "Optima-Regular"
        public static let italic = "Optima-Italic"
        public static let extraBlack = "Optima-ExtraBlack"
        public struct Bold {
            public static let regular = "Optima-Bold"
            public static let bold = "Optima-BoldItalic"
        }
    }
    public struct OriyaSangamMN {
        public static let light = "OriyaSangamMN"
        public static let bold = "OriyaSangamMN-Bold"
    }
    public struct Palatino {
        public static let regular = "Palatino-Roman"
        public static let italic = "Palatino-Italic"
        public struct Bold {
            public static let regular = "Palatino-Bold"
            public static let bold = "Palatino-BoldItalic"
        }
    }
    public struct Papyrus {
        public static let regular = "Papyrus"
        public static let condensed = "Papyrus-Condensed"
    }
    public struct PartyLET {
        public static let regular = "PartyLetPlain"
    }
    public struct PingFangHK {
        public static let ultraLight = "PingFangHK-Ultralight"
        public static let Light = "PingFangHK-Light"
        public static let thin = "PingFangHK-Thin"
        public static let regular = "PingFangHK-Regular"
        public static let medium = "PingFangHK-Medium"
        public static let semiBold = "PingFangHK-SemiBold"
    }
    public struct PingFangSC {
        public static let ultraLight = "PingFangSC-Ultralight"
        public static let Light = "PingFangSC-Light"
        public static let thin = "PingFangSC-Thin"
        public static let regular = "PingFangSC-Regular"
        public static let medium = "PingFangSC-Medium"
        public static let semiBold = "PingFangSC-SemiBold"
    }
    public struct PingFangTC {
        public static let ultraLight = "PingFangTC-Ultralight"
        public static let Light = "PingFangTC-Light"
        public static let thin = "PingFangTC-Thin"
        public static let regular = "PingFangTC-Regular"
        public static let medium = "PingFangTC-Medium"
        public static let semiBold = "PingFangTC-SemiBold"
    }
    public struct SanFrancisco_Watch {
        public struct Display {
            public static let black = "SanFranciscoDisplay-Black"
            public static let bold = "SanFranciscoDisplay-Bold"
            public static let heavy = "SanFranciscoDisplay-Heavy"
            public static let light = "SanFranciscoDisplay-Light"
            public static let medium = "SanFranciscoDisplay-Medium"
            public static let regular = "SanFranciscoDisplay-Regular"
            public static let semiBold = "SanFranciscoDisplay-SemiBold"
            public static let thin = "SanFranciscoDisplay-Thin"
            public static let ultraLight = "SanFranciscoDisplay-UltraLight"
        }
        public struct Rounded {
            public static let black = "SanFranciscoRounded-Black"
            public static let bold = "SanFranciscoRounded-Bold"
            public static let heavy = "SanFranciscoRounded-Heavy"
            public static let light = "SanFranciscoRounded-Light"
            public static let medium = "SanFranciscoRounded-Medium"
            public static let regular = "SanFranciscoRounded-Regular"
            public static let semiBold = "SanFranciscoRounded-SemiBold"
            public static let thin = "SanFranciscoRounded-Thin"
            public static let ultraLight = "SanFranciscoRounded-UltraLight"
        }
        public struct Text {
            public static let black = "SanFranciscoText-Bold"
            public static let boldG1 = "SanFranciscoText-BoldG1"
            public static let boldG2 = "SanFranciscoText-BoldG2"
            public static let boldG3 = "SanFranciscoText-BoldG3"
            public static let boldItalicG1 = "SanFranciscoText-BoldItalicG1"
            public static let boldItalicG2 = "SanFranciscoText-BoldItalicG2"
            public static let boldItalicG3 = "SanFranciscoText-BoldItalicG3"
            public static let heavy = "SanFranciscoText-Heavy"
            public static let heavyItalic = "SanFranciscoText-HeavyItalic"
            public static let light = "SanFranciscoText-Light"
            public static let lightItalic = "SanFranciscoText-LightItalic"
            public static let medium = "SanFranciscoText-Medium"
            public static let mediumItalic = "SanFranciscoText-MediumItalic"
            public static let regular = "SanFranciscoText-Regular"
            public static let regularG1 = "SanFranciscoText-RegularG1"
            public static let regularG2 = "SanFranciscoText-RegularG2"
            public static let regularG3 = "SanFranciscoText-RegularG3"
            public static let regularItalic = "SanFranciscoText-RegularItalic"
            public static let regularItalicG1 = "SanFranciscoText-RegularItalicG1"
            public static let regularItalicG2 = "SanFranciscoText-RegularItalicG2"
            public static let regularItalicG3 = "SanFranciscoText-RegularItalicG3"
            public static let semiBold = "SanFranciscoText-SemiBold"
            public static let semiBoldItalic = "SanFranciscoText-SemiBoldItalic"
            public static let thin = "SanFranciscoText-Thin"
            public static let thinItalic = "SanFranciscoText-ThinItalic"
        }
    }
    public struct SavoyeLet {
        public static let regular = "SavoyeLetPlain"
    }
    public struct SinhalaSangamMN {
        public static let regular = "SinhalaSangamMN"
        public static let bold = "SinhalaSangamMN-Bold"
    }
    public struct SnellRoundhand {
        public static let regular = "SnellRoundhand"
        public static let bold = "SnellRoundhand-Bold"
        public static let black = "SnellRoundhand-Black"
    }
    public struct Symbol {
        public static let regular = "Symbol"
    }
    public struct TamilSangamMN {
        public static let regular = "TamilSangamMN"
        public static let bold = "TamilSangamMN-Bold"
    }
    public struct TeluguSangamMN {
        public static let regular = "TeluguSangamMN"
        public static let bold = "TeluguSangamMN-Bold"
    }
    public struct Thonburi {
        public static let regular = "Thonburi"
        public static let bold = "Thonburi-Bold"
        public static let light = "Thonburi-Light"
    }
    public struct TimesNewRoman {
        public static let regular = "TimesNewRomanPSMT"
        public static let italic = "TimesNewRomanPS-ItalicMT"
        public struct Bold {
            public static let regular = "TimesNewRomanPS-BoldMT"
            public static let italic = "TimesNewRomanPS-BoldItalicMT"
        }
    }
    public struct TrebuchetMS {
        public static let regular = "TrebuchetMS"
        public static let italic = "TrebuchetMS-Italic"
        public struct Bold {
            public static let regular = "TrebuchetMS-Bold"
            public static let italic = "TrebuchetMS-BoldItalic"
        }
    }
    public struct Verdana {
        public static let regular = "Verdana"
        public static let italic = "Verdana-Italic"
        public struct Bold {
            public static let regular = "Verdana-Bold"
            public static let italic = "Verdana-BoldItalic"
        }
    }
    public struct ZapfDingbats {
        public static let regular = "ZapfDingbatsITC"
    }
    public struct Zapfino {
        public static let regular = "Zapfino"
    }
}


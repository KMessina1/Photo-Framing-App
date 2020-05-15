/*--------------------------------------------------------------------------------------------------------------------------
   File: DeviceList.swift
 Author: Kevin Messina
Created: August 5, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - DeviceList
@objc(DeviceList) class DeviceList:NSArray {
    var Version:String { return "2.00" }
    
// https://www.theiphonewiki.com/wiki/Models // Device Models list
// https://iosres.com // Device Screen-size list
// https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions //Device Resolutions list
    
    var deviceInfo = [ // iOS 8+ compatible devices
/* iPod 1 */            "iPod1,1":"iPod Touch",
/* iPod 2 */            "iPod2,1":"iPod Touch 2",
/* iPod 3 */            "iPod3,1":"iPod Touch 3",
/* iPod 4 */            "iPod4,1":"iPod Touch 4",
/* iPod 5 */            "iPod5,1":"iPod Touch 5",
/* iPod 6 */            "iPod7,1":"iPod Touch 6",

/* iPhone 1 */          "iPhone1,1":"iPhone",
/* iPhone 3G */         "iPhone1,2":"iPhone 3G",
/* iPhone 3GS */        "iPhone2,1":"iPhone 3GS",
/* iPhone 4 */          "iPhone3,1":"iPhone 4", "iPhone3,2":"iPhone 4", "iPhone3,3":"iPhone 4",
/* iPhone 4S */         "iPhone4,1":"iPhone 4S",
/* iPhone 5 */          "iPhone5,1":"iPhone 5", "iPhone5,2":"iPhone 5",
/* iPhone 5C */         "iPhone5,3":"iPhone 5C", "iPhone5,4":"iPhone 5C",
/* iPhone 5S */         "iPhone6,1":"iPhone 5S", "iPhone6,2":"iPhone 5S",
/* iPhone 6 */          "iPhone7,2":"iPhone 6",
/* iPhone 6 Plus */     "iPhone7,1":"iPhone 6 Plus",
/* iPhone 6s */         "iPhone8,1":"iPhone 6S",
/* iPhone 6s Plus */    "iPhone8,2":"iPhone 6S Plus",
/* iPhone SE */         "iPhone8,4":"iPhone SE",
/* iPhone 7 */          "iPhone9,1":"iPhone 7","iPhone9,3":"iPhone 7",
/* iPhone 7 Plus */     "iPhone9,2":"iPhone 7 Plus","iPhone9,4":"iPhone 7 Plus",
/* iPhone 8 */          "iPhone10,1":"iPhone 8","iPhone10,4":"iPhone 8",
/* iPhone 8 Plus */     "iPhone10,2":"iPhone 8 Plus","iPhone10,5":"iPhone 8 Plus",
/* iPhone X */          "iPhone10,3":"iPhone X","iPhone10,6":"iPhone X",
/* iPhone XR */         "iPhone11,8":"iPhone XR",
/* iPhone XS */         "iPhone11,2":"iPhone XS",
/* iPhone XS Max */     "iPhone11,4":"iPhone XS Max","iPhone11,6":"iPhone XS Max",

/* iPad Mini */         "iPad2,5":"iPad Mini 1", "iPad2,6":"iPad Mini 1", "iPad2,7":"iPad Mini 1",
/* iPad Mini 2 */       "iPad4,4":"iPad Mini 2", "iPad4,5":"iPad Mini 2", "iPad4,6":"iPad Mini 2",
/* iPad Mini 3 */       "iPad4,7":"iPad Mini 3", "iPad4,8":"iPad Mini 3", "iPad4,9":"iPad Mini 3",
/* iPad Mini 4 */       "iPad5,1":"iPad Mini 4", "iPad5,2":"iPad Mini 4",

/* iPad 1 */            "iPad1,1":"iPad 1",
/* iPad 2 */            "iPad2,1":"iPad 2", "iPad2,2":"iPad 2", "iPad2,3":"iPad 2", "iPad2,4":"iPad 2",
/* iPad 3 */            "iPad3,1":"iPad 3", "iPad3,2":"iPad 3", "iPad3,3":"iPad 3",
/* iPad 4 */            "iPad3,4":"iPad 4", "iPad3,5":"iPad 4", "iPad3,6":"iPad 4",
/* iPad Air 1 */        "iPad4,1":"iPad Air 1", "iPad4,2":"iPad Air 1", "iPad4,3":"iPad Air 1",
/* iPad Air 2 */        "iPad5,3":"iPad Air 2", "iPad5,4":"iPad Air 2",
/* iPad Pro 9.7" 1 */  "iPad6,3":"iPad Pro 1 9.7\"", "iPad6,4":"iPad Pro 1 9.7\"",
/* iPad Pro 12.9" 1 */ "iPad6,7":"iPad Pro 1 12.9\"", "iPad6,8":"iPad Pro 1 12.9\"",
/* iPad 5 */            "iPad6,11":"iPad 5", "iPad6,12":"iPad 5",
/* iPad 6 */            "iPad7,5":"iPad 6", "iPad7,6":"iPad 6",
/* iPad Pro 10.5" 1 */  "iPad7,3":"iPad Pro 1 10.5\"", "iPad7,4":"iPad Pro 1 10.5\"",
/* iPad Pro 12.9" 2 */  "iPad7,1":"iPad Pro 2 12.9\"", "iPad7,2":"iPad Pro 2 12.9\"",

/* Watch series 1 */   "Watch1,1":"Watch 38mm Original", "Watch1,2":"Watch 42mm Original",
/* Watch series 2 */   "Watch2,6":"Watch 38mm Ser. 1", "Watch2,7":"Watch 42mm Ser. 1",
                         "Watch2,3":"Watch 38mm Ser. 2", "Watch2,4":"Watch 42mm Ser. 2",
/* Watch series 3 */   "Watch3,1":"Watch 38mm Ser. 3", "Watch3,2":"Watch 42mm Ser. 3",
                         "Watch3,3":"Watch 38mm Ser. 3", "Watch3,4":"Watch 42mm Ser. 3",
/* Watch series 4 */   "Watch4,1":"Watch 40mm Ser. 4", "Watch4,2":"Watch 44mm Ser. 4",
                         "Watch4,3":"Watch 40mm Ser. 4", "Watch4,4":"Watch 44mm Ser. 4",

/* TV */               "AppleTV2,1":"TV 2",
/* TV */               "AppleTV3,1":"TV 3", "AppleTV3,2":"TV 3",
/* TV */               "AppleTV5,3":"TV 4",
/* TV */               "AppleTV6,2":"TV 4k",
                      
/* AirPods */           "AirPods1,1":"AirPods 1",
                    
/* HomePod 1*/          "AudioAccessory1,1":"HomePod 1",
/* HomePod 2*/          "AudioAccessory1,2":"HomePod 2",

/* Simulator */         "x86_64":"Simulator", "i386":"Simulator"
    ]

    // MARK: - ScreenSizeList
    struct screenInfo { // iOS 8+ compatible devices
// iPod Touch
        static let iPod_Touch_5 = ["Model":"iPod Touch 5","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1536","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPod_Touch_6 = ["Model":"iPod Touch 5","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1536","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
// Watch
        static let Watch1_1     = ["Model":"Watch 38mm","Size":kSCREEN_SIZE.mm_38!,"Resolution":"272,340","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch1_2     = ["Model":"Watch 42mm","Size":kSCREEN_SIZE.mm_42!,"Resolution":"312,390","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch2_3     = ["Model":"Watch 38mm","Size":kSCREEN_SIZE.mm_38!,"Resolution":"272,340","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch2_4     = ["Model":"Watch 42mm","Size":kSCREEN_SIZE.mm_42!,"Resolution":"312,390","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch2_6     = ["Model":"Watch 38mm","Size":kSCREEN_SIZE.mm_38!,"Resolution":"272,340","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch2_7     = ["Model":"Watch 42mm","Size":kSCREEN_SIZE.mm_42!,"Resolution":"312,390","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch3_1     = ["Model":"Watch 38mm","Size":kSCREEN_SIZE.mm_38!,"Resolution":"272,340","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch3_2     = ["Model":"Watch 42mm","Size":kSCREEN_SIZE.mm_42!,"Resolution":"312,390","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch3_3     = ["Model":"Watch 38mm","Size":kSCREEN_SIZE.mm_38!,"Resolution":"272,340","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch3_4     = ["Model":"Watch 42mm","Size":kSCREEN_SIZE.mm_42!,"Resolution":"312,390","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch4_1     = ["Model":"Watch 40mm","Size":kSCREEN_SIZE.mm_40!,"Resolution":"324,394","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch4_2     = ["Model":"Watch 44mm","Size":kSCREEN_SIZE.mm_44!,"Resolution":"368,448","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch4_3     = ["Model":"Watch 40mm","Size":kSCREEN_SIZE.mm_40!,"Resolution":"324,394","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
        static let Watch4_4     = ["Model":"Watch 44mm","Size":kSCREEN_SIZE.mm_44!,"Resolution":"368,448","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio3_5!] as [String : Any]
// iPhone
        static let iPhone_4       = ["Model":"iPhone 4","Size":kSCREEN_SIZE.inch_3_5!,"Resolution":"640,960","Parallax":"0,0","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_4S      = ["Model":"iPhone 4S","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1360","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_5       = ["Model":"iPhone 5","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1536","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_5C      = ["Model":"iPhone 5C","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1536","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_5S      = ["Model":"iPhone 5S","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1536","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_6       = ["Model":"iPhone 6","Size":kSCREEN_SIZE.inch_4_7!,"Resolution":"750,1334","Parallax":"1150,1734","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_6_Plus  = ["Model":"iPhone 6 Plus","Size":kSCREEN_SIZE.inch_5_5!,"Resolution":"1242,2208","Parallax":"1642,2608","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_6S      = ["Model":"iPhone 6S","Size":kSCREEN_SIZE.inch_4_7!,"Resolution":"750,1334","Parallax":"1150,1734","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_6S_Plus = ["Model":"iPhone 6S Plus","Size":kSCREEN_SIZE.inch_5_5!,"Resolution":"1242,2208","Parallax":"1642,2608","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_SE      = ["Model":"iPhone SE","Size":kSCREEN_SIZE.inch_4!,"Resolution":"640,1136","Parallax":"1040,1536","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_7       = ["Model":"iPhone 7","Size":kSCREEN_SIZE.inch_4_7!,"Resolution":"750,1334","Parallax":"1150,1734","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_7_Plus  = ["Model":"iPhone 7 Plus","Size":kSCREEN_SIZE.inch_5_5!,"Resolution":"1242,2208","Parallax":"1642,2608","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_8       = ["Model":"iPhone 8","Size":kSCREEN_SIZE.inch_4_7!,"Resolution":"750,1334","Parallax":"1150,1734","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_8_Plus  = ["Model":"iPhone 8 Plus","Size":kSCREEN_SIZE.inch_5_5!,"Resolution":"1242,2208","Parallax":"1642,2608","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_X       = ["Model":"iPhone X","Size":kSCREEN_SIZE.inch_5_8!,"Resolution":"1125,2436","Parallax":"1579,2890","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_XR      = ["Model":"iPhone XR","Size":kSCREEN_SIZE.inch_6_1!,"Resolution":"828,1792","Parallax":"1579,2890","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_XS      = ["Model":"iPhone XS","Size":kSCREEN_SIZE.inch_5_8!,"Resolution":"1125,2436","Parallax":"1579,2890","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
        static let iPhone_XS_Max  = ["Model":"iPhone XS Max","Size":kSCREEN_SIZE.inch_6_5!,"Resolution":"1242,2688","Parallax":"1579,2890","AspectRatio":kSCREEN_RATIO.ratio16_9!] as [String : Any]
// iPad
        static let iPad_2         = ["Model":"iPad 2","Size":kSCREEN_SIZE.inch_9_7!,"Resolution":"768,1024","Parallax":"1168,1424","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_3         = ["Model":"iPad 3","Size":kSCREEN_SIZE.inch_9_7!,"Resolution":"1536,2048","Parallax":"1936,2448","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_4         = ["Model":"iPad 4","Size":kSCREEN_SIZE.inch_9_7!,"Resolution":"1536,2048","Parallax":"1936,2448","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_Air_1     = ["Model":"iPad Air 1","Size":kSCREEN_SIZE.inch_9_7!,"Resolution":"1536,2048","Parallax":"1936,2448","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_Air_2     = ["Model":"iPad Air 2","Size":kSCREEN_SIZE.inch_9_7!,"Resolution":"1536,2048","Parallax":"2542,2542","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_Pro_9_7   = ["Model":"iPad Pro 9.7\"","Size":kSCREEN_SIZE.inch_9_7!,"Resolution":"1536,2048","Parallax":"2542,2542","AspectRatio":kSCREEN_RATIO.ratio4_3!] as [String : Any]
        static let iPad_Pro_10_5  = ["Model":"iPad Pro 10.5\"","Size":kSCREEN_SIZE.inch_10_5!,"Resolution":"1668,2224","Parallax":"2542,2542","AspectRatio":kSCREEN_RATIO.ratio4_3!] as [String : Any]
        static let iPad_Pro_12_9  = ["Model":"iPad Pro 12.9\"","Size":kSCREEN_SIZE.inch_12_9!,"Resolution":"2048x2732","Parallax":"2542,2542","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
// iPad Mini
        static let iPad_Mini_1  = ["Model":"iPad Mini 1","Size":kSCREEN_SIZE.inch_7_9!,"Resolution":"768,1024","Parallax":"1262,1262","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_Mini_2  = ["Model":"iPad Mini 2","Size":kSCREEN_SIZE.inch_7_9!,"Resolution":"768,1024","Parallax":"1262,1262","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_Mini_3  = ["Model":"iPad Mini 3","Size":kSCREEN_SIZE.inch_7_9!,"Resolution":"1536,2048","Parallax":"1262,1262","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        static let iPad_Mini_4  = ["Model":"iPad Mini 4","Size":kSCREEN_SIZE.inch_7_9!,"Resolution":"1536,2048","Parallax":"1262,1262","AspectRatio":kSCREEN_RATIO.ratio3_4!] as [String : Any]
        
// Arrays of Devices
        static let all_iPads        = [iPad_2,iPad_3,iPad_4,iPad_Air_1,iPad_Air_2,iPad_Pro_9_7,iPad_Pro_10_5,iPad_Pro_12_9]
        static let all_iPadMinis    = [iPad_Mini_1,iPad_Mini_2,iPad_Mini_3,iPad_Mini_4]
        static let all_iPods        = [iPod_Touch_5,iPod_Touch_6]
        static let all_iPhones      = [iPhone_4,iPhone_4S,iPhone_5,iPhone_5C,iPhone_5S,iPhone_6,iPhone_6S,iPhone_SE,
                                       iPhone_7,iPhone_7_Plus,iPhone_8,iPhone_8_Plus,iPhone_X]
        static let all_Watches      = [Watch1_1,Watch1_2,Watch2_3,Watch2_4,Watch2_6,Watch2_7,Watch3_1,Watch3_2,Watch3_3,Watch3_4]
        static let all_Devices      = all_iPads + all_iPadMinis + all_iPods + all_iPhones + all_Watches
    }
}

struct ScreenSize{
    static let SCREEN_WIDTH         = UIScreen.main.nativeBounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.nativeBounds.size.height
    static let SCREEN_MAX_WIDTH     = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_WIDTH     = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType{
    /* iPhone */
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH == 568.0
    static let IS_IPHONE_5S         = IS_IPHONE_5
    static let IS_IPHONE_SE         = IS_IPHONE_5
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH == 667.0
    static let IS_IPHONE_6Plus      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH == 736.0
    static let IS_IPHONE_6S         = IS_IPHONE_6
    static let IS_IPHONE_6SPlus     = IS_IPHONE_6Plus
    static let IS_IPHONE_7          = IS_IPHONE_6
    static let IS_IPHONE_7Plus      = IS_IPHONE_6Plus
    static let IS_IPHONE_8          = IS_IPHONE_6
    static let IS_IPHONE_8Plus      = IS_IPHONE_6Plus
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH == 2436.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH == 1792.0
    static let IS_IPHONE_XS         = IS_IPHONE_X
    static let IS_IPHONE_XSMax      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_WIDTH == 2688.0

    /* iPad */
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_WIDTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_10_5     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_WIDTH == 1112.0
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_WIDTH == 1366.0

    /* TV */
    static let IS_TV                = UIDevice.current.userInterfaceIdiom == .tv

    /* CarPLay */
    static let IS_CAR_PLAY          = UIDevice.current.userInterfaceIdiom == .carPlay
    
    /* Screen 'Notch' */
    static let hasNotch:Bool        = UIDevice.current.hasNotch
}

struct Version{
    static let SYS_VERSION_FLOAT = Float(UIDevice.current.systemVersion)!
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    static let iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0 && Version.SYS_VERSION_FLOAT < 12.0)
    static let iOS12 = (Version.SYS_VERSION_FLOAT >= 12.0 && Version.SYS_VERSION_FLOAT < 13.0)
    static let iOS13 = (Version.SYS_VERSION_FLOAT >= 13.0 && Version.SYS_VERSION_FLOAT < 14.0)
}

func getSimDeviceModel(){
    #if targetEnvironment(simulator)
// TODO: ⚙️(Fix) Need device model from sim to determine notch
        var machineSwiftString : String = ""
        // this neat trick is found at https://kelan.io/2015/easier-getenv-in-swift/
        if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            machineSwiftString = dir
        }
    
        print("machine is \(machineSwiftString)")
    #else
    #endif
}

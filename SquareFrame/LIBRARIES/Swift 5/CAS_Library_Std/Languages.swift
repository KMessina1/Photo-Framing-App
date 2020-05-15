/*--------------------------------------------------------------------------------------------------------------------------
   File: Languages.swift
 Author: Kevin Messina
Created: May 10, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** FUNCTIONS ***
/// Structs for custom colors.
@objc(Languages) class Languages:NSObject {
    var Version: String { return "2.01" }

    /// - returns: [String] Tuple of users preferred language info
    var getCurrentDeviceLanguage:(languageCode:String,regionCode:String,fullRegionCode:String,language:String) {
        var language:String = ""
        var langCode:String = ""
        var regionCode:String = ""

        if let lang = Locale.preferredLanguages.first {
            let langDict = Locale.components(fromIdentifier: lang)
            langCode = langDict["kCFLocaleLanguageCodeKey"] ?? ""
            regionCode = langDict["kCFLocaleScriptCodeKey"] ?? ""

            if langCode == "zh" { langCode = "zh-Hans" }
            
            if returnLanguageNameForCode(langCode).found {
                language = returnLanguageNameForCode(langCode).language
            }
        }
        
        let fullRegionCode = "\(langCode)-\(regionCode)"
        
        return (langCode,regionCode,fullRegionCode,language)
    }

    func saveLanguageInfo() {
        let prefs = UserDefaults.standard
            prefs.set(gAppLanguageCode, forKey:"UserLanguageCode")
            prefs.set(gAppLanguage, forKey:"UserLanguage")
        prefs.synchronize()
        
        simPrint().info("Device Language: \(gAppLanguage) ('\(gAppLanguageCode)')",function:#function,line:#line)
    }

    /// - returns: [String] Tuple of users preferred language info
    func setCurrentDeviceLanguage() {
        var langCode:String = ""

        if let lang = Locale.preferredLanguages.first {
            let langDict = Locale.components(fromIdentifier: lang)
            langCode = langDict["kCFLocaleLanguageCodeKey"] ?? ""
        }
        
        let appLanguages:[String] = appInfo.EDITION.supportedLanguages.components(separatedBy: ",")
        
        if langCode == "zh" { langCode = "zh-Hans" }
        
        for code in appLanguages {
            if code == langCode {
                gAppLanguageCode = code
                gAppLanguage = self.returnLanguageNameForCode(code).language
                self.saveLanguageInfo()
                return
            }
        }

        /* Default to English */
        gAppLanguageCode = "en"
        gAppLanguage = "English"
        simPrint().error("Device Language: \(gAppLanguageCode) ('\(gAppLanguage)') is not supported, changed to English ('en').",function:#function,line:#line)

        self.saveLanguageInfo()
    }
    
    func returnLanguageNameForCode(_ code:String) -> (found:Bool,language:String) {
        if let arrLanguage = Languages().arr.filter({$0.LangCode == code}).first {
            return (found:true,language:arrLanguage.name)
        }

        return (found:false,language:"")
    }
    
    func returnInfoForLanguage(_ name:String) -> (found:Bool,flagImgName:String,langCode:String,isRightToLeft:Bool) {
        if let arrLanguage = Languages().arr.filter({$0.name == name}).first {
            return (found:true,
                    flagImgName:arrLanguage.FlagImgName,
                    langCode:arrLanguage.LangCode,
                    isRightToLeft:arrLanguage.isRightToLeft)
        }
        
        return (found:false,flagImgName:"",langCode:"",isRightToLeft:false)
    }
    
    func returnTextAlignmentForLanguage(_ name:String) -> (found:Bool,isRightToLeft:Bool) {
        if let arrLanguage = Languages().arr.filter({$0.name == name}).first {
            return (true,arrLanguage.isRightToLeft)
        }
        
        return (found:false,isRightToLeft:false)
    }
    
// MARK: - *** LANGUAGE STRUCTS ***
    /// Apple Standard Languages.
    struct langStruct {
        var name:String
        var FlagImgName:String
        var country:String
        var LangCode:String
        var isRightToLeft:Bool
        
        init(name:String,FlagImgName:String,country:String,LangCode:String,isRightToLeft:Bool) {
            self.name = name
            self.FlagImgName = FlagImgName
            self.country = country
            self.LangCode = LangCode
            self.isRightToLeft = isRightToLeft
        }
    }

    struct Languages {
        let arr = [
            langStruct(name:"Albanian",FlagImgName:"Albania",country:"Albania",LangCode:"sq",isRightToLeft:false),
            langStruct(name:"Arabic",FlagImgName:"SaudiArabia",country:"Saudi Arabia",LangCode:"ar",isRightToLeft:true),
            langStruct(name:"Byelorussian (Belarusian)",FlagImgName:"Belarus",country:"Belarus",LangCode:"be",isRightToLeft:false),
            langStruct(name:"Croatian",FlagImgName:"BosniaandHerzegovina",country:"Bosnia and Herzegovina",LangCode:"hr",isRightToLeft:false),
            langStruct(name:"Bulgarian",FlagImgName:"Bulgaria",country:"Bulgaria",LangCode:"bg",isRightToLeft:false),
            langStruct(name:"Chinese (Simplified)",FlagImgName:"China",country:"China",LangCode:"zh-Hans",isRightToLeft:false),
            langStruct(name:"Chinese (Traditional)",FlagImgName:"China",country:"China",LangCode:"zh-Hant",isRightToLeft:false),
            langStruct(name:"Croatian",FlagImgName:"Serbia",country:"Serbia",LangCode:"hr",isRightToLeft:false),
            langStruct(name:"Czech",FlagImgName:"CzechRepublic",country:"Czech Republic",LangCode:"cs",isRightToLeft:false),
            langStruct(name:"Danish",FlagImgName:"Denmark",country:"Denmark",LangCode:"da",isRightToLeft:false),
            langStruct(name:"Dutch",FlagImgName:"Netherlands",country:"Netherlands",LangCode:"nl",isRightToLeft:false),
            langStruct(name:"English",FlagImgName:"UnitedKingdom",country:"United Kingdom",LangCode:"en",isRightToLeft:false),
            langStruct(name:"Estonian",FlagImgName:"Estonia",country:"Estonia",LangCode:"et",isRightToLeft:false),
            langStruct(name:"Farsi",FlagImgName:"Iran",country:"Iran",LangCode:"fa",isRightToLeft:true),
            langStruct(name:"Finnish",FlagImgName:"Finland",country:"Finland",LangCode:"fi",isRightToLeft:false),
            langStruct(name:"Flemish",FlagImgName:"Netherlands",country:"Netherlands",LangCode:"nl",isRightToLeft:false),
            langStruct(name:"French",FlagImgName:"France",country:"France",LangCode:"fr",isRightToLeft:false),
            langStruct(name:"Gaelic (Irish)",FlagImgName:"Ireland",country:"Ireland",LangCode:"gd",isRightToLeft:false),
            langStruct(name:"Georgian",FlagImgName:"Georgia",country:"Georgia",LangCode:"ka",isRightToLeft:false),
            langStruct(name:"German",FlagImgName:"Germany",country:"Germany",LangCode:"de",isRightToLeft:false),
            langStruct(name:"Greek",FlagImgName:"Greece",country:"Greece",LangCode:"el",isRightToLeft:false),
            langStruct(name:"Hebrew",FlagImgName:"Israel",country:"Israel",LangCode:"he",isRightToLeft:true),
            langStruct(name:"Hindi",FlagImgName:"India",country:"India",LangCode:"hi",isRightToLeft:false),
            langStruct(name:"Hungarian",FlagImgName:"Hungary",country:"Hungary",LangCode:"hu",isRightToLeft:false),
            langStruct(name:"Icelandic",FlagImgName:"Iceland",country:"Iceland",LangCode:"is",isRightToLeft:false),
            langStruct(name:"Indonesian",FlagImgName:"Indonesia",country:"Indonesia",LangCode:"in",isRightToLeft:false),
            langStruct(name:"Italian",FlagImgName:"Italy",country:"Italy",LangCode:"it",isRightToLeft:false),
            langStruct(name:"Japanese",FlagImgName:"Japan",country:"Japan",LangCode:"ja",isRightToLeft:false),
            langStruct(name:"Kazakh",FlagImgName:"Kazakhstan",country:"Kazakhstan",LangCode:"kk",isRightToLeft:false),
            langStruct(name:"Korean",FlagImgName:"SouthKorea",country:"South Korea",LangCode:"ko",isRightToLeft:false),
            langStruct(name:"Laothian",FlagImgName:"Laos",country:"Laos",LangCode:"lo",isRightToLeft:false),
            langStruct(name:"Latvian (Lettish)",FlagImgName:"Latvia",country:"Latvia",LangCode:"lv",isRightToLeft:false),
            langStruct(name:"Lithuanian",FlagImgName:"Lithuania",country:"Lithuania",LangCode:"lt",isRightToLeft:false),
            langStruct(name:"Malay",FlagImgName:"Malaysia",country:"Malaysia",LangCode:"ms",isRightToLeft:false),
            langStruct(name:"Moldovian",FlagImgName:"Moldova",country:"Moldova",LangCode:"mo",isRightToLeft:false),
            langStruct(name:"Mongolian",FlagImgName:"Mongolia",country:"Mongolia",LangCode:"mn",isRightToLeft:false),
            langStruct(name:"Nepali (Nepalese)",FlagImgName:"Nepal",country:"Nepal",LangCode:"ne",isRightToLeft:false),
            langStruct(name:"Norwegian",FlagImgName:"Norway",country:"Norway",LangCode:"no",isRightToLeft:false),
            langStruct(name:"Polish",FlagImgName:"Poland",country:"Poland",LangCode:"pl",isRightToLeft:false),
            langStruct(name:"Portuguese",FlagImgName:"Portugal",country:"Portugal",LangCode:"pt",isRightToLeft:false),
            langStruct(name:"Romanian",FlagImgName:"Romania",country:"Romania",LangCode:"ro",isRightToLeft:false),
            langStruct(name:"Russian",FlagImgName:"Russia",country:"Russia",LangCode:"ru",isRightToLeft:false),
            langStruct(name:"Serbian",FlagImgName:"Serbia",country:"Serbia",LangCode:"sr",isRightToLeft:false),
            langStruct(name:"Spanish",FlagImgName:"Spain",country:"Spain",LangCode:"es",isRightToLeft:false),
            langStruct(name:"Swedish",FlagImgName:"Sweden",country:"Sweden",LangCode:"sv",isRightToLeft:false),
            langStruct(name:"Tagalog",FlagImgName:"Philippines",country:"Philippines",LangCode:"tl",isRightToLeft:false),
            langStruct(name:"Thai",FlagImgName:"Thailand",country:"Thailand",LangCode:"th",isRightToLeft:false),
            langStruct(name:"Turkish",FlagImgName:"Turkey",country:"Turkey",LangCode:"tr",isRightToLeft:false),
            langStruct(name:"Ukrainian",FlagImgName:"Ukraine",country:"Ukraine",LangCode:"uk",isRightToLeft:false),
            langStruct(name:"Urdu",FlagImgName:"Pakistan",country:"Pakistan",LangCode:"ur",isRightToLeft:true),
            langStruct(name:"Vietnamese",FlagImgName:"Vietnam",country:"Vietnam",LangCode:"vi",isRightToLeft:false)
        ]
    }
}

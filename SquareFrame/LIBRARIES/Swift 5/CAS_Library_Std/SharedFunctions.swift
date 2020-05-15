/*--------------------------------------------------------------------------------------------------------------------------
   File: SharedFunctions.swift
 Author: Kevin Messina
Created: April 18, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/

import StoreKit
import MessageUI
import AVFoundation

// MARK: - *** GLOBAL FUNCTIONS ***
func buildSimPrintText(icons:String,msg:String,errorMsg:String? = "",file:String? = "",function:String? = "",line:Int? = -1) {
    if isSimDevice.isFalse {
        return
    }else{
        var txt = "\( icons ) "
        if file!.isNotEmpty { txt.append("Ⓕ\( file!.lastPathComponent ) ") }
        if function!.isNotEmpty { txt.append("Ⓜ︎\( function! )") }
        if (line! >= 0) { txt.append("Ⓛ#:\( line! ) ") }
        txt.append(msg)
        if errorMsg!.isNotEmpty { txt.append("\n|------->Ⓔ: \( errorMsg! )") }

        print(txt)
    }
}

public struct simPrint {
    func info(_ msg:String,file:String? = "",function:String? = "",line:Int? = -1) {
        buildSimPrintText(icons:"ℹ️",msg:msg,file:file!,function:function!,line:line!)
    }
    
    func success(_ msg:String,file:String? = "",function:String? = "",line:Int? = -1) {
        buildSimPrintText(icons:"ℹ️✅",msg:msg,file:file!,function:function!,line:line!)
    }
    
    func warning(_ msg:String,file:String? = "",function:String? = "",line:Int? = -1) {
        buildSimPrintText(icons:"ℹ️⚠️",msg:msg,file:file!,function:function!,line:line!)
    }

    func error(_ msg:String,errorMsg:String? = "",file:String? = "",function:String? = "",line:Int? = -1) {
        buildSimPrintText(icons:"ℹ️‼️",msg:msg,errorMsg:errorMsg!,file:file!,function:function!,line:line!)
    }
}

public func dumpClassToConsole(_ structure:AnyObject) {
    let mirror = Mirror(reflecting: structure)

    print("\n")
    print("=".repeatNumTimes(70))
    print("📝 Class: \(String(describing: mirror))")
    print("-".repeatNumTimes(70))
    for (name, value) in mirror.children {
        guard let name = name else { continue }
        print("  ✏️ \(name):\(type(of: value)) = '\(value)'")
    }
    print("=".repeatNumTimes(70))
    print("\n")
}

func returnCodeForCountry(country:String) -> String {
    var CountryCode = country
    
    CountryCode = CountryCode.uppercased().replacingOccurrences(of: ".", with: "")
    
    if CountryCode == "USA" || CountryCode == "US" || CountryCode == "UNITED STATES" {
        CountryCode = "US"
    }else if CountryCode == "CAN" || CountryCode == "CA" || CountryCode == "CANADA" {
        CountryCode = "CA"
    }

    let Juris = Jurisdictions().returnInfo(jusridiction: CountryCode)
    CountryCode = Juris.found.isFalse ?"" :Juris.code
    
    return CountryCode
}

func returnCodeForState(state:String) -> String {
    var stateCode = state

    stateCode = stateCode.uppercased().replacingOccurrences(of: ".", with: "")
    
    if stateCode.count > 2 {
        let Juris = Jurisdictions().returnInfo(jusridiction: stateCode)
        stateCode = Juris.found.isFalse ?"" :Juris.code
    }
    
    return stateCode
}


/// CAS Shared Functions library framework
///
/// ©2013-2019 Creative App Solutions, LLC. - All Rights Reserved.
@objc(sharedFunc) class sharedFunc:NSObject {
// MARK: - *** DEFINITIONS ***
    var Version: String { return "2.07" }
   
// MARK: - *** GENERAL FUNCTIONS ***
    struct actSheet {
        func getUserInput(vc:UIViewController,textTitle1:String,text1:String,textTitle2:String,text2:String,completion: @escaping (Bool,String,String) -> Void) {
            let alert = UIAlertController(
                title: "INPUT INFORMATION",
                message: "Enter ID(s)",
                preferredStyle: .alert
            )
            
            alert.addTextField { (textField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .numbersAndPunctuation
                textField.autocorrectionType = .no
                textField.clearButtonMode = .whileEditing
                textField.delegate = (vc as! UITextFieldDelegate)
                textField.placeholder = textTitle1
                textField.text = text1
            }
            
            if textTitle2.isNotEmpty {
                alert.addTextField { (textField:UITextField!) -> Void in
                    textField.keyboardAppearance = .dark
                    textField.keyboardType = .numbersAndPunctuation
                    textField.autocorrectionType = .no
                    textField.clearButtonMode = .whileEditing
                    textField.delegate = (vc as! UITextFieldDelegate)
                    textField.placeholder = textTitle2
                    textField.text = text2
                }
            }
            
            let okAction = UIAlertAction(title: "Continue".localizedCAS(), style: .default) { (action) -> Void in
                completion(
                    true,
                    alert.textFields?[0].text ?? "",
                    textTitle2.isNotEmpty ?alert.textFields?[1].text ?? "" :""
                )
            }
            
            let dismissAction = UIAlertAction(title: "Cancel".localizedCAS(), style: .destructive) { (action) -> Void in
                completion(false, "", "")
            }
            
            alert.addAction(okAction)
            alert.addAction(dismissAction)
            
            /* Appearance */
            alert.view.tintColor = gAppColor
            sharedFunc.DRAW().roundCorner(view: alert.view, radius: 16, color: gAppColor, width: 2.25)
            
            vc.present(alert, animated: true)
        }
        
        func setup(vc:UIViewController,barButton:UIBarButtonItem? = nil,buttonRect:CGRect? = nil, title:String? = nil,message:String? = nil) -> UIAlertController {
            let actSheet:UIAlertController = UIAlertController(title:title,message:message,preferredStyle: .actionSheet)
                actSheet.modalTransitionStyle = .coverVertical
                actSheet.view.tintColor = isPhone ?gAppColor :.snow
                actSheet.view.tag = (barButton != nil) ?barButton?.tag ?? 0 :vc.view.tag
                actSheet.view.backgroundColor = isPhone ?.snow :.tungsten

            if isPhone {
                actSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler:nil))
            }else if isPad {
                actSheet.popoverPresentationController?.delegate = (vc as! UIPopoverPresentationControllerDelegate)
                actSheet.popoverPresentationController?.permittedArrowDirections = .any

                if (barButton != nil) {
                    actSheet.popoverPresentationController?.barButtonItem = barButton
                    actSheet.title = nil
                }else {
                    actSheet.popoverPresentationController?.sourceView = vc.view

                    if (buttonRect != nil) {
                        actSheet.popoverPresentationController?.sourceRect = buttonRect!
                    }else{
                        actSheet.popoverPresentationController?.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
                        actSheet.popoverPresentationController?.permittedArrowDirections = []
                    }
                }
            }

            actSheet.setTint(color: gAppColor)
            sharedFunc.DRAW().roundCorner(view: actSheet.view, radius: 16, color: .snow, width: 3.0)

            return actSheet
        }
    }
    
    struct ALERT {
        func show(title:String,style:CASAlertViewType,btnText:String? = "OK".localizedCAS(),msg:String,blurEffectStlye:UIBlurEffect.Style?=UIBlurEffect.Style.dark,img:UIImage?=nil,forceStyling:Bool? = false,delay:Double? = -1.0) {
            var showAsAppleStandardDialog:Bool = false
            if alert_ShowAsAppleStandard { showAsAppleStandardDialog = alert_ShowAsAppleStandard }

            if (showAsAppleStandardDialog && (forceStyling == false)) {
                sharedFunc.ALERT().showMsg(title: title,msg: msg)
                return
            }

            waitHUD().hideNow()
            // Confirm and Edit not used here as they handle multiple buttons or text fields requiring callbacks.
            // Use callback version instead which returns an alert object to be modified locally in calling method.
            
            if let alertType = CASAlertViewType(rawValue: style.rawValue) {
                var color:UIColor = #colorLiteral(red: 1, green: 0.5843122602, blue: 0.00580324512, alpha: 1)
                var image:UIImage = UIImage()

                let alert = CASAlertView()
                    alert.appearance.blurEffect = blurEffectStlye!
                
                switch alertType {
                    case .serverError,.error: ()
                        color = #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_Error") :img!
                    case .iap:
                        color = #colorLiteral(red: 1, green: 0.4929101467, blue: 0.4729757905, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_IAP") :img!
                    case .info:
                        color = #colorLiteral(red: 0, green: 0.4812201262, blue: 0.9983773828, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_Info") :img!
                    case .notAvail:
                        color = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_NotAvailable") :img!
                    case .notice: ()
                        color = #colorLiteral(red: 0.250980407, green: 0.4470588565, blue: 0.9882353544, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_Notice") :img!
                    case .success: ()
                        color = #colorLiteral(red: 0.2994727492, green: 0.8526373506, blue: 0.3907377124, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_Success") :img!
                    case .wait: ()
                        color = #colorLiteral(red: 0.1024172083, green: 0.6504989266, blue: 0.5533954501, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_Wait") :img!
                    case .warning: ()
                        color = #colorLiteral(red: 1, green: 0.8015477657, blue: 0.004549824167, alpha: 1)
                        image = (img == nil) ?#imageLiteral(resourceName: "CAS_Warning") :img!
                    default: return
                }
                
                image = image.recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
                
                if (delay! > 0.0) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay!) {
                        alert.showCustom(
                            title: title,
                            subTitle: msg,
                            color: color,
                            icon: image,
                            closeButtonTitle: btnText
                        )
                    }
                }else{
                    DispatchQueue.main.async {
                        alert.showCustom(
                            title: title,
                            subTitle: msg,
                            color: color,
                            icon: image,
                            closeButtonTitle: btnText
                        )
                    }
                }
            }
        }

        func showAppStoreAppNotFound() {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(title: "AppStore_TITLE".localizedCAS(),
                                               subTitle: "APPSTORE_Error_AppNotFound".localizedCAS(),
                                                  color: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),
                                                   icon: #imageLiteral(resourceName: "CAS_AppStore").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                                       closeButtonTitle: "OK".localizedCAS())
            }
        }
        
        func showAppStoreNotAvail() {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(title: "AppStore_TITLE".localizedCAS(),
                                               subTitle: "APPSTORE_Error".localizedCAS(),
                                                  color: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),
                                                   icon: #imageLiteral(resourceName: "CAS_AppStore").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                                       closeButtonTitle: "OK".localizedCAS())
            }
        }
        
        func showNoEmailMsg() {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(title: "EMAIL_NoAccess_Title".localizedCAS(),
                                               subTitle: "EMAIL_NoAccess_Msg".localizedCAS(),
                                                  color: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),
                                                   icon: #imageLiteral(resourceName: "CAS_Email").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                                       closeButtonTitle: "OK".localizedCAS())
            }
        }

        func showNoInternet() {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(title: "INTERNET_NotConnected_Title".localizedCAS(),
                                               subTitle: "INTERNET_NotConnected_Msg".localizedCAS(),
                                                  color: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),
                                                   icon: #imageLiteral(resourceName: "CAS_Internet").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                                       closeButtonTitle: "OK".localizedCAS())
            }
        }
        
        func showFileNotFound(filename:String = "") {
            let fileName = filename.lowercased()
            let filenameSuffix:String = String(fileName.suffix(3))
            
            if filenameSuffix.isNotEmpty {
                let fileType:fileTypes.fileTypesStruct = fileTypes().arr.filter{$0.suffix == filenameSuffix}.first ?? fileTypes.fileTypesStruct()
                let iconImgName:String = fileType.imageName.isNotEmpty ?fileType.imageName :"doc_blank"

                let msg = filename.isNotEmpty
                    ?"'\( filename )'\( "PDF_NotFound_MsgWithFilename".localizedCAS() )"
                    :"PDF_NotFound_Msg".localizedCAS()
                
                sharedFunc.THREAD().doNow {
                    let _ = CASAlertView().showCustom(
                        title: "PDF_NotFound_Title".localizedCAS(),
                        subTitle: msg,
                        color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
                        icon: UIImage(named:iconImgName)!.recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                        closeButtonTitle: "OK".localizedCAS()
                    )
                }
            }
        }

        func showNotAvailableMsg() {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(title: "FEATURE_NotImplemented_Title".localizedCAS(),
                                               subTitle: "FEATURE_NotImplemented_Msg".localizedCAS(),
                                                  color: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),
                                                   icon: #imageLiteral(resourceName: "CAS_NotAvailable").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                                       closeButtonTitle: "OK".localizedCAS())
            }
        }

        func showSimulatorMsg() {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(title: "SIM_FeatureNotAvail_Title".localizedCAS(),
                                               subTitle: "SIM_FeatureNotAvail_Msg".localizedCAS(),
                                                  color: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),
                                                   icon: #imageLiteral(resourceName: "CAS_Simulator").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
                                       closeButtonTitle: "OK".localizedCAS())
            }
        }

        func showCustom(title:String,msg:String,color:UIColor,icon:UIImage,btnTitle:String) {
            sharedFunc.THREAD().doNow {
                let _ = CASAlertView().showCustom(
                    title: title,
                    subTitle: msg,
                    color: color,
                    icon: icon,
                    closeButtonTitle: btnTitle
                )
            }
        }
        

        func showUnderConstructionMsg() {
            let alert = CASAlertView()
                alert.appearance.blurEffect = .dark
                alert.appearance.showCloseButton = true
            
            let timeoutAction:CASAlertView.SCLTimeoutConfiguration.ActionType = { CASAlertView().hideView() }
            let timeout = CASAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction)
            
            sharedFunc.THREAD().doNow {
                alert.showCustom(
                    title: "UNDER CONSTRUCTION",
                    subTitle: "This feature may not be stable or complete. This message will autohide or tap dismiss.",
                    color: #colorLiteral(red: 1, green: 0.5843122602, blue: 0.00580324512, alpha: 1),
                    icon: #imageLiteral(resourceName: "CAS_Construction").recolor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                    closeButtonTitle: "Dismiss",
                    timeout: timeout,
                    colorTextButton: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).convertToUInt()
                )
            }
        }

        func showMsg(vc:UIViewController? = nil,title:String,msg:String,btnText:String? = "OK".localizedCAS()) {
            waitHUD().hideNow()

            let alertController = UIAlertController(title: title,message: msg,preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: btnText!, style: .default) { (action) -> Void in })
                alertController.view.tintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)

            sharedFunc.DRAW().roundCorner(view: alertController.view, radius: 16, color: gAppColor, width: 2.25)

            if vc == nil {
                if let topVC:UIViewController = sharedFunc.APP().getCurrentViewController {
                    sharedFunc.THREAD().doNow {
                        topVC.present(alertController, animated: true)
                    }
                }
            }else{
                sharedFunc.THREAD().doNow {
                    vc?.present(alertController, animated: true)
                }
            }
        }
    }
    
    
// MARK: -
    /// Functions for returning APP definitions and/or values.
    struct ANIMATE {
        /// - returns: (String) App Display Name String
        func fade(view:UIView, duration:TimeInterval, show:Bool, delay:TimeInterval?=nil, endOpacity:CGFloat?=nil, options:UIView.AnimationOptions?=nil) -> Void {
            var endingOpacity = endOpacity
            var startDelay = delay
            var animationOptions = options
            
            if endingOpacity == nil {
                endingOpacity = show.isTrue ?kAlpha.opaque :kAlpha.transparent
            }

            if startDelay == nil {
                startDelay = 0.0
            }

            if animationOptions == nil {
                animationOptions = UIView.AnimationOptions.curveLinear
            }

            UIView.animate(withDuration: duration, delay:delay!, options:options!, animations: {
                view.alpha = endOpacity!
            }, completion: { (finished: Bool) -> Void in
            })
        }
    }
    
// MARK: -
    /// Functions for returning APP definitions and/or values.
    struct APP {
        /// Open another app. Pass app name, - in place of spaces and ending in : and any other params wanted
        /// Example: "print-to-size:" or "SF-Admin"
        func switchToAnotherApp(appID:String) {
            guard let appURL = URL(string: appID)
            else{
                return
            }
            
            UIApplication.shared.open(appURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                if isSim { print("Open url '\(appURL)': \(success)") }
            })
        }
        
        /// - returns: current UIViewController
        var getCurrentViewController:UIViewController? {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.topMostViewController()
        }

        /// - returns: (shared AppDelegate)
        var getAppDelegate:AppDelegate {
            return UIApplication.shared.delegate as! AppDelegate
        }
        
        /// - returns: (String) Distribution Mode
        var distributionMode:String {
            return sharedFunc.APP().isAdhocMode().isTrue ?"Ad-Hoc" :"AppStore"
        }

        /// Check if newer version available on iTunes and if so, then ask user to update.
        func DoesAppNeedUpdating() -> Bool {
            var bAppNeedsUpdating:Bool! = false

            let currentAppVersion:String! = Bundle.main.ver
            let currentAppVer:Float! = Float.init(Bundle.main.ver)

            let savedAppVersion:String! = UserDefaults.standard.string(forKey: "App_Version") ?? "0"
            let savedAppVer:Float! = Float.init(savedAppVersion)
            
            if currentAppVer > savedAppVer { // This is an updated version
                UserDefaults.standard.set(currentAppVersion, forKey: "App_Version")
                UserDefaults.standard.synchronize()
                bAppNeedsUpdating = true
            }
            
            return bAppNeedsUpdating
        }
        
        /// - returns: (String) Rutime Mode
        var runtimeMode:String {
            return sharedFunc.APP().isAdhocMode().isTrue ?"R&D" :"Production"
        }

// MARK: ├─➤ 'SHOW INFO' Functions
        func showSplash(delayForTest:Bool,delaySeconds:UInt32? = 3) {
            if isSimDevice {
                if delayForTest { sleep(10) }
                return
            }
            
            sleep(delaySeconds!)
        }
        
        /// - returns: (String) of the Simulator App Information in Xcode Console.
        func showInfo() -> Void {
            let libPath = sharedFunc.FILES().dirLibrary()
            let appName:String = appInfo.EDITION.fullName
            let version:String = Bundle.main.fullVer
            let revision:String = appInfo.EDITION.revision
            let company:String = appInfo.COMPANY.name
            let libraries:[[String:String]] = Constants().getLibraryVersions()
            let AdHoc = isAdhocMode() ?"Yes" :"No"
            let repeats = 100
            
            if isSimDevice {
                print("\("=".repeatNumTimes(repeats))")
                /* App Info */
                print("  App Name: \(appName)")
                print("   Version: \(version)\(revision)")
                print("   Company: \(company)")
                print("AdHoc Mode: \(AdHoc)")
                print("\("-".repeatNumTimes(repeats))")
                /* Custom Libraries Info */
                print("Frameworks:")
                var counter:Int = 0
                for item:[String:String] in libraries {
                    counter += 1
                    let spacer:String = (counter < 10) ?" " : ""
                    print("\t\(spacer)\(counter)) v\(item["Version"]!) - \(item["Name"]!)")
                }
                print("\("-".repeatNumTimes(repeats))")
                /* UsertDefaults Directory Info */
                print("UserDefaults:\n\(libPath)/Preferences")
                /* Sandbox Directory Info */
                print("\nSandbox:\n\(sharedFunc.FILES().dirDocuments())")
                print("\("=".repeatNumTimes(repeats))\n\n")
            }
        }

// MARK: ├─➤ 'ENVIRONMENT' Functions
        /// - returns: (Bool) Is app TARGET_XX a match to Edition?
        func boolForEnvironmentString(key:String) -> Bool {
            guard let valueString = getenv(key) else { return false }
            guard let valueUTF8 = String(utf8String: valueString) else { return false }
            guard let valueBool = Bool(valueUTF8) else { return false }
            
            return valueBool
        }
        
// MARK: ├─➤ 'TARGET' Functions
        /// - returns: (Bool) Is app in Adhoc Distribution mode - Set Environment String in Project Target Scheme ?
        func isAdhocMode() -> Bool {
            #if ADHOC
                return true
            #else
                return false
            #endif
        }

// MARK: ├─➤ 'ABOUT SCREEN' Functions
        /// - returns: (Array of [String]) ABOUT Database Names
        var about_databaseInfo:[[String]] {
            var arrInfo:[[String]] = []

            #if canImport(oldSQL)
                for item in appInfo.DB.arrayOf {
                    arrInfo.append([item[0]!,oldSQL.SQL().DB_Version(DBPath:item[1]!).verString!])
                }
            #endif
            
            return arrInfo
        }

        /// - returns: struct for ABOUT Info Versions Names
        struct about_appInfo:Loopable {
            var version:String!
            var edition:String!
            var runMode:String!
            var distMode:String!
            var network:String!
            var target:String!
            var titles:[String]!
            var values:[String]!

            init() {
                self.version = Bundle.main.fullVer
                self.edition = appInfo.EDITION.appEdition
                self.runMode = sharedFunc.APP().runtimeMode
                self.distMode = sharedFunc.APP().distributionMode
                self.network = sharedFunc.NETWORK().connection()
                self.target = appInfo.EDITION.appID
                self.titles = ["Version","Edition","Runtime","Distribution","Network"]
                self.values = [self.version,self.edition,self.runMode,self.distMode,self.network]
            }
        }

        /// - returns: struct for ABOUT Section Names
        var about_sectionNames:[String] {
            var arrInfo:[String] = []
                arrInfo.append("About_Section_Application".localizedCAS())
                arrInfo.append("About_Section_Device".localizedCAS())
                arrInfo.append("About_Section_Databases".localizedCAS())
                arrInfo.append("About_Section_Libraries".localizedCAS())
                arrInfo.append("About_Section_ExtLibraries".localizedCAS())
        
            return arrInfo
        }

        /// - returns: (Array of [String]) ABOUT Device Information
        var about_deviceInfo:[[String]] {
            var arrInfo:[[String]] = []
                arrInfo.append(["Model Name",UIDevice.current.modelName])
                arrInfo.append(["OS Version",UIDevice.current.OSVersionString])
                arrInfo.append(["Storage (Total)",UIDevice.current.diskTotalSpace])
                arrInfo.append(["Storage (Used)",UIDevice.current.diskUsedSpace])
                arrInfo.append(["Storage (Free)",UIDevice.current.diskFreeSpace])
                arrInfo.append(["Memory (Total)",UIDevice.current.memoryTotal])
                arrInfo.append(["Memory (Used)",UIDevice.current.memoryUsed])
                arrInfo.append(["Memory (Free)",UIDevice.current.memoryFree])
            
            return arrInfo
        }
        
        /// - returns: Bool of storekit active
        var about_AppStore:[[String]] {
            let useAppStore:Bool! = (sharedFunc.NETWORK().available().isTrue &&
                                     sharedFunc.APP().isAdhocMode().isFalse &&
                                     SKPaymentQueue.canMakePayments().isTrue)
            let appstore:String! = useAppStore.isTrue ?"✅" :"❌"
            let payments:String! = SKPaymentQueue.canMakePayments().isTrue ?"✅" :"❌"

            var arrInfo:[[String]] = []
                arrInfo.append(["AppStore","\(appstore ?? "n/a")"])
                arrInfo.append(["In-App Purchases","\(payments ?? "n/a")"])
            
            return arrInfo
        }
    
// MARK: ├─➤  iTunes AppStore & Version Checking
        func IsNewOrUpdatedVersion() -> Bool {
            let isFirstLaunch:AnyObject! = UserDefaults.standard.object(forKey: "App_FirstLaunch") as AnyObject?
            let bIsFirstLaunch:Bool! = (isFirstLaunch == nil)

            /* Is App Version Outdated */
            let bAppNeedsUpdating:Bool! = DoesAppNeedUpdating()
        
            if bIsFirstLaunch || bAppNeedsUpdating {
                return true
            }

            return false
        }
        
        /// Check if newer version available on iTunes and if so, then ask user to update.
        func showWhatsNew(forceShow:Bool) {
            let prefs = UserDefaults.standard

            var bIsNewOrUpdated:Bool! = false
            let isFirstLaunch:AnyObject! = prefs.object(forKey: "App_FirstLaunch") as AnyObject?
            let bIsFirstLaunch:Bool! = (isFirstLaunch == nil)
            
            /* Is App Version Outdated */
            let bAppNeedsUpdating:Bool! = DoesAppNeedUpdating()
            
            if bIsFirstLaunch.isTrue {
                prefs.set(false, forKey:"App_FirstLaunch")
                prefs.set(true, forKey:"WHATSNEW_FirstLaunch")
                bIsNewOrUpdated = true
            }else if bAppNeedsUpdating.isTrue {
                prefs.set(false, forKey:"App_FirstLaunch")
                prefs.set(false, forKey:"WHATSNEW_FirstLaunch")
                bIsNewOrUpdated = true
            }
            
            prefs.synchronize()
            
            if bIsNewOrUpdated || forceShow {
                sharedFunc.THREAD().doAfterDelay(delay: 0.2, perform: {
                    let storyboard = UIStoryboard(name:"WhatsNew", bundle:nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "VC_WhatIsNew") as! VC_WhatIsNew
                        vc.gradientColor_Start = gAppColor
                        vc.gradientColor_End = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        vc.color_Title = gAppColor
                        vc.color_Text = gAppColor
                        vc.font_Title = UIFont(name: (APPFONTS().text_Light?.fontName)!, size: 36)
                        vc.font_CellTitle = UIFont(name: (APPFONTS().text_Reg?.fontName)!, size: 18)
                        vc.font_CellText = UIFont(name: (APPFONTS().text_Light?.fontName)!, size: 16)
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.topMostViewController()
                        .present(vc, animated: true)
                })
            }
        }
    }

// MARK: -
    /// Functions that return Attributed string formatting.
    struct ATTRIBS {
        func setO2asSubscript(lbl:UILabel, reduceBy:CGFloat?=1.5, offset:CGFloat?=nil) {
            var fontOffset = offset
            
            let title = lbl.text ?? ""
            let fontSize = lbl.font.pointSize
            let font = UIFont(name: lbl.font.fontName, size: fontSize / reduceBy!)
            if fontOffset == nil {
                fontOffset = -CGFloat(fontSize / 5)
            }
            
            let attrStr = NSMutableAttributedString(string: title)
            let inputLength = attrStr.string.count
            let searchString = "O2"
            let searchLength = searchString.count - 1
            var range = NSRange(location: 0, length: attrStr.length)
            
            while (range.location != NSNotFound) {
                range = (attrStr.string as NSString).range(of: searchString, options: [], range: range)
                if (range.location != NSNotFound) {
                    attrStr.addAttribute(NSAttributedString.Key.font, value:font!, range: NSRange(location: range.location + 1, length: searchLength))
                    attrStr.addAttribute(NSAttributedString.Key.baselineOffset, value:offset!, range: NSRange(location: range.location  + 1, length: searchLength))
                    range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                }
            }

            lbl.attributedText = NSAttributedString(attributedString: attrStr)
        }
        
        func setAsSubscript(lbl:UILabel, subscriptText:String, offset:CGFloat?=nil) {
            var fontOffset = offset

            let title = lbl.text ?? ""
            let fontSize = lbl.font.pointSize
            let font = UIFont(name: lbl.font.fontName, size: fontSize / 1.5)
            if fontOffset == nil {
                fontOffset = -CGFloat(fontSize / 5)
            }

            let attrStr = NSMutableAttributedString(string: title)
            let inputLength = attrStr.string.count
            let searchString = subscriptText
            let searchLength = searchString.count
            var range = NSRange(location: 0, length: attrStr.length)
            
            while (range.location != NSNotFound) {
                range = (attrStr.string as NSString).range(of: searchString, options: [], range: range)
                if (range.location != NSNotFound) {
                    attrStr.addAttribute(NSAttributedString.Key.font, value:font!, range: NSRange(location: range.location, length: searchLength))
                    attrStr.addAttribute(NSAttributedString.Key.baselineOffset, value:offset!, range: NSRange(location: range.location, length: searchLength))
                    range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                }
            }

            lbl.attributedText = NSAttributedString(attributedString: attrStr)
        }
    }
    
    
// MARK: -
    /// Functions that return VIBRATION from iPhone device
    struct AUDIO {
        func vibratePhone() {
            if isPhone.isTrue { AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) }
        }

        func playSystemSoundID(id:SystemSoundID) {
            if isPhone.isTrue { AudioServicesPlaySystemSound(id) }
        }
    }
    
    
// MARK: -
    /// Functions that return UserDefaults with parameter checking applied.
    struct DEFAULTS {
        /// Saves UserDefault object of ANY type with value.
        ///
        /// - parameter key: (String) Key name to store.
        /// - parameter value: (Any) Value to store.
        func updateSetting(key:String,value:Any) {
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        /// returns UserDefault object of Int type with optional parameter value checking applied.
        ///
        /// - parameter key: (String) Key name
        /// - parameter minValue: [ Optional ] (Float) Minimum Value.
        /// - parameter maxValue: [ Optional ] (Float) Maximum value.
        /// - returns: (Float) with optional parameter value checking applied.
        func getDouble(key:String,minValue:Double?=nil,maxValue:Double?=nil) -> Double {
            var temp:Double! = UserDefaults.standard.double(forKey: key)

            if (minValue != nil) {
                if (temp < minValue!) {
                    temp = minValue
                }
            }
            
            if (maxValue != nil) {
                if (temp > maxValue!) {
                    temp = maxValue
                }
            }
            
            return temp
        }

        /// returns UserDefault object of Int type with optional parameter value checking applied.
        ///
        /// - parameter key: (String) Key name
        /// - parameter minValue: [ Optional ] (Float) Minimum Value.
        /// - parameter maxValue: [ Optional ] (Float) Maximum value.
        /// - returns: (Float) with optional parameter value checking applied.
        func getFloat(key:String,minValue:Float?=nil,maxValue:Float?=nil) -> Float {
            var temp:Float! = UserDefaults.standard.float(forKey: key)

            if (minValue != nil) {
                if (temp < minValue!) {
                    temp = minValue
                }
            }
            
            if (maxValue != nil) {
                if (temp > maxValue!) {
                    temp = maxValue
                }
            }
            
            return temp
        }

        /// returns UserDefault object of Int type with optional parameter value checking applied.
        ///
        /// - parameter key: (String) Key name
        /// - parameter minValue: [ Optional ] (Int) Minimum Value.
        /// - parameter maxValue: [ Optional ] (Int) Maximum value.
        /// - returns: (Int) with optional parameter value checking applied.
        func getInt(key:String,minValue:Int?=nil,maxValue:Int?=nil) -> Int {
            var temp:Int! = UserDefaults.standard.integer(forKey: key)

            if (minValue != nil) {
                if (temp < minValue!) {
                    temp = minValue
                }
            }
            
            if (maxValue != nil) {
                if (temp > maxValue!) {
                    temp = maxValue
                }
            }
            
            return temp
        }

        /// returns UserDefault object of String type with optional parameter value checking applied.
        ///
        /// - parameter key: (String) Key name
        /// - parameter defaultValue: [ Optional ] (String) Deafult Value.
        /// - returns: (String) with optional parameter value checking applied.
        func getString(key:String,defaultValue:String?=nil) -> String {
            var temp:String! = UserDefaults.standard.string(forKey: key) ?? ""

            if (defaultValue != nil) {
                if (temp == nil) || (temp.count <= 0) {
                    temp = defaultValue
                }
            }
            
            return temp
        }

        /// returns UserDefault object of Bool type with optional parameter value checking applied.
        ///
        /// - parameter key: (String) Key name
        /// - parameter defaultValue: [ Optional ] (String) Deafult Value.
        /// - returns: (String) with optional parameter value checking applied.
        func getBool(key:String,defaultValue:Bool?=nil) -> Bool {
            var temp:Bool! = UserDefaults.standard.bool(forKey: key)

            if (defaultValue != nil) {
                if (temp == nil) {
                    temp = defaultValue
                }
            }
            
            return temp
        }

        /// returns UserDefault object of NSData type
        ///
        /// - parameter key: (String) Key name
        /// - returns: (NSData)
        func getData(key:String) -> Data {
            let temp:Data! = UserDefaults.standard.object(forKey: key) as? NSData as Data?

            return temp
        }

        /// returns UserDefault object of any type
        ///
        /// - parameter key: (String) Key name
        /// - returns: (NSObject:AnyObject)
        func getObject(key:String) -> NSObject {
            let temp:[AnyHashable: Any]! = UserDefaults.standard.object(forKey: key) as? [AnyHashable: Any]

            return temp as NSObject
        }

        /// returns UserDefault object of NSDate type
        ///
        /// - parameter key: (String) Key name
        /// - returns: (NSDate)
        func getDate(key:String) -> Date {
            let temp:Date! = UserDefaults.standard.object(forKey: key) as? Date? ?? Date()

            return temp
        }
        
        func ifDefaultIsNilCreate(key:String, value:Any) {
            let prefs = UserDefaults.standard

            if prefs.object(forKey: key) == nil {
                prefs.set(value, forKey: key)
            }
            
            prefs.synchronize()
        }

        func ifColorDefaultIsNilCreate(key:String, value:UIColor) {
            let prefs = UserDefaults.standard

            if prefs.object(forKey: key) == nil {
                prefs.setColor(value: value, forKey: key)
            }
            
            prefs.synchronize()
        }
    }

// MARK: -
    /// Functions for DATES.
    struct DATES {
        /// returns Month Number from month as string
        ///
        /// - parameter monthName: (String) Name of month or abbrev of month
        /// - returns: (Int) of month 0 = Not Found
        func returnNumOfMonth(monthName:String) -> Int {
            var month = monthName
            
            month = monthName.uppercased()
            
            if (month as NSString).length > 3 {
                month = (month as NSString).substring(from: 3)
            }
            
            switch month {
                case "JAN","JAN.","JANUARY": return kMonths.Jan
                case "FEB","FEB.","FEBRUARY": return kMonths.Feb
                case "MAR","MAR.","MARCH": return kMonths.Mar
                case "APR","APR.","APRIL": return kMonths.Apr
                case "MAY","MAY.": return kMonths.May
                case "JUN","JUN.","JUNE": return kMonths.Jun
                case "JUL","JUL.","JULY": return kMonths.Jul
                case "AUG","AUG.","AUGUST": return kMonths.Aug
                case "SEP","SEP.","SEPTEMBER": return kMonths.Sep
                case "OCT","OCT.","OCTOBER": return kMonths.Oct
                case "NOV","NOV.","NOVEMBER": return kMonths.Nov
                case "DEC","DEC.","DECEMBER": return kMonths.Dec
                default: return 0
            }
        }

        /// returns Month Name from month as Int
        ///
        /// - parameter monthNumber: (Int) Number of month
        /// - returns: (Tuple Strings) of month name (Abbrev, Full)
        func returnMonthNameFromNum(monthNum:Int) -> (Abbrev:String,Name:String) {
            let monthNames = ["n/a","January","February","March","April","May","June","July","August","September","October",
                              "November","December"]

            if monthNum < 1 || monthNum > 12 {
                return ("n/a","invalid month")
            }
            
            let month = monthNames[monthNum]
            
            return (month[0..<3],month)
        }
        
        /// returns Date from an input string
        ///
        /// - parameter monthName: (String) Name of month or abbrev of month
        /// - returns: (Int) of month 0 = Not Found
        func returnDateFromString(dateString:String!,includeTime:Bool?=false) -> Date {
            var comp:DateComponents = DateComponents()
                comp.year = Int(dateString[0..<4])!
                comp.month = Int(dateString[5..<7])!
                comp.day = Int(dateString[8..<10])!
            
            if includeTime!.isTrue {
                comp.hour = Int(dateString[11..<13])!
                comp.minute = Int(dateString[14..<16])!
                comp.second = Int(dateString[17..<19])!
            }
            
            return Calendar.current.date(from: comp)!
        }
    }
    
// MARK: -
    /// Functions for DRAWing or changing appearance of UIView class ojects.
    struct DRAW {
        /// Add a shadow to a UIView class object.
        ///
        /// - parameter view: (UIView) View to add shadow.
        /// - parameter offset: [Optional] (Int) Size of shadow that will be used in creating CGSize.
        /// - parameter offsetSize: [Optional] (CGSize) Size of shadow.
        /// - parameter radius: (CGFloat) Diameter of shadow.
        /// - parameter opacity: [Optional] (Float) Depth of shadow color.
        /// - parameter color: [Optional] (UIColor) shadow color.
        /// - returns: (UIView) View with shadow added.
        func addShadow(view:UIView,offset:CGFloat? = nil,offsetSize:CGSize? = nil,radius:CGFloat,opacity:Float,color:UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
            view.layer.masksToBounds = false
            view.layer.shadowRadius  = radius
            view.layer.shadowOpacity = opacity
            view.layer.shadowColor = color!.cgColor
            
            if offset != nil {
                view.layer.shadowOffset = CGSize(width: offset!, height: offset!)
            }else if offsetSize != nil {
                view.layer.shadowOffset = offsetSize!
            }else{
                view.layer.shadowOffset = CGSize(width: 2, height: 2)
            }
        }

        func removeShadow(view:UIView) {
            view.layer.masksToBounds = false
            view.layer.shadowOffset  = CGSize.zero
            view.layer.shadowRadius  = 0.0
            view.layer.shadowOpacity = 0.0
            view.layer.shadowColor = UIColor.clear.cgColor
        }
        
        /// Round corner and color stroke border of a UIView class object.
        ///
        /// ie: sharedFunc.DRAW().roundCorner(view: vw, radius: 10.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 2.0)
        ///
        /// ie: sharedFunc.DRAW().roundCorner(view: lbl, radius: 10.0) replaces STROKE BORDER
        ///
        /// - parameter view: (UIView) View to round corner and optionally stroke border.
        /// - parameter radius: (CGFloat) Radius of corners.
        /// - parameter color: [Optional] (UIColor) Border color.
        /// - parameter width: [Optional] (Float) Border width.
        /// - returns: (UIView) View with corners rounded and optionally borders stroked in color.
        func roundCorner(view:UIView,radius:CGFloat,color:UIColor?=nil,width:CGFloat?=nil) {
            view.layer.masksToBounds = true
            view.layer.cornerRadius  = radius
            view.layer.borderColor = (color?.cgColor != nil) ? color!.cgColor :UIColor.clear.cgColor
            view.layer.borderWidth = (width != nil) ?width! :1.0
        }

        /// Color stroke border of a UIView class object.
        ///
        /// - parameter view: (UIView) View to round corner and optionally stroke border.
        /// - parameter color: (UIColor) Border color.
        /// - parameter width: (Float) Border width.
        /// - returns: (UIView) View with stroke added.
        func strokeBorder(view:UIView,color:UIColor,width:CGFloat) {
            view.layer.masksToBounds = true
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = width
        }

        func removeBorder(view:UIView) {
            view.layer.masksToBounds = true
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.borderWidth = 0.0
        }
        
        /// Adds a fading background gradient from start color to end color
        /// NOTE: Clear has a black color channel use UIColor(white: 1, alpha: 0) in place of .clear
        ///
        /// - parameter view: (UIView) View to add gradient to.
        /// - parameter startColor: (UIColor) Start Color.
        /// - parameter endColor: (UIColor) Finish Color.
        /// - returns: A CAGradientLayer is added to view parameter with gradient.
        func gradientH_Fade(view:UIView,startColor:UIColor,leftSide:Bool) ->Void{
            let clearColor = UIColor.clear.withAlphaComponent(0.01).cgColor
            let newLayer:CAGradientLayer = CAGradientLayer()
                newLayer.frame = CGRect(x: 0,y: 0,width: view.frame.size.width,height: view.frame.size.height)
            
            view.layer.sublayers = nil
            
            if leftSide.isTrue {
                newLayer.colors = [startColor.cgColor,clearColor]
                newLayer.startPoint = CGPoint(x: 0, y: 0.5)
                newLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            }else{
                newLayer.colors = [clearColor,startColor.cgColor]
                newLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                newLayer.endPoint = CGPoint(x: 0, y: 0.5)
            }
            
            view.layer.insertSublayer(newLayer, at: 0)
        }

        /// NOTE: Clear has a black color channel use UIColor(white: 1, alpha: 0) in place of .clear
        func gradient_Horizontal(view:UIView,color1:CGColor,color2:CGColor) ->Void{
            let gradientLayer = CAGradientLayer()
                gradientLayer.frame = view.bounds
                gradientLayer.colors = [color1,color2,color2,color2,color1]
                gradientLayer.locations = [0.0,0.33,0.5,0.66,1.0]
                gradientLayer.startPoint = CGPoint(x: 0,y: 0.75)
                gradientLayer.endPoint = CGPoint(x: 1,y: 0.75)
            
            view.layer.addSublayer(gradientLayer)
        }
        
        /// NOTE: Clear has a black color channel use UIColor(white: 1, alpha: 0) in place of .clear
        func addGradientToView(view:UIView) {
            let arrColors = [gAppColor,UIColor(white: 1, alpha: 0),UIColor(white: 1, alpha: 0)]
            let tallTopView:Bool = (view.frame.height > 70)
            let arrLocations:[NSNumber] = [0.0,tallTopView.isTrue ?0.335:0.425,tallTopView.isTrue ?0.34:0.43]
            sharedFunc.DRAW().gradientArray(view: view, colorsArray: arrColors, locationsArray: arrLocations)
        }
        
        /// Adds a background gradient from start color to end color
        /// NOTE: Clear has a black color channel use UIColor(white: 1, alpha: 0) in place of .clear
        ///
        /// - parameter view: (UIView) View to add gradient to.
        /// - parameter startColor: (UIColor) Start Color.
        /// - parameter endColor: (UIColor) Finish Color.
        /// - returns: A CAGradientLayer is added to view parameter with gradient.
        func gradient(view:UIView,startColor:UIColor,endColor:UIColor) ->Void{
            if view.layer.sublayers != nil {
                for layer in view.layer.sublayers! {
                    if layer.name == "gradientLayer" {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            
            let newLayer:CAGradientLayer = CAGradientLayer()
                newLayer.frame = view.frame
                newLayer.colors = [startColor.cgColor,endColor.cgColor]
                newLayer.locations = [0.0,1.0]
                newLayer.name = "gradientLayer"
            
            view.layer.insertSublayer(newLayer, at: 0)
        }

        /// Adds a background gradient from start color to end color & Locations
        /// NOTE: Clear has a black color channel use UIColor(white: 1, alpha: 0) in place of .clear
        /// - parameter view: (UIView) View to add gradient to.
        /// - parameter CG_colorsArray: (NSArray) CG Colors array (Same count as locations)
        /// - parameter locationsArray: (NSArray) Locations (0.0 - 1.0)
        /// - returns: A CAGradientLayer is added to view parameter with gradient.
        func gradientArray(view:UIView,colorsArray:[UIColor],locationsArray:[NSNumber]) ->Void{
            if view.layer.sublayers != nil {
                for layer in view.layer.sublayers! {
                    if layer.name == "gradientLayer" {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            
            var CG_colorsArray:[CGColor] = []
            colorsArray.forEach { (color) in CG_colorsArray.append(color.cgColor) }

            let newLayer:CAGradientLayer = CAGradientLayer()
                newLayer.frame = view.frame
                newLayer.colors = CG_colorsArray
                newLayer.locations = locationsArray
                newLayer.name = "gradientLayer"
            
            view.layer.insertSublayer(newLayer, at: 0)
        }

        /// Removes all background layers from UIView object class
        ///
        /// - parameter view: (UIView) View object.
        /// - returns: Removes all sub layers form UIView object passed in param.
        func removeSubLayers(view:UIView){
            let theSubLayers:Array<CALayer>! = view.layer.sublayers
            if theSubLayers != nil {
                for layer in theSubLayers {
                    layer.removeFromSuperlayer()
                }
            }
        }

        /// Creates a 'faded' image.
        ///
        /// - parameter image: (UIImage) source image
        /// - parameter alpha: (CGFloat) alpha 'fade' from 0.0 to 1.0
        /// - returns: (UIImage) faded alpha image.
        func returnFadedImage(image:UIImage, alpha:CGFloat) -> UIImage{
            let area:CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
            
            let ctx:CGContext = UIGraphicsGetCurrentContext()!
            
            ctx.scaleBy(x: 1, y: -1)
            ctx.translateBy(x: 0, y: -area.size.height)
            ctx.setBlendMode(CGBlendMode.multiply)
            ctx.setAlpha(alpha)
            ctx.draw(image.cgImage!, in: area)
            
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            
            return newImage
        }

        /// Adds a 'glossy' layer over object top portion.
        ///
        /// - parameter view: (UIView) source object
        /// - returns: (UIView) faded alpha image.
        func makeGlossy(view:UIView) -> Void{
            // Add background color layer and make original background clear
            let thisLayer:CALayer = view.layer
            let backgroundLayer:CALayer = CALayer()
            let glossLayer:CAGradientLayer = CAGradientLayer()

            backgroundLayer.cornerRadius = thisLayer.cornerRadius
            backgroundLayer.masksToBounds = true
            backgroundLayer.frame = thisLayer.bounds
            backgroundLayer.backgroundColor = thisLayer.backgroundColor
            
            if view.isKind(of: UINavigationBar.self).isFalse {
                thisLayer.sublayers = nil
            }
            
            thisLayer.insertSublayer(backgroundLayer, at: 0)
            
            /* Make original layer clear color */
            thisLayer.backgroundColor = UIColor.clear.cgColor
            
            // Add gloss to the background layer
            glossLayer.frame = thisLayer.bounds
            glossLayer.colors = [UIColor(white: 1.00, alpha: 0.40).cgColor,
                                 UIColor(white: 1.00, alpha: 0.20).cgColor,
                                 UIColor(white: 0.75, alpha: 0.00).cgColor,
                                 UIColor(white: 1.00, alpha: 0.20).cgColor]
            glossLayer.locations = [0.0,0.5,0.5,1.0]
            glossLayer.name = "Gloss layer"
            
            backgroundLayer.addSublayer(glossLayer)
        }

        /// - parameter degrees: (Double) Degrees in circle
        /// - returns: (Double) angle of radians
        func degreesToRadians(degrees:Double) -> CGFloat {
            return CGFloat(degrees / 180.0 * Double.pi)
        }

        /// - parameter degrees: (Double) Degrees in circle
        /// - returns: (Double) angle of radians
        func radiansToDegrees(radians:Double) -> CGFloat {
            return CGFloat(radians * 180 / Double.pi)
        }

        /// - parameter view: (UIView) View to convert to UIImage
        /// - returns: (UIImage) of UIView.
        func returnImage(view:UIView) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
                view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
    
            return image
        }
    }

// MARK: -
    /// Functions that format a String into predetermined formats for various specific uses.
    struct FILES {
        /// - parameter filePathAndName: (String) Path & Name of file
        /// - returns: (Int) Filesize
        func sizeFormatted(filePathAndName:String) -> (bytes:Int,kb:Float,kb$:String,mb:Float,mb$:String,gb:Float,gb$:String) {
            let bytes = try! FileManager.default.attributesOfItem(atPath: filePathAndName)[FileAttributeKey.size] as! Int

            let kb:Float = Float(bytes) / pow(1024, 1)
            let mb:Float = Float(bytes) / pow(1024, 2)
            let gb:Float = Float(bytes) / pow(1024, 3)

            let kb$:String = String(format: "%0.0f kb", kb)
            let mb$:String = String(format: "%0.1f mb", mb)
            let gb$:String = String(format: "%0.1f gb", gb)

            return (bytes,kb,kb$,mb,mb$,gb,gb$)
        }
        
        /// - parameter filePathAndName: (String) Path & Name of file
        /// - returns: (Int) Filesize
        func size(filePathAndName:String) -> Int {
            do {
                let fileSize = try FileManager.default.attributesOfItem(atPath: filePathAndName)[FileAttributeKey.size] as! Int
                return fileSize
            }catch{
                return 0
            }
        }
        
        /// - parameter url: (URL) Path & Name of file
        /// - returns: (Date) modified date
        func modifiedDate(url: URL) -> Date? {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                return attr[FileAttributeKey.modificationDate] as? Date
            } catch {
                return nil
            }
        }

        /// - parameter url: (URL) Path & Name of file
        /// - returns: (String) modified date
        func modifiedDateString(url: URL) -> String? {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                let date = attr[FileAttributeKey.modificationDate] as? Date
                let convertedDate = date?.toString(format: kDateFormat.yyyyMMdd_HHmmss)
                
                return convertedDate
            } catch {
                return nil
            }
        }
        
        /// - parameter url: (URL) Path & Name of file
        /// - returns: (Date) created date
        func createdDate(url: URL) -> Date? {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                return attr[FileAttributeKey.creationDate] as? Date
            } catch {
                return nil
            }
        }
        
        /// - parameter filePathAndName: (String) Path & Name of file
        /// - returns: (Date) Filedate
        func date(filePathAndName:String) -> Date {
            do {
                let fileDate = try FileManager.default.attributesOfItem(atPath: filePathAndName)[FileAttributeKey.creationDate] as! Date
                return fileDate
            }catch{
                return Date()
            }
        }
        
        /// - parameter filePathAndName: (String) Path & Name of file
        /// - returns: (Bool) File exists in Path
        func exists(filePathAndName:String) -> Bool {
            return FileManager.default.fileExists(atPath: filePathAndName)
        }

        /// - parameter filePathAndName: (String) Path & Name of file
        /// - returns: (Bool) Files are same as others in Paths
        func areTheSame(fromPathAndName:String,toPathAndName:String) -> Bool {
            return FileManager.default.contentsEqual(atPath: fromPathAndName, andPath: toPathAndName)
        }
        
        /// - parameter fromPathAndName: (String) Path & Name of file
        /// - returns: (Bool) Folder created
        @discardableResult func createDir(filePathAndName:String) -> Bool {
            var error:NSError?
            
            var success:Bool = sharedFunc.FILES().exists(filePathAndName: filePathAndName)
            if success.isFalse {
                do {
                    try FileManager.default.createDirectory(atPath: filePathAndName, withIntermediateDirectories: true, attributes: nil)
                    success = true
                } catch let error1 as NSError {
                    error = error1
                    success = false
                }
                
                if error != nil {
                    sharedFunc.ALERT().show(
                        title:"FILE_Error_Title".localizedCAS(),
                        style:.error,
                        msg:"\(String(describing: error?.description))"
                    )
                }
            }
            
            return success
        }

        @discardableResult func copyFromMainBundleToDocFolder(filename:String,overwrite:Bool?=false,showError:Bool?=false) -> Bool {
            let originPath = sharedFunc.FILES().dirMainBundle(fileName: filename)
            let destinationPath = sharedFunc.FILES().dirDocuments(fileName: filename)
            
            if sharedFunc.FILES().exists(filePathAndName: destinationPath).isFalse {
                if sharedFunc.FILES().exists(filePathAndName: originPath) {
                    let success = sharedFunc.FILES().copy(fromPathAndName: originPath,
                                                            toPathAndName: destinationPath,
                                                                overwrite: overwrite!)
                    return success
                }else{
                    if showError! {
                        sharedFunc.ALERT().show(
                            title:"FILE_Error_Title".localizedCAS(),
                            style:.error,
                            msg:"Could not locate MAIN BUNDLE \( filename ), contact technical support.",
                            delay: 1.0
                        )
                    }
                    
                    return false
                }
            }

            return true
        }
        
        /// - parameter fromPathAndName: (String) Path & Name of file
        /// - parameter toPathAndName: (String) Path & Name of file
        /// - returns: (Bool) File copied from path to path
        @discardableResult func copy(fromPathAndName:String,toPathAndName:String,overwrite:Bool?=false) -> Bool {
            do {
                if overwrite! {
                    if sharedFunc.FILES().exists(filePathAndName: toPathAndName) {
                        try FileManager.default.removeItem(atPath: toPathAndName)
                    }
                    if sharedFunc.FILES().exists(filePathAndName: fromPathAndName) {
                        try FileManager.default.copyItem(atPath: fromPathAndName, toPath: toPathAndName)
                    } else {
                        return false
                    }
                }else{
                    try FileManager.default.copyItem(atPath: fromPathAndName, toPath: toPathAndName)
                }
                
                return true
            } catch let error as NSError {
                sharedFunc.ALERT().show(
                    title:"FILE_Error_Title".localizedCAS(),
                    style:.error,
                    msg:"\(error.localizedDescription)"
                )
                return false
            }
        }

        /// - parameter fromPathAndName: (String) Path & Name of file
        /// - parameter toPathAndName: (String) Path & Name of file
        /// - returns: (Bool) File renames from path+name to path+name
        @discardableResult func rename(fromPathAndName:String,toPathAndName:String,overwrite:Bool?=false) -> Bool {
            do {
                if overwrite! {
                    if sharedFunc.FILES().exists(filePathAndName: toPathAndName) {
                        try FileManager.default.removeItem(atPath: toPathAndName)
                    }
                    if sharedFunc.FILES().exists(filePathAndName: fromPathAndName) {
                        try FileManager.default.moveItem(atPath: fromPathAndName, toPath: toPathAndName)
                    } else {
                        return false
                    }
                }else{
                    try FileManager.default.moveItem(atPath: fromPathAndName, toPath: toPathAndName)
                }
                
                return true
            } catch let error as NSError {
                sharedFunc.ALERT().show(
                    title:"FILE_Error_Title".localizedCAS(),
                    style:.error,
                    msg:"\(error.localizedDescription)"
                )
                return false
            }
        }

        /// - parameter fromPathAndName: (String) Path & Name of file
        /// - parameter toPathAndName: (String) Path & Name of file
        /// - returns: (Bool) File moved from path to path
        @discardableResult func move(fromPathAndName:String,toPathAndName:String) -> Bool {
            do {
                try FileManager.default.moveItem(atPath: fromPathAndName, toPath: toPathAndName)
                return true
            } catch let error as NSError {
                sharedFunc.ALERT().show(
                    title:"FILE_Error_Title".localizedCAS(),
                    style:.error,
                    msg:"\(error.localizedDescription)"
                )
                return false
            }
        }

        /// - parameter filePathAndName: (String) Path & Name of file
        /// - returns: (Bool) File exists in Path
        @discardableResult func delete(showMsg:Bool? = false,filePathAndName:String) -> Bool {
            do {
                try FileManager.default.removeItem(atPath: filePathAndName)
                return true
            } catch let error as NSError {
                if showMsg!.isTrue {
                    sharedFunc.ALERT().show(
                        title:"FILE_Error_Title".localizedCAS(),
                        style:.error,
                        msg:"\(error.localizedDescription)"
                    )
                }
                return false
            }
        }

        @discardableResult func deleteFiles(showMsg:Bool? = false,Predicate pattern:String, path:String) -> Bool {
            let fm = FileManager.default

            do {
                let filteredFiles = try (fm.contentsOfDirectory(atPath: path) as NSArray).filtered(using: NSPredicate(format: pattern))
                
                for filename in filteredFiles {
                    do {
                        try fm.removeItem(atPath: path.stringByAppendingPathComponent(filename as! String))
                    } catch let error as NSError {
                        if showMsg!.isTrue {
                            sharedFunc.ALERT().show(
                                title:"FILE_Error_Title".localizedCAS(),
                                style:.error,
                                msg:"\(error.localizedDescription)"
                            )
                        }
                        return false
                    }
                }
                return true
            } catch let error as NSError {
                if showMsg!.isTrue {
                    sharedFunc.ALERT().show(
                        title:"FILE_Error_Title".localizedCAS(),
                        style:.error,
                        msg:"\(error.localizedDescription)"
                    )
                }
                return false
            }
        }
        
        /// Returns Caches temp images directory. Optionally supply filename to append to path.
        ///
        /// - parameter fileName: (String) [ Optional ] Name of file to append or leave empty for root directory.
        /// - returns: (String) Document Directory Path [+ optional Filename].
        func dirCaches_Imgs(fileName:String?=nil) -> String {
            var directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
            directory = directory.stringByAppendingPathComponent("tmpThumbnails")

            if fileName != nil {
                directory = directory.stringByAppendingPathComponent(fileName!)
            }
            
            return directory
        }
        
        /// Returns Caches directory. Optionally supply filename to append to path.
        ///
        /// - parameter fileName: (String) [ Optional ] Name of file to append or leave empty for root directory.
        /// - returns: (String) Document Directory Path [+ optional Filename].
        func dirCaches(fileName:String?=nil) -> String {
            var directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
            if fileName != nil {
                directory = directory.stringByAppendingPathComponent(fileName!)
            }
            
            return directory
        }
        
        /// Returns Documents directory. Optionally supply filename to append to path.
        ///
        /// - parameter fileName: (String) [ Optional ] Name of file to append or leave empty for root directory.
        /// - returns: (String) Document Directory Path [+ optional Filename].
        func dirDocuments(fileName:String?=nil) -> String {
            var directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            if fileName != nil {
                directory = directory.stringByAppendingPathComponent(fileName!)
            }

            return directory
        }

        /// Returns Library directory. Optionally supply filename to append to path.
        ///
        /// - parameter fileName: (String) [ Optional ] Name of file to append or leave empty for root directory.
        /// - returns: (String) Library Directory Path [+ optional Filename].
        func dirLibrary(fileName:String?=nil) -> String {
            var directory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
            if fileName != nil {
                directory = directory.stringByAppendingPathComponent(fileName!)
            }

            return directory
        }
        
        /// Returns MainBundle directory. Optionally supply filename to append to path.
        ///
        /// - parameter fileName: (String) [ Optional ] Name of file to append or leave empty for root directory.
        /// - returns: (String) MainBundle Directory Path [+ optional Filename].
        func dirMainBundle(fileName:String?=nil) -> String {
            var directory = Bundle.main.bundlePath
            if fileName != nil {
                directory = directory.stringByAppendingPathComponent(fileName!)
            }

            return directory
        }

        /// Returns MainBundle directory. Optionally supply filename to append to path.
        ///
        /// - parameter directory: (String) Name of directory
        /// - parameter filterFileType: (String) File type to include
        /// - returns: (NSArray) List of all files in array matching filterFileType
        func returnAllFilesInDirectory(directory:String,filterFileType:String) -> NSArray {
            var filedirectory = directory
            
            let Dir:NSArray! = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray?
            
            filedirectory = Dir.object(at: 0) as? String ?? ""
            if filedirectory != "" {
                (filedirectory as NSString).appendingPathComponent(filedirectory as String)
            }
            
            var arrayFiles:NSArray!
            var fltr:NSPredicate!
            let fileMgr = FileManager.default
            
            if (filterFileType as NSString).length > 0 {
                fltr = NSPredicate(format: "self ENDSWITH '\(filterFileType)'")
                arrayFiles = try! fileMgr.contentsOfDirectory(atPath: directory) as NSArray
                arrayFiles = arrayFiles.filtered(using: fltr) as NSArray?
            }else{
                arrayFiles = try! fileMgr.contentsOfDirectory(atPath: directory) as NSArray
            }
            
            return arrayFiles;
        }
    }

// MARK: -
    /// Functions for registering and returning a UIGesture object.
    struct FONTS {
        func printFonts() {
            for family: String in UIFont.familyNames {
                if isSim { print("\(family)") }
                for names: String in UIFont.fontNames(forFamilyName: family) {
                    if isSim { print("== \(names)") }
                }
            }
        }
    }
    
// MARK: -
    /// Functions for registering and returning a UIGesture object.
    struct GESTURES {
        /// Register and create a TAP gesture for UIView class object.
        ///
        /// - parameter selector: (String) Name of selector method in quotes. If parameters to follow, suffix : in Name.
        /// - parameter delegate: (AnyObject) Typically is the self parameter.
        /// - parameter numTaps: (Int) Number of taps to activate Gesture.
        /// - parameter numTouches: (Int) Number of touches to activate Gesture.
        /// - parameter cancelTouches: (Bool) Cancel other gestures in view.
        /// - parameter delaysTouches: (Bool) Delays other gestures in view.
        /// - returns: (UITapGestureRecognizer) Tap Gesture for object.
        func returnTap(selector:String,
                       delegate:AnyObject,
                        numTaps:Int,
                     numTouches:Int? = 0,
                  cancelTouches:Bool? = false,
                  delaysTouches:Bool? = false) -> UITapGestureRecognizer{
            
            let tap:UITapGestureRecognizer! = UITapGestureRecognizer(target: delegate, action: NSSelectorFromString(selector))
                tap.delegate = delegate as? UIGestureRecognizerDelegate
                tap.numberOfTapsRequired = numTaps
                if numTouches! > 0 {
                    tap.numberOfTouchesRequired = numTouches!
                }
                tap.cancelsTouchesInView = cancelTouches!
                tap.delaysTouchesEnded = delaysTouches!
            
            return tap
        }

        /** 
            Register and create a SWIPE gesture for UIView class object.
            - parameter selector: (String) Name of selector method in quotes. If parameters to follow, suffix : in Name.
            - parameter delegate: (AnyObject) Typically is the self parameter.
            - parameter direction: (UISwipeGestureRecognizerDirection) Direction of Gesture.
            - parameter cancelTouches: (Bool) Cancel other gestures in view.
            - returns: (UITapGestureRecognizer) Tap Gesture for object.
        */
        func returnSwipe(selector:String, delegate:AnyObject, direction:UISwipeGestureRecognizer.Direction, numTouches:Int, cancelTouches:Bool? = false) -> UISwipeGestureRecognizer{
            let swipe:UISwipeGestureRecognizer! = UISwipeGestureRecognizer(target: delegate, action: NSSelectorFromString(selector))
                swipe.direction = direction
                swipe.numberOfTouchesRequired = numTouches
                swipe.cancelsTouchesInView = cancelTouches!
                swipe.delegate = delegate as? UIGestureRecognizerDelegate

            return swipe
        }

        /// Register and create a PAN gesture for UIView class object.
        ///
        /// - parameter selector: (String) Name of selector method in quotes. If parameters to follow, suffix : in Name.
        /// - parameter delegate: (AnyObject) Typically is the self parameter.
        /// - parameter direction: (UIPanGestureRecognizerDirection) Direction of Gesture.
        /// - returns: (UITapGestureRecognizer) Tap Gesture for object.
        func returnPan(selector:String, delegate:AnyObject, numTouches:Int) -> UIPanGestureRecognizer{
            let pan:UIPanGestureRecognizer! = UIPanGestureRecognizer(target: delegate, action: NSSelectorFromString(selector))
                pan.minimumNumberOfTouches = numTouches
                pan.cancelsTouchesInView = false
                pan.delegate = delegate as? UIGestureRecognizerDelegate

            return pan
        }
    }


// MARK: -
    /// Functions that format a String into predetermined formats for various specific uses.
    struct HTML {
        /// Formats an ordinary String into HTML format specifically for Titles intended for Emails. Font size is large.
        ///
        /// - parameter appendTo: (String) Append the new formatted information to.
        /// - parameter title: (String) To format.
        /// - parameter titleColor: (String) Name (HTML color name) of text color.
        /// - returns: (String) Formatted title.
        func addTitle(appendTo:String,title:String,titleColor:String) -> String {
            return appendTo + "<hr /><p style=\"background-color:white;font-family:verdana;font-size:14;color:\(titleColor);text-Align:center;\"><b>\(title)</b><hr />"
        }

        /// Formats an ordinary String into HTML format specifically for Details intended for Emails. Created 2 columns,
        /// Font size is normal. Right Column width percent is calculated for you. Left Column is Right-Aligned, Right Column
        /// is Left-Aligned.
        ///
        /// - parameter appendTo: (String) Append the new formatted information to.
        /// - parameter title: (String) LEFT text that you want format.
        /// - parameter titleWidth: (Int) Width of LEFT column.
        /// - parameter titleColor: (String) Name (HTML color name) of LEFT column text color.
        /// - parameter subject: (String) RIGHT text that you want format.
        /// - parameter subjectColor: (String) Name (HTML color name) of RIGHT column text color.
        /// - returns: (String) Formatted 2-Coulmn Subject
        func addDetails(appendTo:String,title:String,titleWidth:Int,titleColor:String,subject:String,subjectColor:String) -> String {
            let subjectWidth:Int = (100 - titleWidth)

            /* Title Section */
            let msg:String! = appendTo + "<tr><td style=\"width:\(titleWidth)%;color:\(titleColor);\"><b>\(title)</b></td>"

            /* Subject Section */
            return msg + "<td style=\"background-Color:white;font-family:verdana;font-size:10;color:\(subjectColor);width:\(subjectWidth);text-Align:left;\"><i>\(subject)</i></td></tr>"
        }

      }

// MARK: -
    /// Functions for manipulating UIImage class objects.
    struct IMAGE {
// MARK: ├─➤ EFFECTS
        /// Adds a blurred layer as background layer
        ///
        /// - parameter view: (UIView) View to blur.
        /// - parameter stlye: (UIBlurEffectStyle) Blur Style.
        func addBlurEffect(view:UIView, style:UIBlurEffect.Style) {
            if view.subviews.count > 0 {
                for subview in view.subviews {
                    if subview.tag == reservedTags.blurView.rawValue {
                        subview.removeFromSuperview()
                    }
                }
            }

            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
                effectView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                effectView.tag = reservedTags.blurView.rawValue

            view.backgroundColor = .clear
            view.isOpaque = false
            view.insertSubview(effectView, at: 0)
        }

        
        /// Recolor an image.
        /// - parameter img: (UIImage) Image to recolor.
        /// - parameter color: (UIColor) Color to use.
        /// - returns: (UIImage) Recolored image.
        func recolorImage(img:UIImage,color:UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: img.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(CGBlendMode.normal)
            let rect:CGRect = CGRect(x:0,y: 0,width: img.size.width,height: img.size.height)
            context.clip(to: rect, mask: img.cgImage!)
            color.setFill()
            context.fill(rect)
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        /** Return image desaturated into Grayscale
         - parameters:
         - img: (UIImage) Image to convert to grayscale.
         */
        func convertToGrayScale(img image: UIImage) -> UIImage {
            let imageRect:CGRect = CGRect(x: 0,y: 0,width: image.size.width,height: image.size.height)
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let width = image.size.width
            let height = image.size.height
            
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
            
            context?.draw(image.cgImage!, in: imageRect)
            
            let imageRef = context!.makeImage()
            let newImage = UIImage(cgImage: imageRef!)
            
            return newImage
        }
        
// MARK: ├─➤ RESIZE
        /// Grabs a screen capture image.
        /// - parameter image: UIImage to resize.
        /// - parameter toSize: Target size of image to be resized TO
        /// - parameter ignoreScale: Disregard scale and use exact size specified in params
        /// - parameter save: (optional) save to DOCUMENTS folder
        /// - parameter fileName: (Optional) filename
        /// - returns: (UIImage) Resized UIImage
        func resizeImage(image:UIImage, toSize:CGSize, ignoreScale:Bool, save:Bool? = false, fileName:String? = "savedImage") -> UIImage {
            var resizedImage:UIImage
            var rectResize = toSize
            let imgToResize = image
            
            if rectResize.height > 0 {
                let scale:CGFloat = ignoreScale ?1.0 :UIScreen.main.scale
                
                rectResize = CGSize(width: rectResize.width * scale,height: rectResize.height * scale)
                
                UIGraphicsBeginImageContext(rectResize)
                imgToResize.draw(in: CGRect(x:0,y:0,width:rectResize.width,height:rectResize.height))
                resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }else{
                resizedImage = UIImage()
            }
            
            if save! && !fileName!.isEmpty {
                do {
                    let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                    appropriateFor: nil,
                                                            create: false).appendingPathComponent(fileName!)

                    try resizedImage.pngData()?.write(to: fileURL, options: .atomic)
                } catch {
                    sharedFunc.ALERT().show(
                        title:"IMAGE_SaveError_Title".localizedCAS(),
                        style:.error,
                        msg:"IMAGE_SaveError_Msg".localizedCAS() + "\(String(describing: fileName))'."
                    )
                }
            }
            
            return resizedImage
        }

// MARK: ├─➤ SCREEN CAPTURES
        /// Grabs a screen capture image.
        ///
        /// IMPORTANT: When using Modal screen, presentation style must be set to "Over Full Screen"
        ///
        /// - parameter view: (UIView) View to capture.
        /// - returns: (UIImage) Screenshot image of VIEW.
        func screenShot(view:UIView) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 1.0)
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return screenshot!
        }
        
        func screenShotWithTransparency(view:UIView) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
                view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return screenshot!
        }
    }
    

// MARK: -
    /// Functions that respond to MFMailComposerDelegate.
    struct MAIL {
        /// - returns: MFMailComposer object.
        func eMailWithAttachment(delegate:MFMailComposeViewControllerDelegate,
                           viewController:UIViewController,
                                   sendTo:Array<String>? = [],
                                  subject:String? = "",
                                  message:String? = "",
                   attachmentFilenamePath:String? = "",
                       attachmentMimeType:kMimeTypes? = kMimeTypes.pdf) -> Void {

            if isSim.isTrue {
                waitHUD().hideNow()
                sharedFunc.ALERT().show(
                    title:"SIM_FeatureNotAvail_Title".localizedCAS(),
                    style:.error,
                    msg:"SIM_FeatureNotAvail_Msg".localizedCAS(),
                    delay: 1.0
                )
                return
            }
            
            let mc:MFMailComposeViewController = MFMailComposeViewController()
            let canSendMail:Bool = MFMailComposeViewController.canSendMail()
            let networkAvailable:Bool = sharedFunc.NETWORK().available() 

            /* Can device send mail? */
            if canSendMail.isFalse || networkAvailable.isFalse {
                waitHUD().hideNow()
                sharedFunc.ALERT().show(
                    title:"EMAIL_NoAccess_Title".localizedCAS(),
                    style:.error,
                    msg:"EMAIL_NoAccess_Msg".localizedCAS(),
                    delay: 0.1
                )
                return
            }

            /* Initialize mail controller */
            mc.navigationBar.barStyle = .default
            mc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            mc.modalTransitionStyle = .coverVertical
            mc.modalPresentationStyle = .overFullScreen
            mc.mailComposeDelegate = delegate
            mc.title = "Email"

            /* Initialize mail message */
            mc.setToRecipients((sendTo!.count > 0) ?sendTo :nil)
            mc.setCcRecipients(nil)
            mc.setBccRecipients(nil)
            mc.setSubject(subject!.isEmpty ?"" :subject!)

            /* Attach Files */
            if attachmentFilenamePath!.isNotEmpty {
                var sMimeType:String
                switch attachmentMimeType! {
                    case .pdf:
                        sMimeType = kMimeTypeValues.PDF
                        mc.setMessageBody(message!, isHTML: true)
                    case .text:
                        sMimeType = kMimeTypeValues.Text
                        mc.setMessageBody(message!, isHTML: false)
                    case .csv:
                        sMimeType = kMimeTypeValues.CSV
                        mc.setMessageBody(message!, isHTML: message!.isEmpty ?false :true)
                    case .zipArchive:
                        sMimeType = kMimeTypeValues.ZipArchive
                        mc.setMessageBody(message!, isHTML: false)
                    default:
                        sMimeType = kMimeTypeValues.PDF
                        mc.setMessageBody(message!, isHTML: true)
                }
                
                guard let attachmentData = NSData(contentsOfFile: attachmentFilenamePath!) as Data? else{
                    sharedFunc.ALERT().show(
                        title:"EMAIL_Attachment_Title".localizedCAS(),
                        style:.error,
                        msg:"EMAIL_Attachment_Msg".localizedCAS()
                    )
                    return
                }
                
                let filename = attachmentFilenamePath!.lastPathComponent
                
                mc.addAttachmentData(attachmentData, mimeType: sMimeType, fileName: filename)
            }else{
                mc.setMessageBody(message!, isHTML: true)
            }
            
            viewController.present(mc, animated: true, completion:nil)
        }
        

        /// - returns: MFMailComposer object as a ContactUs format with app and device information.
        func contactUs_Plain(title:String? = "User Contact",
                           subject:String? = "",
                            sendTo:String? = appInfo.COMPANY.SUPPORT.EMAIL.customer,
                          delegate:MFMailComposeViewControllerDelegate,
                    viewController:UIViewController) -> Void {
            
            let mc:MFMailComposeViewController = MFMailComposeViewController()
            let canSendMail:Bool = MFMailComposeViewController.canSendMail() 
            let networkAvailable:Bool = sharedFunc.NETWORK().available()
            
            /* Can device send mail? */
            if networkAvailable.isTrue {
                if isSim.isTrue {
                    sharedFunc.ALERT().show(
                        title:"SIM_FeatureNotAvail_Title".localizedCAS(),
                        style:.error,
                        msg:"SIM_FeatureNotAvail_Msg".localizedCAS()
                    )
                    return
                }else if canSendMail.isFalse || networkAvailable.isFalse {
                    sharedFunc.ALERT().show(
                        title:"EMAIL_NoAccess_Title".localizedCAS(),
                        style:.error,
                        msg:"EMAIL_NoAccess_Msg".localizedCAS()
                    )
                    return
                }
            }
            
            var subjectMsg:String = ""
            if subject!.isEmpty {
                subjectMsg = "User contact from: \(Bundle.main.displayName) v\(Bundle.main.fullVer)(\(appInfo.EDITION.revision!))"
            }else{
                subjectMsg = subject!
            }
            
            /* Initialize mail controller */
            mc.navigationBar.barStyle = .default
            mc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            mc.modalTransitionStyle = .coverVertical
            mc.modalPresentationStyle = .overFullScreen
            mc.mailComposeDelegate = delegate
            mc.title = title!
            mc.setToRecipients([sendTo!])
            mc.setCcRecipients(nil)
            mc.setBccRecipients(nil)
            
            /* set & display mail controller */
            mc.setSubject(subjectMsg)
            mc.setMessageBody("",isHTML:true)
            
            viewController.present(mc, animated: true, completion:nil)
        }
        
        /// - returns: MFMailComposer object as a ContactUs format with app and device information.
        func contactUs(
                delegate:MFMailComposeViewControllerDelegate,
                viewController:UIViewController,
                titleColor:String,
                bannerColor:String
            ) -> Void {
            
            let mc:MFMailComposeViewController = MFMailComposeViewController()
            let canSendMail:Bool = MFMailComposeViewController.canSendMail()
            let networkAvailable:Bool = sharedFunc.NETWORK().available()

            /* Can device send mail? */
            if networkAvailable.isTrue {
                if isSim.isTrue {
                    sharedFunc.ALERT().showSimulatorMsg()
                    return
                }else if canSendMail.isFalse {
                    sharedFunc.ALERT().show(
                        title:"EMAIL_NoAccess_Title".localizedCAS(),
                        style:.error,
                        msg:"EMAIL_NoAccess_Msg".localizedCAS()
                    )
                    return
                }
            }else{
                sharedFunc.ALERT().show(
                    title:"INTERNET_NotConnected_Title".localizedCAS(),
                    style:.error,
                    msg:"INTERNET_NotConnected_Msg".localizedCAS()
                )
                return
            }

            /* Initialize mail controller */
            mc.navigationBar.barStyle = .default
            mc.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            mc.modalTransitionStyle = .coverVertical
            mc.modalPresentationStyle = .overFullScreen
            mc.mailComposeDelegate = delegate
            mc.title = "User Contact"
            mc.setToRecipients([appInfo.COMPANY.SUPPORT.EMAIL.technical])
            mc.setCcRecipients(nil)
            mc.setBccRecipients(nil)

            /* Device Disk/RAM space */
            let temp:String! = "\(UIDevice.current.diskTotalSpace)     (Used: \(UIDevice.current.diskUsedSpace))    Free: \(UIDevice.current.diskFreeSpace)"
            let temp2:String! = "\(UIDevice.current.memoryTotal)     (Used: \(UIDevice.current.memoryUsed))    Free: \(UIDevice.current.memoryFree)"

            /* Build HTML eMail body */
            var Msg:String! = "\r\r<html><body>"

            /* Comments */
            Msg = sharedFunc.HTML().addTitle(appendTo:Msg,title:"YOUR COMMENTS TO OUR SUPPORT TEAM",titleColor:titleColor)
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"",titleWidth:35,titleColor:titleColor,subject:"",subjectColor:"black")
            //--- Blank Spaces providing room for user comments ---
            Msg = Msg + "<br /><br /><br /><br />"

            /* App Info */
            let useAppStore:Bool! = (sharedFunc.NETWORK().available().isTrue &&
                                     sharedFunc.APP().isAdhocMode().isFalse &&
                                     SKPaymentQueue.canMakePayments().isTrue)
            let appstore:String! = useAppStore.isTrue ?"Accesssible" :"N/A"
            let payments:String! = SKPaymentQueue.canMakePayments().isTrue && useAppStore.isTrue ?"Yes" :"N/A"
            
            Msg = sharedFunc.HTML().addTitle(appendTo:Msg,title:"APPLICATION INFORMATION",titleColor:bannerColor)
            //--- Setup table grid ---
            Msg = Msg + "<table cellspacing=\"6\" style=\"font-family:verdana;font-size:10.fpx;color:darkblue;text-align:right\" >"
            //--- table data ---
            let col:Int = 38
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Display Name:",titleWidth:col,titleColor:titleColor,subject:Bundle.main.displayName,subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Version:",titleWidth:col,titleColor:titleColor,subject:"\(Bundle.main.fullVer).\(appInfo.EDITION.revision!)",subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Runtime:",titleWidth:col,titleColor:titleColor,subject:sharedFunc.APP().runtimeMode,subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Distribution:",titleWidth:col,titleColor:titleColor,subject:sharedFunc.APP().distributionMode,subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Model Name:",titleWidth:col,titleColor:titleColor,subject:UIDevice.current.modelName,subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"OS Version:",titleWidth:col,titleColor:titleColor,subject:"iOS \(UIDevice.current.systemVersion)",subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Storage:",titleWidth:col,titleColor:titleColor,subject:temp,subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Memory:",titleWidth:col,titleColor:titleColor,subject:temp2,subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"Network:",titleWidth:col,titleColor:titleColor,subject:"\(sharedFunc.NETWORK().connection())",subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"AppStore:",titleWidth:col,titleColor:titleColor,subject:"\(appstore!)",subjectColor:"black")
            Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"In-App Purch.:",titleWidth:col,titleColor:titleColor,subject:"\(payments!)",subjectColor:"black")

            /* Databases */
            var arr:[[String]] = sharedFunc.APP().about_databaseInfo
            for arrInfo in arr {
                Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"\(arrInfo[0]):",titleWidth:col,titleColor:titleColor,subject:"v\(arrInfo[1])",subjectColor:"black")
            }

            /* Libraries */
            let libraries:[[String:String]] = Constants().getLibraryVersions()
            for item:[String:String] in libraries {
                if isSim { print("v\(item["Version"]!)-\(item["Name"]!)") }
                Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"\(item["Name"]!):",titleWidth:col,titleColor:titleColor,subject:"v\(item["Version"]!)",subjectColor:"black")
            }
            
            /* External Libraries */
            arr = Constants().getFabricVersion().namesAndVersions
            for arrInfo in arr {
                Msg = sharedFunc.HTML().addDetails(appendTo:Msg,title:"\(arrInfo[0]):",titleWidth:col,titleColor:titleColor,subject:"\(arrInfo[1])",subjectColor:"black")
            }

            Msg = Msg.appending("</table>")

            /* set & display mail controller */
            mc.setSubject("User contact from: \(Bundle.main.displayName) v\(Bundle.main.fullVer)(\(appInfo.EDITION.revision!))")
            mc.setMessageBody(Msg,isHTML:true)
            
            viewController.present(mc, animated: true)
        }
        
        /// - returns: Mail sent (Contact us)
        func uponCompletion(
            controller:MFMailComposeViewController!,
            result:MFMailComposeResult,
            showMsg:Bool? = true,
            error:Error!
        ) -> Void {
            
            if showMsg!.isTrue {
                var title:String = ""
                var msg:String = ""
                var style:CASAlertViewType = .success

                if let resultCode =  MFMailComposeResult(rawValue: result.rawValue) {  switch resultCode {
                    case .sent:
                        title = "EMAIL_Sent_Title".localizedCAS()
                        msg = "EMAIL_Sent_Msg".localizedCAS()
                        style = .success
                    case .cancelled:
                        title = "EMAIL_Cancelled_Title".localizedCAS()
                        msg = "EMAIL_Cancelled_Msg".localizedCAS()
                        style = .info
                    case .failed:
                        title = "EMAIL_ComposeError_Title".localizedCAS()
                        msg = "EMAIL_ComposeError_Msg".localizedCAS()
                        style = .error
                    case .saved: ()
                    @unknown default:()
                    }
                }
                
                if title.isNotEmpty {
                    sharedFunc.ALERT().show(title: title,style:style,msg: msg)
                }
            }
        }
    
        /// - returns: Mail sent (Generic)
        func uponMailCompletion(controller: MFMailComposeViewController!, result: MFMailComposeResult, error: NSError!) -> Void {
            switch result.rawValue {
                case MFMailComposeResult.cancelled.rawValue:()
                case MFMailComposeResult.saved.rawValue:()
                case MFMailComposeResult.sent.rawValue:
                    sharedFunc.ALERT().show(
                        title:"EMAIL_Sent_Title".localizedCAS(),
                        style:.error,
                        msg:"EMAIL_Sent_Msg".localizedCAS()
                    )
                case MFMailComposeResult.failed.rawValue:
                    sharedFunc.ALERT().show(
                        title:"EMAIL_ComposeError_Title".localizedCAS(),
                        style:.error,
                        msg:"EMAIL_ComposeError_Msg".localizedCAS()
                    )
                default:
                    sharedFunc.ALERT().show(
                        title:"EMAIL_UnknownError_Title".localizedCAS(),
                        style:.error,
                        msg:"EMAIL_UnknownError_Msg".localizedCAS()
                    )
            }
        }
    }


// MARK: -
    /// NETWORK FUNCTIONS.
    struct NETWORK {
        /// - returns: (Bool) Network availability.
        func available() -> Bool {
            return (Reachability()?.isReachable)!
        }

        /// - returns: Displays Alert message to user.
        /// - returns: (Bool) Network availability.
        @discardableResult func displayMsgIfNotAvailable(simulateOff:Bool? = false,showInfoInsteadOfScreen:Bool? = false) -> Bool {
            let available:Bool = (isSimDevice && simulateOff!) ?false :sharedFunc.NETWORK().available()
            
            if available.isFalse {
                sharedFunc.ALERT().show(
                    title:"INTERNET_NotConnected_Title".localizedCAS(),
                    style:.error,
                    msg:showInfoInsteadOfScreen!
                        ?"INTERNET_NotConnectedChangeInfo_Msg".localizedCAS()
                        :"INTERNET_NotConnected_Msg".localizedCAS()
                )
            }
            
            return available
        }
        
        /// - returns: (String) Type of Network availabe.
        func connection() -> String {
            return Reachability()!.currentReachabilityString
        }
    }
    

// MARK: -
    /// Functions relating to StoreKit App Rating functionality.
    struct RATEAPP {
        func incrementAppRuns(forceShowForTest:Bool) { // counter for number of runs for the app. You can call this from App Delegate
            if forceShowForTest && sharedFunc.APP().isAdhocMode() {
                if isSim.isTrue { print("AppRating: Forced Review from AppDelegate requested from AppStore") }
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    // Fallback on earlier versions
                }
            }
            
            let prefs = UserDefaults.standard
            let runs = getRunCounts() + 1
            prefs.setValuesForKeys([appRating().runIncrementerSetting:runs])
            prefs.synchronize()
        }

        func getRunCounts () -> Int { // Reads number of runs from UserDefaults and returns it.
            let prefs = UserDefaults.standard
            let savedRuns = prefs.value(forKey: appRating().runIncrementerSetting)
            
            var runs = 0
            if (savedRuns != nil) {
                runs = savedRuns as! Int
            }
            
            if isSim.isTrue { print("AppRating: Run Counts are \(runs)") }
            
            return runs
        }
        
        func showReview() {
            let runs = getRunCounts()

            if isSim.isTrue { print("AppRating: Show review") }
            
            if (runs > appRating().minimumRunCount) {
                if #available(iOS 10.3, *) {
                    if isSim.isTrue { print("AppRating: Review requested from AppStore") }
                    SKStoreReviewController.requestReview()
                } else {
                    // Fallback on earlier versions
                }
            } else {
                if isSim.isTrue { print("AppRating: Runs (\(runs)) are not enough to request review.") }
            }
        }
    }

// MARK: -
    /// Functions that upload/download to a remote server.
    struct SERVER {
        func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
    }
    
// MARK: -
    /// Functions that modify Strings.
    struct STRINGS {
        func formatAmount(value:Decimal, rightAlined:Bool? = false, countryCode:String? = "US") -> String {
            let amt = NSNumber(value: value.doubleValue)
            var formattedAmt:String = NumberFormatter.currency(Localize: false, CountryCode:countryCode!).string(from: amt) ?? "0.00"
                formattedAmt = formattedAmt.uppercased()
            
            return rightAlined! ?"\u{200E}\( formattedAmt )" :"\( formattedAmt )"
        }

        func formatAmountByCurrencyCode(code:String, amount:Decimal, rightAlined:Bool) -> String {
            let amt = NSNumber(value: amount.doubleValue)
            var formattedAmt:String = NumberFormatter.currencyForCode(code: code, showSymbol: true).string(from: amt) ?? "0.00"
                formattedAmt = formattedAmt.uppercased()
            
            return rightAlined ?"\u{200E}\(formattedAmt)" :"\(formattedAmt)"
        }
        
        func decimalPlacesExceeded(string:String, decimalPlaces:Int) -> Bool {
            let existingTextHasDecimalSeparator = string.range(of: ".")
            
            if existingTextHasDecimalSeparator != nil {
                let numPlaces:Int = string.distance(from: existingTextHasDecimalSeparator!.upperBound, to: string.endIndex)
                return (numPlaces > decimalPlaces)
            }
        
            return false
        }
        
        func alreadyContainsDecimalPoint(currentString:String,newString:String) -> Bool {
            let existingTextHasDecimalSeparator = self.containsDecimalPoint(string: currentString)
            let replacementTextHasDecimalSeparator = self.containsDecimalPoint(string: newString)
            
            return (existingTextHasDecimalSeparator && replacementTextHasDecimalSeparator)
        }
        
        func containsDecimalPoint(string:String) -> Bool {
            let existingTextHasDecimalSeparator = string.range(of: ".")
            
            return existingTextHasDecimalSeparator != nil
        }
        
        func removeAllNonNumericChars(string:String) -> String {
            return String(string.filter { "01234567890.".contains($0) })
        }

        func formatAsNumber(string:String,decimalPlaces:Int) -> String {
            var sText = self.removeAllNonNumericChars(string:string)
            if sText.isEmpty { sText = "0.00" }
            
            return NumberFormatter.decimal(numPlaces: decimalPlaces).string(from: NSNumber(value: Double(sText)!))!
        }
        
        func formatAsCurrency(string:String) -> String {
            var sText = self.removeAllNonNumericChars(string:string)
            if sText.isEmpty { sText = "0.00" }

            return NumberFormatter.currency().string(from: NSNumber(value: Double(sText)!))!
        }
        
        func returnTableIndexArrayFromStringOfChars(sChars:String) -> [String] {
            var sNewChar:String
            var marrChars:[String] = []
            for i in 0..<sChars.length {
                sNewChar = (sChars as NSString).substring(with: NSMakeRange(i,1))
                marrChars.append(sNewChar)
            }
            
            return marrChars
        }

        func stripZipCodeFormatting(text:String) -> String {
            return String(text.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        }
        
        /// Format Zip Code by Country format
        func formatZipCode(text:String, countryCode:String) -> String {
            var formattedString:String = ""
            let strippedValue:String = stripZipCodeFormatting(text: text)
            let length = strippedValue.length
            
            switch countryCode.uppercased() {
            case "CA":// X#X #X#
                switch length {
                    case 0: formattedString = ""
                    case 1...3: formattedString = "\(strippedValue)"
                    case 4...6: formattedString = "\(strippedValue[0..<3]) \(strippedValue[3..<length])"
                    default: formattedString = "\(strippedValue)"
                }
            case "US"://#####-####
                switch length {
                case 0: formattedString = ""
                case 1...5: formattedString = "\(strippedValue)"
                case 6...9: formattedString = "\(strippedValue[0..<5])-\(strippedValue[5..<length])"
                default: formattedString = "\(strippedValue)"
                }
            default://#####-#### (US)
                switch length {
                case 0: formattedString = ""
                case 1...5: formattedString = "\(strippedValue)"
                case 6...9: formattedString = "\(strippedValue[0..<5])-\(strippedValue[5..<length])"
                default: formattedString = "\(strippedValue)"
                }
            }
            
            return formattedString
        }
        
        func stripPhoneNumFormatting(text:String) -> String {
            return String(text.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        }
        
        func formatPhoneNumTextWithAreaCode(text:String) -> String {
            var formattedString:String = ""
            let strippedValue:String = sharedFunc.STRINGS().stripPhoneNumFormatting(text: text)
            let length = strippedValue.length
            
            switch length { // ###-####, (###) ###-####, +# (###) ###-####
                case 0: formattedString = ""
                case 1...3: formattedString = "\(strippedValue)"
                case 4...7: formattedString = "(\(strippedValue[0..<3])) \(strippedValue[3..<length])"
                case 7...10: formattedString = "(\(strippedValue[0..<3])) \(strippedValue[3..<6])-\(strippedValue[6..<length])"
                case 11...11: formattedString = "+\(strippedValue[0..<1]) (\(strippedValue[1..<4])) \(strippedValue[4..<7])-\(strippedValue[7..<length])"
                default: formattedString = "\(strippedValue)"
            }

            return formattedString
        }
        
        func buildAddress(
                Name:String,
                Addr1:String,
                Addr2:String,
                City:String,
                State:String,
                Zip:String,
                Country:String,
                MultiLine:Bool,
                ZipOnSepLine:Bool? = true
            ) -> String {

            var Address:String = ""

            if Name.isNotEmpty { Address += "\(Name)\(MultiLine ?"\n" :" ∙ ")" }
            if Addr1.isNotEmpty { Address += "\(Addr1)\(MultiLine ?"\n" :" ∙ ")" }
            if Addr2.isNotEmpty { Address += "\(Addr2)\(MultiLine ?"\n" :" ∙ ")" }
            
            if City.isNotEmpty && State.isNotEmpty {
                Address += "\(City), \(State)"
            }else{
                if City.isNotEmpty { Address += "\(City)" }
                if State.isNotEmpty { Address += "\(State)" }
            }

            if Zip.isNotEmpty || Country.isNotEmpty {
                Address += "\(MultiLine ? (ZipOnSepLine!) ?"\n" :" " :" ∙ ")"
            }
            
            if Zip.isNotEmpty && Country.isNotEmpty {
                Address += "\(Zip) \(returnCodeForCountry(country: Country))"
            }else{
                if Zip.isNotEmpty {
                    Address += "\(Zip)"
                }
                if Country.isNotEmpty {
                    Address += " \(returnCodeForCountry(country: Country))"
                }
            }
            
            return Address
        }

        func formatSSN(SSN currentString:String, CountryCode:String) -> String {
            var strippedValue:String = ""
            var formattedString:String = ""

            strippedValue = currentString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
            let length = strippedValue.length
            
            if CountryCode.uppercased() == "USA" {
                switch length {
                    case 0: formattedString = ""
                    case 1...3: formattedString = "\(strippedValue)"
                    case 4...6: formattedString =  "\(strippedValue[0..<3])-\(strippedValue[3..<length])"
                    case 6...9: formattedString = "\(strippedValue[0..<3])-\(strippedValue[3..<5])-\(strippedValue[5..<length])"
                    default: formattedString = "\(strippedValue)"
                }
            }else if CountryCode.uppercased() == "CA" {
                switch length {
                    case 0: formattedString = ""
                    case 1...3: formattedString = "\(strippedValue)"
                    case 4...6: formattedString =  "\(strippedValue[0..<3])-\(strippedValue[3..<length])"
                    case 7...9: formattedString = "\(strippedValue[0..<3])-\(strippedValue[3..<6])-\(strippedValue[6..<length])"
                    default: formattedString = "\(strippedValue)"
                }
            }

            return formattedString
        }
        
        /// - parameter value: (String) Credit Card Number
        /// - parameter format: (Int) Credit Card Format In
        /// - parameter spacerWidth: (Int) Space between number groups
        /// - parameter Protected: (Bool) Show * characters instead of actual ones.
        /// - returns: (Bool) if string contains invalid characters.
        func formatCreditCard(numString:String, format:creditCardTypes, spacerWidth:Int, Protected:Bool? = false) -> String {
            var val:String = numString.trimSpaces
            var length = 0
            
            switch format {
                case .amex: length = 15 // #### ###### #####
                case .discover,.mastercard,.visa: length = 16 // #### #### #### ####
            }
            
            if val.length > 0 {
                var group1:String = ""
                var group2:String = ""
                var group3:String = ""
                var group4:String = ""
                var spacer:String = ""

                /* Pad val with spaces */
                repeat {
                    val = "\(val) "
                } while val.length <= length
                
                spacer = " ".repeatNumTimes(spacerWidth)

                /* Parse val into groups */
                group1 = Protected!.isFalse ?val[0..<4] :"•".repeatNumTimes(4)
                switch format {
                    case .amex: // #### ###### #####
                        group2 = Protected!.isFalse ?val[4..<10] :"•".repeatNumTimes(6)
                        group3 = val[10..<length]
                        return "\(group1)\(spacer)\(group2)\(spacer)\(group3)".trimSpaces
                    default: // #### #### #### ####
                        group2 = Protected!.isFalse ?val[4..<8] :"•".repeatNumTimes(4)
                        group3 = Protected!.isFalse ?val[8..<12] :"•".repeatNumTimes(4)
                        group4 = val[12..<length]
                        return "\(group1)\(spacer)\(group2)\(spacer)\(group3)\(spacer)\(group4)".trimSpaces
                }
            }else{
                return ""
            }
        }

        /// - parameter key: (String) Key name
        /// - parameter charSet: (String) valid Characters
        /// - returns: (Bool) if string contains invalid characters.
        func containsValidCharacters(text:String,charSet:String) -> Bool {
            let characterSet:CharacterSet = CharacterSet(charactersIn: charSet)
            let range = text.rangeOfCharacter(from: characterSet)
            if let _ = range {
                return true
            }else{
                return false
            }
        }
        
        /// returns apostrophe's replaced with double apostrophe's.
        ///
        /// - parameter key: (String) Key name
        /// - returns: (String) Apostrophe's replaced with double apostrophe's.
        func replaceApostrophes(string:String) -> String {
            return string.replacingOccurrences(of: "'",with:"''")
        }

        /// returns Double-Apostrophe's replaced with apostrophe.
        ///
        /// - parameter key: (String) Key name
        /// - returns: (String) Double-Apostrophe's replaced with apostrophe.
        func stripDoubleApostrophes(string:String) -> String {
            return string.replacingOccurrences(of: "''",with:"'")
        }
        
        func returnFormattedBytes(bytes:UInt64, style:ByteCountFormatter.CountStyle) -> String {
            var stringVal:String = ByteCountFormatter().formatWith(units: .useGB, style: style).string(fromByteCount: Int64(bytes))
                stringVal = stringVal[0..<stringVal.length - 3].trimSpaces
                stringVal = stringVal.removeSpaces
                stringVal = stringVal.replacingOccurrences(of: ",", with: "")
            let val:Double = Double(stringVal) ?? 0.00
            if val >= 1000.00 {
                return ByteCountFormatter().formatWith(units: .useTB, style: style).string(fromByteCount: Int64(bytes))
            }else if val < 1.00 {
                return ByteCountFormatter().formatWith(units: .useMB, style: style).string(fromByteCount: Int64(bytes))
            }else {
                return ByteCountFormatter().formatWith(units: .useGB, style: style).string(fromByteCount: Int64(bytes))
            }
        }
    }

// MARK: -
    /// Functions that relate to UITabBarController.
    struct TAB {
        /// - returns: (Int) Index of tab name (must be exact spelling) searched for
        ///
        /// ie: let tabNum:Int = sharedFunc.TAB().indexOfTabNamed("About",self.tabBarController)
        ///
        /// - parameter tabName: (String) as tab name (case insensitive)
        /// - parameter tabBarController: (UITabBarController)
        /// - parameter switchToTab: (Bool) if true, switch to the named tab as selected index.
        @discardableResult func indexOfTabNamed(tabName:String, tabBarController:UITabBarController, switchToTab:Bool) -> Int {
            let tabBar:UITabBar! = tabBarController.tabBar
            
            var iTab:Int = 0
            for item:UITabBarItem in tabBar.items! {
                if item.title != nil {
                    if item.title?.uppercased() == tabName.uppercased() {
                        break
                    }
                }
                
                iTab += 1
            }
            
            let iNumTabs:Int! = tabBarController.viewControllers!.count - 1 // zero-based array
            let selectectedTabNum = (iTab > iNumTabs) ?iNumTabs :iTab
            
            if switchToTab.isTrue {
                tabBarController.selectedIndex = selectectedTabNum!
            }
            
            return selectectedTabNum!
        }

        /// - parameter tabName: (String) as tab name (case insensitive)
        /// - parameter tabBarController: (UITabBarController)
        /// - parameter value: (UITabBarController)
        /// - returns: (Int) Index of tab name (must be exact spelling) searched for
        func badgeTabNamed(tabName:String, tabBarController:UITabBarController, value:Int) -> Void {
            let tabBar = tabBarController.tabBar
            let items:[UITabBarItem] = tabBar.items!

            var tabNum:Int = 0
            if let viewControllers = tabBarController.viewControllers {
                for VC in viewControllers {
                    let title = VC.title ?? ""
                    
                    if title.isNotEmpty {
                        if title.uppercased() == tabName.uppercased() {
                            break
                        }
                    }
                    
                    tabNum += 1
                }
                
                let tabItem:UITabBarItem! = items[tabNum]
                    tabItem.badgeValue = "\(value)"
            }
        }
    }

// MARK: -
    /// Functions that relate to text input.
    struct TEXT {
        /// Use as: do { try sharedFunc.TEXT().DataEntry_Length(length,max: 9) } catch { return false }
        func DataEntry_Length(length:Int,max:Int) throws {
            guard length <= max else {
                if isSimDevice.isFalse { sharedFunc.AUDIO().vibratePhone() }
                throw DataEntryIssue.tooLong
            }
        }
        
        /// Use as: do { try sharedFunc.TEXT().DataEntry_InvalidChars(string,charSet:kCharSet.VALID_CHARS_Numbers) } catch { return false }
        func DataEntry_InvalidChars(text:String,charSet:String) throws {
            guard let _ = text.rangeOfCharacter(from: CharacterSet.init(charactersIn: charSet)) else {
                if isSimDevice.isFalse { sharedFunc.AUDIO().vibratePhone() }
                throw DataEntryIssue.invalidChar
            }
        }
    }
    
// MARK: -
    /// Functions that relate to GCC/Threads.
    struct THREAD {
        /// Swift 5.1+ accessor
        func doAfter(delay:Double, perform:@escaping ()->()) {
            doAfterDelay(delay: delay, perform:perform)
        }

        /// - parameter delay: (String)
        /// - parameter PerformTheFollowing: (Closure) Must be a bracketed set of source code to execute.
        /// - returns: Main Queue thread delay param to perform action(s) passed as PerformTheFollowing param.
        func doAfterDelay(delay:Double, perform:@escaping ()->()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                perform()
            }
        }

        func doNothingFor(seconds: Double) {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            }
        }

        /// - parameter delay: (String)
        /// - parameter PerformTheFollowing: (Closure) Must be a bracketed set of source code to execute.
        /// - returns: Background Queue thread delay param to perform action(s) passed as PerformTheFollowing param.
        func doInBackgroundAfterDelay(delay:Double, perform:@escaping ()->()) {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay) {
                perform()
            }
        }

        /// - parameter PerformTheFollowing: (Closure) Must be a bracketed set of source code to execute.
        /// - returns: Main Queue thread to perform action(s) passed as PerformTheFollowing param.
        func doNow(perform:@escaping ()->()) {
            DispatchQueue.main.async {
                perform()
            }
        }

        /// - parameter PerformTheFollowing: (Closure) Must be a bracketed set of source code to execute.
        /// - returns: Background Queue thread to perform action(s) passed as PerformTheFollowing param.
        func doInBackground(perform:@escaping ()->()) {
            DispatchQueue.global(qos: .background).async {
                perform()
            }
        }
    }
    
// MARK: -
    /// Functions that relate to UITableView.
    struct TABLE {
        /// - parameter chars: (String)
        /// - returns: (NSArray) array of characters in Index
        func returnTableIndexArrayFromStringOfCharacters(chars:String) -> NSArray {
            var sNewChar:String!
            let marrChars:NSMutableArray! = NSMutableArray()
            for i in 0..<chars.count {
                sNewChar = (chars as NSString).substring(with: NSMakeRange(i,1))
                marrChars.add(sNewChar ?? "")
            }
            
            return NSArray(array: marrChars)
        }
    }
    
// MARK: -
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

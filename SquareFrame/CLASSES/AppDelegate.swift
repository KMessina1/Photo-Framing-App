/*--------------------------------------------------------------------------------------------------------------------------
   File: AppDelegate.swift
 Author: Kevin Messina
Created: January 23, 2016
Modified: Apr 4, 2018

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
2018-04-04 - Migrated from Moltin.
2016-09-19 - Converted to Swift
--------------------------------------------------------------------------------------------------------------------------*/

import Siren
import Alamofire
//import OAuthSwift


// MARK: - *** GLOBAL CONSTANTS ***


// MARK: - *** APPLICATION ***
@UIApplicationMain
class AppDelegate:
    UIResponder,
    UIApplicationDelegate,
    UITabBarControllerDelegate,
    UIPopoverPresentationControllerDelegate
{
    var window:UIWindow?
    var shortcutItem:UIApplicationShortcutItem?
    let AppEdition:String! = appInfo().getEdition()

    /* Slidemenu ViewControllers */
    var mainVC:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_Home") as! VC_Home
    var leftVC:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_LeftMenu") as! VC_LeftMenu
    var rightVC:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_ShoppingCart") as! VC_ShoppingCart
    let vc1:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_frameGallery") as! VC_frameGallery
    let vc2:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_getStarted") as! VC_getStarted
    let vc3:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_Orders") as! VC_Orders
    let vc4:UIViewController = gBundle.instantiateViewController(withIdentifier: "VC_Account") as! VC_Account
    let splashScreen_Adhoc = UIStoryboard(name:"SF_AdHoc",bundle:nil).instantiateViewController(withIdentifier: "LaunchView")
    let splashScreen_Release = UIStoryboard(name:"SF_AppStore",bundle:nil).instantiateViewController(withIdentifier: "LaunchView")

// MARK: - *** INITIALIZATION ***
    
// MARK: - *** APPLICATION SHORTCUT ***
    func setupShortcuts() {
        UIApplication.shared.shortcutItems?.removeAll()
        for i in 0..<appInfo.SHORTCUTS.imageNames.count {
            UIApplication.shared.shortcutItems?.append(
                UIApplicationShortcutItem(
                    type: "Open_\(i + 1)",
                    localizedTitle: appInfo.SHORTCUTS.titles[i],
                    localizedSubtitle: appInfo.SHORTCUTS.subTitles[i],
                    icon: UIApplicationShortcutIcon(templateImageName: appInfo.SHORTCUTS.imageNames[i]),
                    userInfo: nil
                )
            )
        }
    }
    
    enum ShortcutIdentifier:String { case Open_1,Open_2,Open_3,Open_4
        init?(fullIdentifier: String) {
            guard let shortIdentifier = fullIdentifier.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: shortIdentifier)
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler:@escaping (Bool) -> Void) {
        if let shortcutIdentifier = ShortcutIdentifier(fullIdentifier: shortcutItem.type) {
            var menuIndex:Int = 0
            let isToolbar:Bool = (self.window?.rootViewController is UITabBarController)
            let tabbarController:UITabBarController? = self.window?.rootViewController as? UITabBarController
            if (tabbarController != nil) {
                tabbarController?.delegate = self
            }
            
            switch shortcutIdentifier {
            case .Open_1: menuIndex = 0
            case .Open_2: menuIndex = 1
            case .Open_3: menuIndex = 2
            case .Open_4: menuIndex = 3
            }
            
            if isToolbar {
                tabbarController?.selectedIndex = appInfo.SHORTCUTS.tabIndeces[menuIndex]
            }else{
                self.window?.rootViewController = appInfo.SHORTCUTS.VCs[menuIndex]
            }
            
            completionHandler(true)
            return
        }
        
        completionHandler(false)
    }

    
// MARK: - *** INITIALIZE ***
    func setup_InitializeApp() {
        alert_ShowAsAppleStandard = true
        isBetaTest = false //ToDo: ⚠️ Set to False before production
        showSimMsgs = true //false

        /* Initialize Globals */
        if isFirstLaunchAfterUpdate().isTrue { updateResetNeeded() }
        updateDatabaseIfNeeded()
        gSender = SENDER_INFO()
        
        /* Initialize Settings */
        let prefs = UserDefaults.standard
// MARK: ├─➤ Set BOOL
        let boolItems:[String:Bool] = [
            prefKeys.infoOverlay.hasShown:false
        ]
        
        for item in boolItems {
            let key:String! = item.0
            let value:Bool! = item.1
            
            let itemExists:AnyObject! = prefs.object(forKey: key) as AnyObject? ?? nil
            if (itemExists == nil) {
                prefs.set(value, forKey: key)
            }
        }

// MARK: ├─➤ Set STRINGS
        let stringItems:[String:String] = [:]
        
        for item in stringItems {
            let key:String! = item.0
            let value:AnyObject! = item.1 as AnyObject
            
            let itemExists:AnyObject! = prefs.object(forKey: key) as AnyObject? ?? nil
            if (itemExists == nil) {
                prefs.set(value, forKey: key)
            }
        }
        
// MARK: ├─➤ Set INTEGER
        let integerItems:[String:Int] = [:]
        for item in integerItems {
            let key:String! = item.0
            let value:Int! = item.1
            
            let itemExists:AnyObject! = prefs.object(forKey: key) as AnyObject
            if (itemExists == nil) {
                prefs.set(value, forKey: key)
            }
        }

// MARK: ├─➤ Set DOUBLE
        let doubleItems:[String:Double] = [:]
        for item in doubleItems {
            let key:String! = item.0
            let value:Double! = item.1
            
            let itemExists:AnyObject! = prefs.object(forKey: key) as AnyObject? ?? nil
            if (itemExists == nil) {
                prefs.set(value, forKey: key)
            }
        }

        prefs.synchronize()
    }

    func copyNeededFiles(completion: @escaping (Bool) -> Void) {
        // App
        copyFilesToFolderFromBundleIfNeeded(toUrl:cachedImgs.APP.url,filterBy:"homeScreen",showMsg:false)
        copyFilesToFolderFromBundleIfNeeded(toUrl:cachedImgs.APP.url,filterBy:"leftMenu",showMsg:false)
        copyFilesToFolderFromBundleIfNeeded(toUrl:cachedImgs.APP.url,filterBy:"shoppingCart",showMsg:false)
        // Carousel
        copyFilesToFolderFromBundleIfNeeded(toUrl:cachedImgs.FRAMES.carousel.url,filterBy:"Rectangle_",showMsg:false)
        copyFilesToFolderFromBundleIfNeeded(toUrl:cachedImgs.FRAMES.carousel.url,filterBy:"Square_",showMsg:false)
        // Gallery
        copyFilesToFolderFromBundleIfNeeded(toUrl:cachedImgs.FRAMES.gallery.url,filterBy:"frameGallery",showMsg:false)
        
        /* Verify all photos are copied before completion handler fired */
        var allFilesCopied:Bool = true
        var counter:Int = 0
        let FM = FileManager.default
        repeat {
            for filename in ["homeScreen.jpg","leftMenu.jpg","shoppingCart.jpg"] {
                if sharedFunc.FILES().exists(filePathAndName: "\( cachedImgs.APP.path )/\( filename )").isFalse {
                    allFilesCopied = false
                }
            }

            var bundlefiles = try? FM.contentsOfDirectory(atPath: cachedImgs.FRAMES.carousel.path)
                bundlefiles = bundlefiles?.filter({ !$0.contains(".DS_Store") })
            var bundleFilenames = bundlefiles ?? []
                bundleFilenames.sort(by: { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending })

            for filename in bundleFilenames {
                if sharedFunc.FILES().exists(filePathAndName: "\( cachedImgs.FRAMES.carousel.path )/\( filename )").isFalse {
                    allFilesCopied = false
                }
            }

            bundlefiles = try? FM.contentsOfDirectory(atPath: cachedImgs.FRAMES.gallery.path)
            bundlefiles = bundlefiles?.filter({ !$0.contains(".DS_Store") })
            bundleFilenames = bundlefiles ?? []
            bundleFilenames.sort(by: { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending })
            
            for filename in bundleFilenames {
                if sharedFunc.FILES().exists(filePathAndName: "\( cachedImgs.FRAMES.gallery.path )/\( filename )").isFalse {
                    allFilesCopied = false
                }
            }

            counter += 1
            if ((counter >= 10) && (allFilesCopied == false)) {
                sharedFunc.THREAD().doNow {
                    sharedFunc.ALERT().show(
                        title:"Copy.Failed_Title".localized(),
                        style:.error,
                        msg:"Copy.Failed_Msg".localized()
                    )
                }
                break
            }
        } while ((counter < 10) && (allFilesCopied == false))

        completion(true)
    }

    func updateDatabaseIfNeeded() -> Void { }

// MARK: - *** APPEARANCE ***
    func setup_AppearanceProxies() -> Void {
        var fontName:String = (APPFONTS().menuTitles?.fontName)!
        var fontSize:CGFloat = (APPFONTS().menuTitles?.pointSize)!
        var font:UIFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        /* UIAlert Color */ // Inherits from Main window color.
       window?.tintColor = gAppColor
        
        /* UIButton */
        UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).font = font
        
        /* UISegmentedControl */
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).font = font
        
        /* UIBarButtonItem */
        fontName = (APPFONTS().barButtonTitles?.fontName)!
        fontSize = (APPFONTS().barButtonTitles?.pointSize)!
        font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let style:NSMutableParagraphStyle! = NSMutableParagraphStyle.init()
            style.lineBreakMode = .byWordWrapping
        let attribs:[NSAttributedString.Key:Any] = [
            .font: font,
            .paragraphStyle: style!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(attribs, for: .normal)

        /* UINavBar */
        fontName = (APPFONTS().navBarTitles?.fontName)!
        fontSize = (APPFONTS().navBarTitles?.pointSize)!
        font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).font = font
    }
    

// MARK: - *** FUNCTIONS ***
    func appStoreVersionCheck() {
        let siren = Siren.shared
            siren.rulesManager = RulesManager(globalRules: .annoying)
            siren.presentationManager = PresentationManager(
                alertTintColor: APPTHEME.colors().tint,
                appName: appInfo.EDITION.fullName,
                alertTitle: "Please, Update Now!",
                skipButtonTitle: "Click here to skip!",
                forceLanguageLocalization: (gAppLanguageCode == "es") ?.spanish :.english
            )

        siren.wail(performCheck: .onDemand) { results in
            switch results {
            case .success(let updateResults):
                var msg = "\n************ Appstore Version Check ************\n"
                    msg += "AlertAction: \( updateResults.alertAction )\n"
                    msg += "Localization: \( updateResults.localization )\n"
                    msg += "LookupModel: \( updateResults.model )\n"
                    msg += "UpdateType: \( updateResults.updateType )\n"
                    msg += "************ --------------------- ************\n\n"
                
                simPrint().info(msg, function: #function, line: #line)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setupSlideMenu(defaultVC:UIViewController) {
        /* Set view controllers */
        mainVC = defaultVC

        let slideMenuController = SlideMenuController(mainViewController: mainVC,leftMenuViewController: leftVC,rightMenuViewController: rightVC)
        self.window?.rootViewController = slideMenuController

        SlideMenuOptions.hideStatusBar = false
        
        slideMenuController.changeLeftViewWidth(isPhone ?170 :270)
        slideMenuController.changeRightViewWidth(isPhone ?270 :380)

        SlideMenuOptions.panFromBezel = false  // Stop pan gesture from LEFT
        SlideMenuOptions.rightPanFromBezel = false // Stop pan gesture from RIGHT
        
        slideMenuController.closeLeft() // Forces view further offset so that shadow doesn't appear initially.
        slideMenuController.closeRight() // Forces view further offset so that shadow doesn't appear initially.
    }

    
// MARK: - *** TAB BAR DELEGATE ***
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        simPrint().info("Selected tab# = \( tabBarController.selectedIndex )",function:#function,line:#line)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        simPrint().info("Want to change tab# = \( tabBarController.selectedIndex )",function:#function,line:#line)
        return true
    }
    
    
// MARK: - *** SESSION STATE ***
    func isFirstLaunchAfterUpdate() -> Bool {
        let currentVersion:String = Bundle.main.fullVer
        let lastLaunchVersion:String = UserDefaults.standard.string(forKey: prefKeys.appVersion.lastLaunchVersion) ?? ""
        let firstLaunchAfterUpdate:Bool = lastLaunchVersion != currentVersion

        return firstLaunchAfterUpdate
    }
    
    func updateResetNeeded() {
        appFunc().resetOrderAndcleanupOrderFiles()
        let prefs = UserDefaults.standard
            // Remove persistence data
            prefs.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            prefs.synchronize()
            // Initialize persistence data
            prefs.register(defaults: [String : Any]()) // Needed as init.
            prefs.set("\(Bundle.main.ver) (\(Bundle.main.build))", forKey: prefKeys.appVersion.settingsBundleVersion) // Used in bundle settings.
            prefs.set("\(Bundle.main.fullVer)", forKey: prefKeys.appVersion.lastLaunchVersion)
            prefs.synchronize()

        AppDelegate().initSessionData()
        AppDelegate().loadCurrentSessionData()
    }
    
    func initSessionData() {
        /* Set default params */
        let prefs = UserDefaults.standard
        
        /* Set App Globals */
        gAppLanguage = Languages().getCurrentDeviceLanguage.language
        gAppLanguageCode = Languages().getCurrentDeviceLanguage.languageCode
        if let color = prefs.string(forKey: "Color_Text") {
            appInfo.EDITION.color_Text = color
        }
        gAppColor = UIColor().returnColorForName(grouping: "Crayon", name: appInfo.EDITION.color_Text)
        gAppColorIsLight = gAppColor.isLight()
    }
    
    func loadCurrentSessionData(){
        if tempItem == nil {
            tempItem = TempItem.init()
            tempItem.size = 0
            tempItem.color = 0
            tempItem.format = 0
        }

        if isFirstLaunchAfterUpdate().isTrue { updateResetNeeded() }

        if let customerData = UserDefaults.standard.data(forKey: prefKeys.Archive.customerInfo),
           let storedCustomer = try? JSONDecoder().decode(CustomerInfo.self, from: customerData) {
            customerInfo = storedCustomer
            if customerInfo.email.isEmpty {
                appFunc.keychain.MYINFO().get()
            }
            simPrint().info("\( dump(customerInfo)! )",function:#function,line:#line)
        }else{
            appFunc.keychain.MYINFO().get()
        }

        if let cartData = UserDefaults.standard.data(forKey: prefKeys.Archive.localCartInfo),
           let storedCart = try? JSONDecoder().decode(LocalCart.self, from: cartData) {
            localCart = storedCart
            simPrint().info("\( dump(localCart)! )",function:#function,line:#line)
        }else{
            localCart = LocalCart.init()
            localCart.empty()
            CMS_cart = Cart.init()
            CMS_item = Orders.itemStruct.init()
        }

        if let orderData = UserDefaults.standard.data(forKey: prefKeys.Archive.orderInfo),
           let storedOrder = try? JSONDecoder().decode(Orders.orderStruct.self, from: orderData) {
            order = storedOrder
            simPrint().info("\( dump(order) )",function:#function,line:#line)
        }else{
            order = Orders.orderStruct.init()
            localCart = LocalCart.init()
            localCart.empty()
            CMS_cart = Cart.init()
            CMS_item = Orders.itemStruct.init()
        }
        
        if let ccData = UserDefaults.standard.data(forKey: prefKeys.Archive.creditCard),
           let storedCC = try? JSONDecoder().decode(CREDITCARD.creditCARD.self, from: ccData) {
            selectedPayment = storedCC
            simPrint().info("\( dump(selectedPayment) )",function:#function,line:#line)
        }else{
            selectedPayment = CREDITCARD.creditCARD.init()
            selectedCoupon = Coupons.couponStruct.init()
        }
        
        if let selectedPhotoData = UserDefaults.standard.data(forKey: prefKeys.Archive.photosInfo),
           let storedPhoto = try? JSONDecoder().decode(SelectedPhoto.self, from: selectedPhotoData) {

            selectedPhoto = storedPhoto
            simPrint().info("\( dump(selectedPhoto)! )",function:#function,line:#line)
        }else{
            appFunc.keychain.SELECTED_PHOTO().get()
            if selectedPhoto == nil || selectedPhoto.filename.isEmpty {
                selectedPhoto = SelectedPhoto.init()
                appFunc.keychain.SELECTED_PHOTO().save()
            }
        }
        
        /* Force attempt to load selected photo or reset it */
        if sharedFunc.FILES().exists(filePathAndName: selectedPhotoFilepath).isTrue {
            let tempImg = UIImage(contentsOfFile: selectedPhotoFilepath) ?? nil
            if tempImg == nil {
                simPrint().info("SelectedPhoto didn't load...", function: #function, line: #line)
                selectedPhoto = SelectedPhoto.init()
                appFunc.keychain.SELECTED_PHOTO().save()
            }
        }else{
            selectedPhoto = SelectedPhoto.init()
            appFunc.keychain.SELECTED_PHOTO().save()
        }
    }
    
    func saveCurrentSessionData(){
        let prefs = UserDefaults.standard

        prefs.set(Bundle.main.fullVer, forKey: prefKeys.appVersion.lastLaunchVersion)

        if let encoded = try? JSONEncoder().encode(customerInfo) {
            prefs.set(encoded, forKey: prefKeys.Archive.customerInfo)
        }
        
        if let encoded = try? JSONEncoder().encode(localCart) {
            prefs.set(encoded, forKey: prefKeys.Archive.localCartInfo)
        }

        if let encoded = try? JSONEncoder().encode(order) {
            prefs.set(encoded, forKey: prefKeys.Archive.orderInfo)
        }
        
        if let encoded = try? JSONEncoder().encode(selectedPayment) {
            prefs.set(encoded, forKey: prefKeys.Archive.creditCard)
        }
        
        if isSimDevice { Server().dumpParams(selectedPhoto.allProperties, scriptName: "APP_DELEGATE: Save()") }
        if let encoded = try? JSONEncoder().encode(selectedPhoto) {
            prefs.set(encoded, forKey: prefKeys.Archive.photosInfo)
        }
        
        appFunc.keychain.SELECTED_PHOTO().save()
        
        prefs.synchronize()
    }
    

// MARK: - *** NOTIFICATIONS ***
    
    
// MARK: - *** LIFECYCLE ***
//    func application(_ app:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey:Any] = [:]) -> Bool {
//        if (url.host == "oauth-callback") {
//            OAuthSwift.handle(url: url)
//        }
//        
//        return true
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /* Setup current window NOTE: Must be prior to any alerts or messages being displayed */
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        gBundle = UIStoryboard.init(name: "Main", bundle: nil)

        /* Force .light/.dark mode regardless of system setting */
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        /* Splash screen */
        self.setupSlideMenu(defaultVC: sharedFunc.APP().isAdhocMode() ?splashScreen_Adhoc :splashScreen_Release) // Setup Rootview as SliderMenu for Splashscreen

        /* Initialize */
        sharedFunc.THREAD().doAfterDelay(delay: 3) { // Splash Delay
            gAppEdition = appInfo().getEdition()
            sharedFunc.APP().showInfo()
            self.initSessionData()
            self.loadCurrentSessionData()
            self.setup_InitializeApp()
            self.setup_AppearanceProxies()
            self.setupShortcuts()

            /* Appstore */
            self.appStoreVersionCheck() //To test, enter "com.apple.itunesconnect.mobile" as Bundle ID
            sharedFunc.RATEAPP().incrementAppRuns(forceShowForTest:false)
            
            /* App Specific */
            AppImages().getPhotos()
            FrameGallery().getPhotos()
            FrameCarousel().getPhotos()
            appFunc.keychain.MYINFO().get()
            EmailAddresses().list { (success, emailAddresses, error) in }
            CREDITCARD().setupStripe()
            CREDITCARD().setupStripeTheme()

            Frames().loadComponents { (finished) in
                self.copyNeededFiles { (finished) in
                    self.setupSlideMenu(defaultVC: gBundle.instantiateViewController(withIdentifier: "VC_Home") as! VC_Home)
                }
            }
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        /* Restore session */
        if isFirstLaunchAfterUpdate().isTrue { updateResetNeeded() }
        loadCurrentSessionData()

        appStoreVersionCheck()

        guard let _ = shortcutItem else { return }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveCurrentSessionData()
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        NSLog("Memory Warning Issued")
    }

    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveCurrentSessionData()
    }
}

//extension AppDelegate {
//    func applicationHandleOpenURL(_ url:URL) {
//        if (url.host == "oauth-callback") {
//            if isSim { print("Passed: Host") }
//            OAuthSwift.handle(url: url)
//            if isSim { print("Passed: HandleOpenURL") }
//        } else {
//            OAuthSwift.handle(url: url)
//        }
//    }
//}

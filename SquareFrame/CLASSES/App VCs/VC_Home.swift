/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_Home.swift
 Author: Kevin Messina
Created: February 16, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***


class VC_Home:
    UIViewController,
    UIPopoverPresentationControllerDelegate
{

// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }
    
    func updateCartCount() {
        let itemCount:Int = (localCart != nil) ?localCart.itemCount :0
        let cartHasItems:Bool = (itemCount > 0)
        let img:UIImage =  isPad
            ?cartHasItems ?#imageLiteral(resourceName: "Cart_LG") :#imageLiteral(resourceName: "Empty_LG")
            :cartHasItems ?#imageLiteral(resourceName: "Cart") :#imageLiteral(resourceName: "EmptyCart")

        lbl_CartCount.text = cartHasItems ?"\( itemCount )" :""
        btn_Cart.setImage(img.recolor(gAppColor), for: .normal)
    }
    
    
// MARK: - *** ACTIONS ***
    @IBAction func viewCart(_ sender:UIButton){
        slideMenuController()?.toggleRight()
    }
    
    @IBAction func getStarted(_ sender:UIButton){
        let Photos = gBundle.instantiateViewController(withIdentifier: "VC_getStarted") as! VC_getStarted
        slideMenuController()?.changeMainViewController(Photos, close: true)
    }
    
    @IBAction func showMenu(_ sender:UIButton){
        slideMenuController()?.toggleLeft()
    }


// MARK: - *** NOTIFICATIONS ***
    @objc func notification_ShowOrderPlaced(_ sender: Notification) {
        if let UserInfo = sender.userInfo?["OrderInfo"] as? NSDictionary {
            let title = UserInfo["title"] as? String ?? ""
            let msg = UserInfo["msg"] as? String ?? ""
            let filepath_Order = UserInfo["url"] as? String ?? ""
            let filename = filepath_Order.lastPathComponent
            var showErrorMsg = false

            if !sharedFunc.FILES().exists(filePathAndName: filepath_Order) {
                showErrorMsg = true
            }else{
                guard
                    let fileURL = URL(fileURLWithPath: filepath_Order) as URL?
                else {
                    sharedFunc.ALERT().showFileNotFound(filename: filename)
                    return
                }

                simPrint().info("PDF PATH: \( fileURL )")
                simPrint().info("PDF FILE: \( filename )")
            
                waitHUD().showNow(msg: "Loading PDF...")
                let childVC = UIStoryboard(name:"PDFViewer",bundle:nil)
                    .instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                childVC.pdfURL = fileURL

                self.present(childVC, animated: false)
            }
            
            waitHUD().hideNow()
            
            if showErrorMsg {
                sharedFunc.ALERT().show(title: title,style:.error,msg: msg)
            }
        }
    }
    
    @objc func notification_CartCount(_ sender: Notification) {
        updateCartCount()
    }
    
    @objc func notification_showMenu(_ sender: Notification) {
        showMenu(btn_Menu)
    }
    
    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return false }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /* Appearance */
        sharedFunc.DRAW().roundCorner(view: btn_Start, radius: 10)
        sharedFunc.DRAW().addShadow(view: btn_Start, offsetSize: CGSize(width:3,height:3), radius: 3, opacity: 0.66)
        btn_Start.backgroundColor = gAppColor
        let fontName:String = (APPFONTS().menuTitles?.fontName)!
        let fontSize:CGFloat = (APPFONTS().menuTitles?.pointSize)!
        btn_Start.titleLabel?.font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)

        img_PhotoBackground.alpha = kAlpha.opaque
        img_PhotoBackground.isOpaque = true
        img_PhotoBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)

        btn_Menu.setImage(isPad ? #imageLiteral(resourceName: "Menu_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Menu").recolor(gAppColor), for: .normal)
        btn_Cart.setImage(isPad ? #imageLiteral(resourceName: "Cart_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Cart").recolor(gAppColor), for: .normal)

        /* Load Defaults */
        if tempItem == nil {
            tempItem = TempItem()
            tempItem.size = 0
            tempItem.color = 0
            tempItem.format = 0
        }

        if localCart == nil {
            localCart = LocalCart.init()
        }
        
        /* Localization */
        btn_Start.setTitle("Home(\(gAppID))_GetStarted".localized(), for: .normal)
        
        /* Notifications */
        let NC = NotificationCenter.default
            NC.addObserver(self,selector:#selector(notification_showMenu(_:)), name:Notification.Name("notification_showMenu"),object: nil)
            NC.addObserver(self,selector:#selector(notification_CartCount(_:)), name:Notification.Name("notification_CartCount"),object: nil)
            NC.addObserver(self,selector:#selector(notification_ShowOrderPlaced(_:)), name:Notification.Name("notification_ShowOrderPlaced"),object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        /* Appearance */
        self.view.addSubview(addGradientToTopView(view: self.view))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Get latest Shipping Amount & Sales Taxable States */
        getOrderDefaultValues()
        
        /* Load background image */
        let backgroundImgFilePath = cachedImgs.APP.url.appendingPathComponent("homeScreen.jpg").path
        img_PhotoBackground.image = UIImage(contentsOfFile: backgroundImgFilePath)?
            .alpha(value: 0.86)
        
        /* Refresh Cart */
        updateCartCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Force close the keyboard if left hung by user closing or powering off device.
        let txt = UITextField.init()
            txt.isHidden = true
            txt.tag = 98765
        
        self.view.addSubview(txt)
        
        txt.becomeFirstResponder()
        self.view.endEditing(true)
        
        self.view.viewWithTag(98765)?.removeFromSuperview()
    }
    
    // MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet weak var btn_Start:UIButton!
    @IBOutlet weak var lbl_CartCount:UILabel!
    @IBOutlet weak var btn_Cart:UIButton!
    @IBOutlet weak var vw_Topbar:UIView!
    @IBOutlet weak var divider:UILabel!
    @IBOutlet weak var btn_Menu:UIButton!
    @IBOutlet weak var img_PhotoBackground: UIImageView!
    
    // MARK: - *** DECLARATIONS (Variables) ***
}


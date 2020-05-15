/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_Menu.swift
  Author: Kevin Messina
 Created: Apr 21, 2016
Modified: Apr 4, 2018

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
2018-04-04 - Migrated from Moltin.
2016-09-19 - Converted to Swift
--------------------------------------------------------------------------------------------------------------------------*/

import StoreKit

// MARK: - *** GLOBAL CONSTANTS ***

enum LeftMenu: Int { case home,getStarted,frameGallery,accountInfo,orders,faq,contactUs,share,rateApp }

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class VC_LeftMenu:
    UIViewController,
    LeftMenuProtocol,
    UITableViewDelegate,UITableViewDataSource,
    UIActionSheetDelegate,
    UIPopoverPresentationControllerDelegate,
    SKStoreProductViewControllerDelegate
{
    
// MARK: - *** FUNCTIONS ***
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
            case .home: self.slideMenuController()?.changeMainViewController(home, close: true)
            case .getStarted: self.slideMenuController()?.changeMainViewController(getStarted, close: true)
            case .frameGallery: self.slideMenuController()?.changeMainViewController(frameGallery, close: true)
            case .orders: (customerInfo.ID < 1)
                ?self.login()
                :self.slideMenuController()?.changeMainViewController(orders, close: true)
            case .accountInfo: self.slideMenuController()?.changeMainViewController(accountInfo, close: true)
            case .faq: self.slideMenuController()?.changeMainViewController(FAQ, close: true)
            case .contactUs:
                contactUs.font_Title = UIFont(name: (APPFONTS().screenTitles?.fontName)!, size: 32)
                contactUs.font_Text = UIFont(name: (APPFONTS().text_Reg?.fontName)!, size: 15)
                present(contactUs, animated: true)
                slideMenuController()?.closeLeft()
            case .share:
                share.font_Title = UIFont(name: (APPFONTS().text_Light?.fontName)!, size: 28)!
                share.font_Text = UIFont(name: (APPFONTS().text_Thin?.fontName)!, size: 24)!
                present(share, animated: true)
                slideMenuController()?.closeLeft()
            case .rateApp:
                SKStoreReviewController.requestReview()
                slideMenuController()?.closeLeft()
        }
    }

    func login() {
        let alert = UIAlertController(
            title: "SERVER_ORDERS_NONE_TITLE".localized(),
            message: "ExistingCustomer_Msg".localizedCAS(),
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Login".localizedCAS(), style: .default) { (action) -> Void in
            let textInput = (alert.textFields![0] as UITextField).text ?? ""

            Customers().search(showMsg: true, email: textInput) { (success, customerRec, addressRec, error) in
                if success {
                    customerInfo = CustomerInfo.init(
                        ID: customerRec.id,
                        firstName: customerRec.firstName,
                        lastName: customerRec.lastName,
                        email: customerRec.email,
                        phone: customerRec.phone,
                        mailingList: Bool(customerRec.mailingList),
                        address: Customers.address.init(
                            id: addressRec.id,
                            customerID: addressRec.customerID,
                            firstName: addressRec.firstName,
                            lastName: addressRec.lastName,
                            address1: addressRec.address1,
                            address2: addressRec.address2,
                            city: addressRec.city,
                            stateCode: addressRec.stateCode,
                            zip: addressRec.zip,
                            countryCode: addressRec.countryCode,
                            phone: addressRec.phone,
                            email: addressRec.email
                        )
                    )

                    appFunc.keychain.MYINFO().save()

                    self.slideMenuController()?.changeMainViewController(self.orders, close: true)
                }else{
                    sharedFunc.ALERT().show(
                        title:"SERVER.Account.NotFound.title".localized(),
                        style:.error,
                        msg:"SERVER.Account.NotFound.msg".localized().replacingOccurrences(of: "{email}", with: customerInfo.email)
                    )
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel".localizedCAS(), style: .default) { (action) -> Void in
            self.slideMenuController()?.closeLeft()
        }
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email address"
            textField.text = order.customer_email.isEmpty ?"" :order.customer_email
            textField.keyboardAppearance = .dark
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.returnKeyType = .search
            textField.enablesReturnKeyAutomatically = true
            textField.addTarget(alert,action: #selector(alert.textDidChangeInEmailAlert),for: .editingChanged)
        }
        
        action.isEnabled = alert.isValidEmail(order.customer_email)
        action.setValue(action.isEnabled ?"Login".localizedCAS() :"--", forKey: "title")
        action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
        
        cancel.setValue(APPTHEME.alert_ButtonCancel, forKey: "titleTextColor")
        
        /* Appearance */
        alert.view.tintColor = APPTHEME.alert_TintColor
        sharedFunc.DRAW().roundCorner(view: alert.view, radius: 16, color: gAppColor, width: 2.25)

        alert.addAction(cancel)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    
// MARK: - *** ACTIONS ***
    
    
// MARK: - *** TABLES ***
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /* Calculate variable row height */
        var rowHeight = tableView.frame.size.height / CGFloat(menus.count)
        if rowHeight < 22 {
            rowHeight = 22
        }

        /* Disable scrolling if not a lot of rows */
        if (rowHeight * CGFloat(menus.count)) > tableView.frame.size.height {
            tableView.isScrollEnabled = true
        }else{
            tableView.isScrollEnabled = false
        }
        
        return rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
                default:
                    let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                        cell.setData(menus[indexPath.row])
                    
                    return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }


// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.registerCellClass(cellClass: BaseTableViewCell.self)
        
        sharedFunc.DRAW().addShadow(view: self.view, offsetSize: CGSize(width:0,height:5), radius: 5.0, opacity: 1.0)
        sharedFunc.DRAW().addShadow(view: topView, offsetSize: CGSize(width:0,height:2), radius: 2.0, opacity: 0.4)

        /* Load Defaults */
        menus = [
            "Menu_Home".localized(),
            "Menu_GetStarted".localized(),
            "Menu_Frames".localized(),
            "Menu_AccountInfo".localized(),
            "Menu_Orders".localized(),
            "Menu_FAQ".localized(),
            "Menu_Contact Us".localized(),
            "Menu_Share".localized(),
            "Menu_Rate".localized()
        ]

        lblVersion.text = "  \("version".localizedCAS()) \(Bundle.main.fullVer)"
        lblVersion.backgroundColor = gAppColor
        lblVersion.textColor = gAppColor.isLight() ?#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) :#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        /* Notifications */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Appearance */
        SlideMenuOptions.contentViewScale = 1

        let libUrl:URL = cachedImgs.APP.url
            .appendingPathComponent("leftMenu.jpg")
        
        backgroundImage.image = UIImage(contentsOfFile: libUrl.path)?.alpha(value: 0.86) ?? UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        horizontalClass = self.sizeClass().w
        verticalClass = self.sizeClass().h
        
        /* Appearance */
        tableView.separatorColor = gAppColor.withAlphaComponent(0.3)
        tableView.backgroundColor = gAppColor.withAlphaComponent(0.1)

        tableView.reloadData()
    }

    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var tableView:UITableView!
    @IBOutlet var logo:UIImageView!
    @IBOutlet var backgroundImage:UIImageView!
    @IBOutlet var topView:UIView!
    @IBOutlet weak var lblVersion: UILabel!

// MARK: - *** DECLARATIONS (Variables) ***
    var menus:[String] = []
    var home = gBundle.instantiateViewController(withIdentifier: "VC_Home") as! VC_Home
    var getStarted = gBundle.instantiateViewController(withIdentifier: "VC_getStarted") as! VC_getStarted
    var frameGallery = gBundle.instantiateViewController(withIdentifier: "VC_frameGallery") as! VC_frameGallery
    var orders = gBundle.instantiateViewController(withIdentifier: "VC_Orders") as! VC_Orders
    var accountInfo = gBundle.instantiateViewController(withIdentifier: "VC_Account") as! VC_Account
    var FAQ = gBundle.instantiateViewController(withIdentifier: "VC_FAQ") as! VC_FAQ
    var contactUs = UIStoryboard(name:"ContactUs",bundle:nil).instantiateViewController(withIdentifier: "VC_ContactUs") as! VC_ContactUs
    var share = gBundle.instantiateViewController(withIdentifier: "VC_Share") as! VC_Share
}

open class BaseTableViewCell:UITableViewCell {
    class var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
//    open class func height() -> CGFloat {
//        /* Calculate variable row height */
//        var rowHeight = tableView.frame.size.height / CGFloat(menus.count)
//        if rowHeight < 22 {
//            rowHeight = 22
//        }
//
//        /* Disable scrolling if not a lot of rows */
//        if (rowHeight * CGFloat(menus.count)) > tableView.frame.size.height {
//            tableView.isScrollEnabled = true
//        }else{
//            tableView.isScrollEnabled = false
//        }
//
//        return rowHeight
//    }
    
    open func setData(_ data: Any?) {
        var fontSize:CGFloat = (APPFONTS().menuTitles?.pointSize)!
        if horizontalClass == UIUserInterfaceSizeClass.regular {
            fontSize += 15.0
        }
        
        let font:UIFont = UIFont(name: (APPFONTS().menuTitles?.fontName)!, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        self.backgroundColor = .clear
        self.textLabel?.font = font
        self.textLabel?.adjustsFontSizeToFitWidth = true
        self.textLabel?.minimumScaleFactor = 0.5
        self.textLabel?.textColor = gAppColor
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
}

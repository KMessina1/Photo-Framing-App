/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_Account.swift
  Author: Kevin Messina
 Created: Jan 26, 2016
Modified: May 14, 2020

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
2020-05-14 - Migrated from Moltin.
2018-04-04 - Migrated from Moltin.
2016-09-19 - Converted to Swift
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_Account:
    UIViewController,
    UITableViewDataSource,UITableViewDelegate,
    UIPopoverPresentationControllerDelegate
{
    
    // MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    func resetCell(_ sender: CAS_Switch) {
        sender.isOn = false
        let indexPath = IndexPath(row: sections.reset.rawValue, section: 0)
        if let visibleIndexPaths = table.indexPathsForVisibleRows?.firstIndex(of: indexPath) {
            if visibleIndexPaths != NSNotFound {
                table.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    @objc func resetAccount(_ sender: CAS_Switch) {
        let alert = UIAlertController(
            title: "Account.Reset.Alert_Title".localized(),
            message: "Account.Reset.Alert_Msg".localized(),
            preferredStyle: .alert
        )
        
// MARK: ├───➤ RESET PHOTO
        alert.addAction(UIAlertAction(title: "Account.Reset.Alert_Btn_Photo".localized(), style: .destructive) { (action) in
            appFunc().resetOrderAndcleanupOrderFiles()
            sharedFunc.ALERT().show(
                title:"Account.Reset.Alert_ResetPhoto_Title".localized(),
                style:.error,
                msg:"Account.Reset.Alert_ResetPhoto_Msg".localized()
            )
            self.resetCell(sender)
        })

// MARK: ├───➤ RESET ALL
        alert.addAction(UIAlertAction(title: "Account.Reset.Alert_Btn_All".localized(), style: .destructive) { (action) in
            appFunc().resetOrderAndcleanupOrderFiles()
            appFunc().resetKeychainAndSession()
            sharedFunc.ALERT().show(
                title:"Account.Reset.Alert_ResetAll_Title".localized(),
                style:.error,
                msg:"Account.Reset.Alert_ResetAll_Msg".localized()
            )
            self.table.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel".localizedCAS(), style: .cancel) { (action) in
            self.resetCell(sender)
        })
        
        self.present(alert, animated: true)
    }
    
    @objc func getData() {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }

        /* Get Customer Info from email */
        if customerInfo.email.isNotEmpty {
            Customers().search(showMsg: true, email: customerInfo.email) { (success, customerRec, addressRec, error) in
                customerInfo = CustomerInfo.init()

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
                }else{
                    sharedFunc.ALERT().show(
                        title:"SERVER.Account.NotFound.title".localized(),
                        style:.error,
                        msg:"SERVER.Account.NotFound.msg".localized()
                    )
                }
                
                appFunc.keychain.MYINFO().save()
                self.table.reloadData()
            }
        }else{
            appFunc.keychain.MYINFO().get()
            if customerInfo.email.isNotEmpty {
                getData()
            }
            return
        }
    }
    
    @objc func edit_MyInfo() {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable(simulateOff:kSimulateNoInternet,showInfoInsteadOfScreen:true) { return }

        selectedSection = sections.myInfo.rawValue

        let email = customerInfo.email

        let vc = setupInputTableVC()
// MARK: ├─➤ Email
        vc.inputFields.append(InputTableStruct(
            cellType: .text_Email,
            placeholder: "Email Address".localizedCAS(),
            value: email?.lowercased(),
            dataKey: prefKeys.MyInfo.email,
            required: true
        ))

// MARK: ├─➤ Configuration
        // Data
        vc.titleText = "Email".localizedCAS()
        vc.treatAsEdit = false
        vc.SQL_TableName = "Account_MyInfo"
        vc.SQL_EditRecordIndex = -1
        vc.bypassSave = true
        vc.saveToDefaults = false
        vc.Category = "MyInfo"
        vc.NotificationCallbackName = "notification_Settings_UpdateTable"
        vc.AutoSave = true

        // Appearance
        vc.showStatusMessageOnClose = false

        vc.alert_ShowAsAppleStandard = true
        vc.alert_ShowAsActionSheet = false
        vc.alert_ShowSubtitle = false
        vc.alert_ShowSubtitle = false
        vc.alert_TintColor = gAppColor

        vc.showLeftButtonAsImage = false
        vc.leftButtonFunction = .reset  
        vc.leftButtonTitleColors = [APPTHEME.alert_ButtonCancel]
        vc.leftButtonTitles = ["Reset".localized()]
        vc.showRightButtonAsImage = false
        vc.rightButtonFunction = .done
        vc.rightButtonTitleColors = [APPTHEME.alert_ButtonEnabled]
        vc.rightButtonTitles = ["Done".localized()]

        present(vc, animated: true)
    }
    
    
// MARK: - *** ACTIONS ***
    @IBAction func syncServer(_ sender:UIButton){
        getData()
    }

    @IBAction func showMenu(_ sender:UIButton){
        slideMenuController()?.toggleLeft()
    }

    @IBAction func mailListChange(_ sender: UISwitch) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }
        
        /* Get Customer Info from email */
        if (customerInfo.ID > 0) {
            Customers().updateMailingList(vc: self, newSetting: sender.isOn, completion: { (success, error) in
                if success {
                    customerInfo.mailingList = sender.isOn
                    appFunc.keychain.MYINFO().save()
                    self.table.reloadData()
                }
            })
        }
    }
    
    @IBAction func showPrivacy(_ sender: UIButton) {
        selectedSection = sections.sfAccount.rawValue

        let filename:String = "Privacy_\(gAppLanguageCode).pdf"

        guard
            let fileURL = URL(fileURLWithPath: sharedFunc.FILES().dirMainBundle(fileName: filename)) as URL?
        else {
            sharedFunc.ALERT().showFileNotFound(filename: filename)

            return
        }

        simPrint().info("PDF PATH: \( fileURL )")
        simPrint().info("PDF FILE: \( filename )")

        let childVC = UIStoryboard(name:"PDFViewer",bundle:nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
            childVC.pdfURL = fileURL

        self.present(childVC, animated: false)
    }
    
    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertView, animated: true)
    }

    
// MARK: - *** TABLEVIEW ***
    func numberOfSections(in tableView: UITableView) -> Int { return sections_titles.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return isPad ?60 :30 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textColor:UIColor = gAppColor.isLight() ?#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) :#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.sectionHeader) as? cell_BillingSection
        else { return UIView() }

        cell.contentView.backgroundColor = gAppColor
        cell.lbl_Name.textColor = textColor
        cell.btn_Edit.setTitleColor(textColor, for: .normal)
        sharedFunc.DRAW().roundCorner(view: cell.btn_Edit, radius: 3.0, color: textColor, width: 1.0)
        cell.btn_Edit.tag = section

        cell.img_Logo.image = sections_images[section].recolor(textColor)
        cell.lbl_Name.text = "\(sections_titles[section])"

        if let sectionName = sections(rawValue: section) {
            switch sectionName {
            case .myInfo:
                cell.btn_Edit.addTarget(self, action: #selector(edit_MyInfo), for: .touchUpInside)
                cell.btn_Edit.setTitle("Edit".localizedCAS(), for: .normal)
            case .sfAccount:
                cell.btn_Edit.addTarget(self, action: #selector(getData), for: .touchUpInside)
                cell.btn_Edit.setTitle("Update".localizedCAS(), for: .normal)
            default:
                cell.btn_Edit.isHidden = true
                cell.btn_Edit.isEnabled = false
            }
        }

        // Adjust Font Size for Spanish
        cell.btn_Edit.titleLabel?.minimumScaleFactor = 0.5
        cell.btn_Edit.titleLabel?.numberOfLines = 1
        cell.btn_Edit.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = sections(rawValue: indexPath.section) {
            switch section {
            case .myInfo: return isPad ?125 :75
            case .sfAccount: return isPad ?170 :150
            case .reset: return isPad ?100 :63
            }
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textColor:UIColor = gAppColor.isLight() ?#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) :#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        switch indexPath.section {
// MARK: ├───➤ MyInfo
            case sections.myInfo.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.myInfo,for:indexPath as IndexPath) as? cell_MyInfo
                else { return UITableViewCell() }

                sharedFunc.DRAW().strokeBorder(view: cell, color: gAppColor, width: 1.0)
                
                cell.lbl_TitleEmail.text = "Email".localizedCAS() + ":"
                
                cell.lbl_Email.text = customerInfo.email.isNotEmpty ?customerInfo.email :"SERVER.Account.EnterAtCheckout".localized()
                
                return cell
// MARK: ├───➤ Mailing List
            case sections.sfAccount.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.sfAcct,for:indexPath as IndexPath) as? cell_SFAcct
                else { return UITableViewCell() }
                
                sharedFunc.DRAW().strokeBorder(view: cell, color: gAppColor, width: 1.0)
                sharedFunc.DRAW().roundCorner(view: cell.sw_MailingList, radius: 16.0, color: gAppColor, width: 1.5)
                sharedFunc.DRAW().roundCorner(view: cell.btn_Privacy, radius: isPad ? 8 :4, color: gAppColor, width: 1.0)
                
                let mailingList = customerInfo.mailingList

                cell.btn_Privacy.setTitle("Settings_Privacy".localized(), for: .normal)
                cell.btn_Privacy.backgroundColor = gAppColor
                cell.btn_Privacy.setTitleColor(textColor, for: .normal)
                cell.lbl_notes.text = "Settings_MailList_Notes".localized()
                cell.sw_MailingList.isOn = mailingList!
                cell.lbl_CustNum_Title.text = "\("Customer".localizedCAS()) #:"

                let invalidCustomer = (customerInfo.ID < 1)
                cell.lbl_CustNum.textColor = invalidCustomer ?gAppColor.withAlphaComponent(0.5) :gAppColor
                cell.sw_MailingList.isEnabled = invalidCustomer ?false :true
                cell.sw_MailingList.alpha = invalidCustomer ?kAlpha.third :kAlpha.opaque
                cell.sw_MailingList.setNeedsDisplay()

                cell.lbl_CustNum.text = (customerInfo.ID > 0) ?"\( customerInfo.ID! )" :"CustNum_NotSet".localized()
                
                return cell
// MARK: ├───➤ Account Reset
            case sections.reset.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.accountReset,for:indexPath as IndexPath) as? cell_Reset
                else { return UITableViewCell() }
                
                sharedFunc.DRAW().strokeBorder(view: cell, color: gAppColor, width: 1.0)
                sharedFunc.DRAW().roundCorner(view: cell.sw_Reset, radius: 16.0, color: gAppColor, width: 1.5)

                cell.sw_Reset.isOn = false
                cell.sw_Reset.addTarget(self, action: #selector(resetAccount), for: .valueChanged)
                cell.lbl_Title.text = "Account.Reset_Msg".localized()

                return cell
            default: return UITableViewCell()
        }
    }
    

// MARK: - *** GESTURES ***
    

// MARK: - *** NOTIFICATIONS ***
    @objc func notification_Settings_UpdateTable(_ sender: Notification) {
        switch selectedSection {
            case sections.myInfo.rawValue:
                guard let userInfo = sender.userInfo as? [String:Any] else { return }

                customerInfo.email = (userInfo[prefKeys.MyInfo.email] as? String)?.lowercased() ?? ""
                appFunc.keychain.MYINFO().save()
                
                /* get CustomerID if email matches */
                self.getData()
            
                byPass = true
            default: ()
        }
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
        sharedFunc.DRAW().roundCorner(view: table, radius: 7, color: gAppColor, width: 1)
        table.backgroundColor = gAppColor.withAlphaComponent(0.05)
        table.isOpaque = false

        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)
        btn_Menu.setImage(isPad ? #imageLiteral(resourceName: "Menu_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Menu").recolor(gAppColor), for: .normal)

        /* Table Dynamic Row Height */
        table.estimatedRowHeight = 173
        table.rowHeight = UITableView.automaticDimension
        
        /* Load Defaults */

        /* Localization */
        lbl_Title.text = "BillShipTo_Title".localizedCAS()
        
        self.setNeedsStatusBarAppearanceUpdate()

        /* Notifications */
        let NC = NotificationCenter.default
            NC.addObserver(self, selector: #selector(notification_Settings_UpdateTable(_:)),
                                     name: NSNotification.Name("notification_Settings_UpdateTable"),
                                   object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if byPass.isTrue {
            byPass = false
            self.table.reloadData()
        }else{
            self.table.reloadData()

            getData()
        }
    }
    
    
    // MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var table:UITableView!
    @IBOutlet var vw_Topbar:UIView!
    @IBOutlet var divider:UILabel!
    @IBOutlet var btn_Menu:UIButton!
    @IBOutlet var lbl_Title:UILabel!
    
    // MARK: - *** DECLARATIONS (Variables) ***
    enum sections:Int { case myInfo,sfAccount,reset }

    let sections_images:[UIImage] = isPad ?[#imageLiteral(resourceName: "MyInfo_LG"),#imageLiteral(resourceName: "Mini_Logo_LG"),#imageLiteral(resourceName: "appShortcut_Settings")] :[#imageLiteral(resourceName: "MyInfo_LG"),#imageLiteral(resourceName: "Mini_Logo"),#imageLiteral(resourceName: "appShortcut_Settings")]
    let sections_titles:[String] = [
        "Email Address".localizedCAS(),
        "Settings_SFAcct".localized(),
        "Account.Reset_Title".localized()
    ]
    var creditCards:[[String:Any]] = []
    var txtActive:UITextField!
    var byPass = false
    var selectedSection:Int = -1
    
    // MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let myInfo = "cell_MyInfo"
        static let sfAcct = "cell_SFAcct"
        static let accountSection = "cell_AccountSection"
        static let sectionHeader = "cell_BillingSection"
        static let accountReset = "cell_Reset"
    }
}


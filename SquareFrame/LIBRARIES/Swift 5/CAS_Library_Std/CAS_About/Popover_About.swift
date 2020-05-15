/*--------------------------------------------------------------------------------------------------------------------------
   File: Popover_About.swift
 Author: Kevin Messina
Created: January 30, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** ABOUT ***
class cell_About :UITableViewCell {
    @IBOutlet var icon:UIImageView!
    @IBOutlet var item:UILabel!
    @IBOutlet var version:UILabel!
}

// MARK: -
class cell_AboutHeader:UITableViewCell {
    @IBOutlet var title:UILabel!
    @IBOutlet var lblBackground:UILabel!
}

@objc(Popover_About) public class Popover_About:
    UIViewController,
    UITableViewDataSource,UITableViewDelegate
{
    var Version: String { return "2.01" }
    
    
// MARK: - *** ACTIONS ***
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
// MARK: - *** TABLEVIEW METHODS ***
    public func numberOfSections(in tableView: UITableView) -> Int {
        return arrSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return arrApplication.titles.count
        }else if (section == 1){
            return arrDevice.count
        }else if (section == 2){
            return arrDatabases.count
        }else if (section == 3){
            return arrLibraries.count
        }else if (section == 4){
            return arrExtLibraries.count
        }else{
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isPad.isTrue ?48 :32
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_Header) as! cell_AboutHeader
            cell.title?.text = "\(arrSections[section] as String ) (\(tableView.numberOfRows(inSection: section)) items)"
            cell.title?.textColor = BorderColor
            cell.title?.font = UIFont(name: font_SectionTitles.fontName, size: 18) ?? UIFont.systemFont(ofSize: 20)
        
            cell.lblBackground?.backgroundColor = BorderColor.withAlphaComponent(0.15)

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isPad.isTrue ?64 :32
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        enum sectionsInTable:Int { case app,device,dbs,frs,libs }

        let row = indexPath.row
        let section = indexPath.section

        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_About, for: indexPath as IndexPath) as! cell_About
            cell.separatorInset = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsets.zero

        var arrInfo:NSArray!

        if let lbl = sectionsInTable(rawValue: section) {
            switch lbl {
// MARK: ├─➤ APP
                case .app:
                    cell.icon.image = #imageLiteral(resourceName: "About_Apps")
                    cell.item.text = arrApplication.titles[row]
                    cell.version.text = arrApplication.values[row]
// MARK: ├─➤ DEVICE
                case .device:
                    if arrDevice.count > 0 {
                        arrInfo = arrDevice[row] as NSArray
                        switch row {
                            case 0,1: cell.icon?.image = isPad.isTrue ?#imageLiteral(resourceName: "About_iPad") :#imageLiteral(resourceName: "About_iPhone")
                            case 2,3,4: cell.icon?.image = isPad.isTrue ?#imageLiteral(resourceName: "About_iPad_RAM") :#imageLiteral(resourceName: "About_iPhone_RAM")
                            case 5,6,7: cell.icon?.image = isPad.isTrue ?#imageLiteral(resourceName: "About_iPad_HDD") :#imageLiteral(resourceName: "About_iPhone_HDD")
                            default: cell.icon?.image = isPad.isTrue ?#imageLiteral(resourceName: "About_iPad") :#imageLiteral(resourceName: "About_iPhone")
                        }
                        cell.item?.text = arrInfo[0] as? String
                        cell.version?.text = "\(arrInfo[1])"
                    }
// MARK: ├─➤ DATABASES
                case .dbs:
                    if arrDatabases.count > 0 {
                        arrInfo = arrDatabases[row] as NSArray
                        cell.icon?.image = #imageLiteral(resourceName: "About_Databases")
                        cell.item?.text = arrInfo[0] as? String
                        cell.version?.text = "\(arrInfo[1])"
                    }
// MARK: ├─➤ FRAMEWORKS
                case .frs:
                    if arrLibraries.count > 0 {
                        let dict = arrLibraries[row] as [String:String]
                        cell.icon?.image = #imageLiteral(resourceName: "About_Frameworks")
                        cell.item?.text = dict["Name"] ?? ""
                        cell.version?.text = "\(dict["Version"] ?? "")"
                    }
// MARK: ├─➤ EXT LIBRARIES
                case .libs:
                    if arrExtLibraries.count > 0 {
                        arrInfo = arrExtLibraries[row] as NSArray
                        cell.icon?.image = #imageLiteral(resourceName: "About_Libraries")
                        cell.item?.text = arrInfo[0] as? String
                        cell.version?.text = "\(arrInfo[1])"
                    }
            }
        }

        return cell
    }

    
// MARK: - *** GESTURES ***
    @objc func tapCAS(_ sender:UITapGestureRecognizer){
        if sharedFunc.NETWORK().available() {
            guard let websiteURL = URL(string: kDeveloper.URL)
                else{
                    return
            }
            
            UIApplication.shared.open(websiteURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                if isSim { print("Open url '\(websiteURL)': \(success)") }
            })
        }
    }
    
    
// MARK: - *** LIFECYCLE ***
    override public var preferredStatusBarStyle:UIStatusBarStyle { return gAppColor.isLight() ? .default : .lightContent }
    override public var prefersStatusBarHidden:Bool { return true }
    override public var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override public var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override public var shouldAutorotate:Bool { return true }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        sharedFunc.DRAW().roundCorner(view: imgLogo, radius: 3.0)
//        sharedFunc.DRAW().roundCorner(view: imgApp, radius: 16.0)
        sharedFunc.DRAW().addShadow(view: imgApp, offset: 3, radius: 3, opacity: 0.5)

        btnClose.setImage(btnClose.image(for: UIControl.State())?.recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), for: UIControl.State())

        table.cellLayoutMarginsFollowReadableWidth = false
        
        /* Load Defaults */
        lblAppTitle.text = appInfo.EDITION.fullName
        lblCopyright.text = "©\(appInfo.COPYRIGHT.year!) \(appInfo.COMPANY.name!)\n\(appInfo.COPYRIGHT.rights!)"
        lblIndicia.text = "\(appInfo.EDITION.fullName!), its respective logos and indicia are claimed trademarks of \(appInfo.COMPANY.name!). All Rights Reserved."

        lblBackground2.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapCAS(_:)))
        lblBackground2.addGestureRecognizer(tapGesture)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /* Appearance */
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: blurStyle)

        sharedFunc.DRAW().roundCorner(view: table, radius: 8.0, color: BorderColor, width: 1.0)
        sharedFunc.DRAW().roundCorner(view: containerView, radius: 10, color: BorderColor, width: 3.0)

        lblIndicia.textColor = BorderColor
        lblCopyright.textColor = BorderColor
        lblAppTitle.textColor = BorderColor
        lblBackground1.backgroundColor = BorderColor
        lblBackground2.backgroundColor = BorderColor
        imgApp.image = AppImage
        
        /* Set fonts */
        lblAboutTitle.font = font_Title ?? UIFont.systemFont(ofSize: 20)
        lblAppTitle.font = UIFont(name: font_TextBold.fontName, size: 28) ?? UIFont.systemFont(ofSize: 28)
        lblCopyright.font = UIFont(name: font_TextLight.fontName, size: 12) ?? UIFont.systemFont(ofSize: 12)
        lblIndicia.font = UIFont(name: font_TextLight.fontName, size: 10) ?? UIFont.systemFont(ofSize: 10)
        
        /* Load Defults */
        arrSections = sharedFunc.APP().about_sectionNames
        arrDevice = sharedFunc.APP().about_deviceInfo
        arrDatabases = sharedFunc.APP().about_databaseInfo
        arrExtLibraries = Constants().getFabricVersion().namesAndVersions
        arrLibraries = Constants().getLibraryVersions()
        
        /* Localization */
        lblAboutTitle.text = "About".localizedCAS()
        
        table.reloadData()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.isOpaque = false
        containerView.backgroundColor = .clear
        sharedFunc.IMAGE().addBlurEffect(view: containerView, style: .extraLight)
    }

    
// MARK: - *** IBOutlet DECLARATIONS ***
    @IBOutlet var imgApp:UIImageView!
    @IBOutlet var imgLogo:UIImageView!
    @IBOutlet var lblAboutTitle:UILabel!
    @IBOutlet var lblAppTitle:UILabel!
    @IBOutlet var lblCopyright:UILabel!
    @IBOutlet var lblIndicia:UILabel!
    @IBOutlet var lblBackground1:UILabel!
    @IBOutlet var lblBackground2:UILabel!
    @IBOutlet var containerView:UIView!
    @IBOutlet var table:UITableView!
    @IBOutlet var btnClose:UIButton!
    
// MARK: - *** VARIABLE DECLARATIONS ***
    var arrSections:[String]! = []
    var arrApplication:sharedFunc.APP.about_appInfo! = sharedFunc.APP.about_appInfo.init()
    var arrDatabases:[[String]]! = []
    var arrLibraries:[[String:String]]! = []
    var arrDevice:[[String]]! = []
    var arrExtLibraries:[[String]]! = []

// MARK: - *** CELL REUSE IDENTIFIERS ***
    let CellID_About = "cell_About"
    let CellID_Header = "cell_AboutHeader"

// MARK: - *** DECLARATIONS (Presenting VC Parameters) ***
    /* These variables should be set prior to displaying in the presentViewController function of the caller VC */
    var font_Title:UIFont!
    var font_TextBold:UIFont!
    var font_TextLight:UIFont!
    var font_SectionTitles:UIFont!
    var TextColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var BorderColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var AppImage:UIImage! = UIImage.init()
    var blurStyle:UIBlurEffect.Style! = .light
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

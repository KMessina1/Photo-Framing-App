/*--------------------------------------------------------------------------------------------------------------------------
   File: Popover_Table.swift
 Author: Kevin Messina
Created: January 26, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:  - Pass all data as strings in inputFields and convert to Int/Bool, etc. as needed from Strings! Save them as Strings
          to dictInput.
        - Converted to Swift 3.0 on September 17, 2016.
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** GLOBAL CONSTANTS ***

@objc(Popover_Table) class Popover_Table:UIViewController,
                                         UITableViewDataSource,UITableViewDelegate {
    
    var Version: String { return "2.01" }

// MARK: - *** FUNCTIONS ***


// MARK: - *** ACTIONS ***
    @IBAction func editBtnPressed(_ sender: UIButton) {
        sharedFunc.THREAD().doAfterDelay(delay: 0.33) { 
            NotificationCenter.default.post(name: Notification.Name(gSender.NotificationCallbackForEdit), object: nil)
        }
        
        self.dismiss(animated: false)
    }
    
// MARK: - *** TABLEVIEW ***
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch senderCategoryTypes(rawValue: gSender.Category.rawValue)! {
            case .addressList,.menuList,.creditCardList: return 44
            case .currencyList: return 50
            case .imgList,.list: return rowHt
            case .simpleList: return usesVariableHtCell ?UITableView.automaticDimension : 34
            default: return 34
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

// MARK: ├─➤ Cell Setup
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellID.cell)
        let variableCell = tableView.dequeueReusableCell(withIdentifier: cellID.variableHt) as! cell_VariableHeight
        
        if cell == nil {
            if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
                switch category {
                    case .addressList,.creditCardList,.currencyList:
                        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID.cell)
                    case .simpleList:
                        if usesVariableHtCell.isFalse {
                            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID.cell)
                        }
                    default:
                        cell = UITableViewCell(style: .default, reuseIdentifier: cellID.cell)
                }
            }

            if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
                switch category {
                    case .simpleList:
                        variableCell.isOpaque = false
                        variableCell.backgroundColor = .clear
                        variableCell.contentView.isOpaque = false
                        variableCell.contentView.backgroundColor = .clear
                        variableCell.lbl_Item.isOpaque = false
                        variableCell.lbl_Item.backgroundColor = .clear
                    default:
                        cell.textLabel?.highlightedTextColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                        cell.textLabel?.minimumScaleFactor = 0.5
                        cell.textLabel?.adjustsFontSizeToFitWidth = true
                        if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
                            switch category {
                                case .menuList:
                                    cell.textLabel?.font = UIFont(name: font_Text.fontName, size: 20)
                                default:
                                    cell.textLabel?.font = UIFont(name: font_Text.fontName, size: 17)
                            }
                        }
                        cell.imageView?.contentMode = .center
                        cell.textLabel?.backgroundColor = .clear
                        cell.textLabel?.isOpaque = false
                        cell.selectionStyle = .default
                        cell.textLabel?.adjustsFontSizeToFitWidth = true
                        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                        cell.textLabel?.minimumScaleFactor = 0.5
                        cell.detailTextLabel?.minimumScaleFactor = 0.5
                        cell.textLabel?.textColor = (blurColor == .dark) ?#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) :#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

                        cell.backgroundColor = .clear
                        cell.isOpaque = false
                        cell.contentView.isOpaque = false
                        cell.contentView.backgroundColor = .clear
                        cell.textLabel?.isOpaque = false
                        cell.textLabel?.backgroundColor = .clear
                        cell.detailTextLabel?.isOpaque = false
                        cell.detailTextLabel?.backgroundColor = .clear
                    
                        let backgroundView = UIView()
                            backgroundView.backgroundColor = borderColor.withAlphaComponent(0.15)
                        cell.selectedBackgroundView = backgroundView
                    }
                }
            }
        
// MARK: ├─➤ Cell Details
        switch senderCategoryTypes(rawValue: gSender.Category.rawValue)! {
// MARK: ├─➤ Color List
            case .colorList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let Name:String = dict["Name"] as? String ?? ""
                    let imgView = UIImageView(frame:CGRect(x:5,y:5,width:60,height:26))
                        imgView.isOpaque = true
                        imgView.backgroundColor = UIColor().returnColorForName(grouping: "Crayon", name: Name)
                    
                    let img = sharedFunc.IMAGE().screenShotWithTransparency(view: imgView)
                    cell.imageView?.image = img
                    cell.imageView?.backgroundColor = UIColor().returnColorForName(grouping: "Crayon", name: Name)
                    cell.textLabel?.text = "\(Name)"

                    sharedFunc.DRAW().roundCorner(view: cell.imageView!, radius: 10.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.25)
                }
// MARK: ├─➤ Country list
            case .countryList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let Country = dict["Name"] as? String ?? ""
                    let Code = dict["Code"] as? String ?? ""
                    let imgName = dict["FlagImgName"] as? String ?? ""
                    let img = sharedFunc.IMAGE().resizeImage(image: UIImage(named: imgName)!,
                                                            toSize: CGSize(width:21,height:14),
                                                       ignoreScale: false)

                    cell.textLabel?.text = "\(Code) - \(Country)"
                    cell.imageView?.image = img
                    cell.imageView?.contentMode = .scaleAspectFit
                }
// MARK: ├─➤ Currency list
            case .currencyList:
                if let countryInfo:Jurisdictions.JurisdictionStruct = data[row] as? Jurisdictions.JurisdictionStruct {
                    cell.textLabel?.text = "\(countryInfo.name!)"
                    cell.detailTextLabel?.text = "\(countryInfo.currency!) (\(countryInfo.currencyCode!)) '\(countryInfo.currencySymbol!)'"
                    let img = sharedFunc.IMAGE().resizeImage(image: UIImage(named: countryInfo.flagImgName)!,
                                                            toSize: CGSize(width:21,height:14),
                                                       ignoreScale: false)

                    sharedFunc.DRAW().addShadow(view: cell.imageView!, radius: 2, opacity: 0.5)
                    cell.imageView?.image = img
                    cell.imageView?.contentMode = .scaleAspectFit
                }
// MARK: ├─➤ Jurisdiction
            case .jurisdictionList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let State = dict["Name"] as? String ?? ""
                    let Code = dict["Code"] as? String ?? ""
                    cell.textLabel?.text = "\(Code) - \(State)"
                    cell.imageView?.image = nil
                }
// MARK: ├─➤ Credit Card
            case .creditCardList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let Name = dict["NameOnCard"] as? String ?? ""
                    let type = dict["Type"] as? Int ?? 0
                    let ExpM = dict["ExpMonth"] as? Int ?? 0
                    let ExpY = dict["ExpYear"] as? Int ?? 0
                    var tabs:String = "\t"
                    var Num = dict["CardNumber"] as? String ?? ""
                        Num = Num.encodeWithXorByte(key: gEncryptionKey)
                    if Num.count < 16 {
                        tabs = " ".repeatNumTimes(16 - Num.count)
                    }
                    
                    if dict["IsDefault"] as? Bool ?? false {
                        cell.textLabel?.text = "\(Name) (\("default".localizedCAS()))"
                    }else{
                        cell.textLabel?.text = "\(Name)"
                    }
                    
                    // Check if expired!
                    let year:Int = Date().yearNum // - 2000
                    let month:Int = Date().monthNum
                    if (year == ExpY) && (month > ExpM) {
                        cell.textLabel!.text = "(\("Expired".localizedCAS())!) \(cell.textLabel!.text!)"
                        cell.textLabel!.textColor = #colorLiteral(red: 0.6694678068, green: 0.1408496201, blue: 0.1357982159, alpha: 1)
                    }else{
                        cell.textLabel!.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }

                    if let ccFormat = creditCardTypes(rawValue: type) {
                        Num = sharedFunc.STRINGS().formatCreditCard(numString: Num, format: ccFormat, spacerWidth: 1, Protected: false)
                    }
                    
                    cell.textLabel?.font = UIFont(name: font_TextBold.fontName, size: (cell.textLabel?.font.pointSize)!)
                    cell.detailTextLabel?.font = UIFont(name: font_Text.fontName, size: (cell.textLabel?.font.pointSize)!)
                    
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
                    cell.detailTextLabel?.text = "\(Num) \(tabs)Exp: \(ExpM)/\(ExpY - 2000)"
                    cell.textLabel?.adjustsFontSizeToFitWidth = true
                    cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                    cell.textLabel?.minimumScaleFactor = 0.5
                    cell.detailTextLabel?.minimumScaleFactor = 0.5
                    cell.imageView?.image = UIImage(named: creditCardImgs[type]) ?? UIImage()
                    cell.imageView?.backgroundColor = .clear
                    cell.imageView?.isOpaque = false
                    sharedFunc.DRAW().roundCorner(view: cell.imageView!, radius: 3.0, color: .darkGray, width: 1.0)
                    sharedFunc.DRAW().addShadow(view: cell.imageView!, radius: 2, opacity: 0.33)
                }
// MARK: ├─➤ Address list
            case .addressList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let name = dict["Name"] as? String ?? ""
                    let nickName = dict["NickName"] as? String ?? ""
                    let Address = sharedFunc.STRINGS().buildAddress(Name: "",
                                                                   Addr1: dict["Address1"] as? String ?? "",
                                                                   Addr2: dict["Address2"] as? String ?? "",
                                                                    City: dict["City"] as? String ?? "",
                                                                   State: dict["State"] as? String ?? "",
                                                                     Zip: "",
                                                                 Country: "",
                                                               MultiLine: false)
                    
                    cell.textLabel?.text = nickName.isNotEmpty ?"\(name) (\(nickName))" :"\(name)"
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
                    cell.detailTextLabel?.text = "\(Address)"
                    cell.textLabel?.adjustsFontSizeToFitWidth = true
                    cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                    cell.textLabel?.minimumScaleFactor = 0.5
                    cell.detailTextLabel?.minimumScaleFactor = 0.5
                    cell.imageView?.image = nil
                }
// MARK: ├─➤ Img list, Menu List, List
            case .imgList,.menuList,.list:
                if let item:Array<String> = data[row] as? Array<String> {
                    cell.imageView?.image = (item[0].isEmpty == false) ?UIImage(named: item[0] as String ) :nil
                    cell.textLabel?.text = item[1] as String 
                }

                if senderCategoryTypes(rawValue: gSender.Category.rawValue)! == .list {
                    cell.accessoryType = .disclosureIndicator
                }
// MARK: ├─➤ Simple list
            case .simpleList:
                if usesVariableHtCell {
                    table.separatorStyle = .none
                    variableCell.lbl_Item?.text = data[row] as? String ?? ""
                    return variableCell
                }else{
                    cell.accessoryType = .none
                    cell.imageView?.image = nil
                    cell.textLabel?.text = data[row] as? String ?? ""
                }
// MARK: ├─➤ Default
            default:
                cell.textLabel?.text = ""
                cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let NC = NotificationCenter.default
        let NCname = Notification.Name(gSender.NotificationCallbackName!)
        let prefs = UserDefaults.standard
        
        switch senderCategoryTypes(rawValue: gSender.Category.rawValue)! {
// MARK: ├─➤ Simple List
            case .simpleList:
                let key = "\(gSender.Key!)"
                var value:String = ""
                if let item:String = data[row] as? String {
                    switch gSender.Key {
                        case "Expiration Month": value = "\(Int(row + 1))"
                        case "Expiration Year": value = "\(Int(item)!)"
                        default: value = "\(item)"
                    }
                
                    NC.post(name: NCname,object:row,userInfo:[key:value,"selectedItem":gSender.SelectedItem!])
                }
// MARK: ├─➤ Color List
            case .colorList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let key = gSender.Type ?? "Color List"
                    let value = "\(dict["Name"] as? String ?? "")"
                    NC.post(name: NCname,object:nil,userInfo:[key:value])
                }
// MARK: ├─➤ Country
            case .countryList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let key = "Code"
                    let value = "\(dict["Code"] as? String ?? "")"
                    let key2 = "Country"
                    let value2 = "\(dict["Name"] as? String ?? "")"
                    NC.post(name: NCname,object:nil,userInfo:[key:value,key2:value2])
                }
// MARK: ├─➤ Currency list
            case .currencyList:
                    if let countryInfo:Jurisdictions.JurisdictionStruct = data[row] as? Jurisdictions.JurisdictionStruct {
                        NC.post(name: NCname,object:nil,userInfo:["code":"\( countryInfo.code! )"])
                    }
// MARK: ├─➤ Jurisdiction list
            case .jurisdictionList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let key = "State"
                    let value = "\(dict["Code"] as? String ?? "")"
                    NC.post(name: NCname,object:nil,userInfo:[key:value])
                }
// MARK: ├─➤ Address list
            case .addressList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let key = "Address"
                    let value = dict 
                    NC.post(name: NCname,object:nil,userInfo:[key:value])
                }
// MARK: ├─➤ Credit Card list
            case .creditCardList:
                if let dict:NSDictionary = data[row] as? NSDictionary {
                    let key = "CreditCard"
                    let value = dict 
                    NC.post(name: NCname,object:nil,userInfo:[key:value])
                }
// MARK: ├─➤ Img List, List
            case .imgList,.list:
                let item:String! = (data[row] as? Array<String>)![0] 
                if item != nil {
                    NC.post(name: Notification.Name("notification_Settings_UpdateTable"), object: nil)
                }
// MARK: ├─➤ Menu List
            case .menuList:
                if gSender.SelectedItem == row { return }
                
                let item:String! = (data[row] as? Array<String>)![1]
                if item != nil {
                    prefs.set(item,forKey:"Menu_GotoScreen")
                    prefs.synchronize()
                    NC.post(name: Notification.Name("notification_Goto"), object: nil)
                }
            default: ()
        }
    
        if dismissAfterSelection {
            self.dismiss(animated: true)
        }
    }
    

// MARK: - *** LIFECYCLE ***
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: blurColor)
        
        lbl_Title.textColor = gAppColor
        lbl_Title2.textColor = gAppColor
        lbl_Line.backgroundColor = borderColor
        btn_Edit.setTitle("Add".localizedCAS(), for: .normal)
        btn_Edit.setTitleColor(borderColor, for: .normal)
        btn_Edit.backgroundColor = borderColor.withAlphaComponent(0.15)
        sharedFunc.DRAW().addShadow(view: lbl_Title, offsetSize: CGSize(width: 0, height:2), radius: 2.0, opacity: 0.33)
        sharedFunc.DRAW().addShadow(view: lbl_Title2, offsetSize: CGSize(width: 0, height:2), radius: 2.0, opacity: 0.33)
        sharedFunc.DRAW().roundCorner(view: btn_Edit, radius: 5, color: borderColor, width: 1.25)
        sharedFunc.DRAW().roundCorner(view: self.view, radius: 10, color: borderColor, width: 3.0)

        table.backgroundColor = .clear
        table.isOpaque = false
        table.separatorStyle = .singleLine

        /* Table Dynamic Row Height */
        table.estimatedRowHeight = 34
        table.rowHeight = UITableView.automaticDimension
        
        /* Load Defaults */
        data = gSender.Data as NSArray?
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
        
        btn_Edit.isHidden = !gSender.isEditable
        switch senderCategoryTypes(rawValue: gSender.Category.rawValue)! {
            case .simpleList,.menuList,.cart,.colorList,.currencyList:
                lbl_Title.text = btn_Edit.isHidden ? "" : "\(gSender.Title!)"
                lbl_Title2.text = btn_Edit.isHidden ? "\(gSender.Title!)" : ""
                table.bounces = false
            default:
                lbl_Title.text = btn_Edit.isHidden ? "" :"\("Choose".localizedCAS()) \(gSender.Title!)"
                lbl_Title2.text = btn_Edit.isHidden ? "\("Choose".localizedCAS()) \(gSender.Title!)" :""
                table.bounces = true
        }
        
        table.indicatorStyle = (blurColor == .dark) ?.white :.black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* Find current value and select it */
        if gSender.ValueText.isNotEmpty {
            for i in 0..<data.count {
                var searchFor:String! = ""
                switch senderCategoryTypes(rawValue: gSender.Category.rawValue)! {
                    case .colorList: searchFor = (data[i] as! NSDictionary).object(forKey: "Name") as! String?
                    case .countryList: searchFor = (data[i] as! Dictionary)["Name"]
                    case .creditCardList: searchFor = (data[i] as! Dictionary)["CardNumber"]
                    case .jurisdictionList: searchFor = (data[i] as! Dictionary)["Code"]
                    case .menuList: searchFor = (data[i] as! Array<String>)[1]
                    case .simpleList: searchFor = data[i] as? String ?? ""
                    case .currencyList: searchFor = (data[i] as! Jurisdictions.JurisdictionStruct).code
                    case .imgList,.list: searchFor = (data[i] as! Array<String>)[0]
                    default: searchFor = ""
                }
                
                if (searchFor == gSender.ValueText) && (gSender.SelectedItem >= 0) {
                    gSender.SelectedItem = i
                    let path = IndexPath(row: gSender.SelectedItem, section: 0)
                    table.selectRow(at: path,animated:false,scrollPosition:.middle)
                    break
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        table.separatorColor = (blurColor == .dark) ?gAppColor.withAlphaComponent(0.15) :gAppColor.withAlphaComponent(0.5)
        table.setNeedsDisplay()
    }
    
// MARK: - *** IBOutlet DECLARATIONS ***
    @IBOutlet var table:UITableView!
    @IBOutlet var lbl_Title:UILabel!
    @IBOutlet var lbl_Title2:UILabel!
    @IBOutlet var lbl_Line:UILabel!
    @IBOutlet var btn_Edit:UIButton!

// MARK: - *** VARIABLE DECLARATIONS ***
    var data:NSArray! = []
    var rowHt:CGFloat! = 34

// MARK: - *** DECLARATIONS (Presenting VC Configurable Parameters) ***
    var borderColor:UIColor! = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    var blurColor:UIBlurEffect.Style! = .dark
    var font_Title:UIFont!
    var font_Text:UIFont!
    var font_TextBold:UIFont!
    var dismissAfterSelection:Bool = false
    var usesVariableHtCell:Bool = false

    // MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let variableHt = "cell_VariableHeight"
        static let cell = "Cell"
    }
}

class cell_VariableHeight:UITableViewCell {
    @IBOutlet var lbl_Item:UILabel!
}

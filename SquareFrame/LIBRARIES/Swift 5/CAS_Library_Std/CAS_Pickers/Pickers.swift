/*--------------------------------------------------------------------------------------------------------------------------
   File: Pickers.swift
 Author: Kevin Messina
Created: February 3, 2016
 
©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:  2019/03/16 - Added center text for labels
        2017_APR_03 - Added Add,Edit,Delete Capability
        2017_MAR_23 - Added Multi-Column Capability
        2016_SEP_16 - Converted to Swift 3.0
--------------------------------------------------------------------------------------------------------------------------*/


@objc(Popover_Picker) class Popover_Picker:
    UIViewController,
    UIPickerViewDataSource,UIPickerViewDelegate
{

    var Version:String { return "2.05" }

// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    func setColors() {
        imgIcon.backgroundColor = .clear
        imgIcon.image = imgIcon.image?.recolor(borderColor)
        sharedFunc.DRAW().roundCorner(view: imgIcon, radius: imgIcon.frame.size.width / 2)

        divider.backgroundColor = borderColor
        sharedFunc.DRAW().roundCorner(view: self.view, radius: 10.0, color: borderColor, width: 3.0)
    }
    
    func reloadSingleArrayData(_ selectRowFor:String) {
        #if canImport(oldSQL)
            do {
                var whereClause = ""
                if gSender.SQL_Categoryname.isNotEmpty {
                    whereClause = "UPPER(\(gSender.SQL_Categoryname!))='\(gSender.Key!.uppercased())'"
                }

                let records = try sharedFunc.SQL().Get(db: gSender.SQL_Database!,
                                                   select: "DISTINCT \(gSender.SQL_Fieldname!)",
                                                    table: gSender.SQL_Tablename!,
                                           whereCondition: whereClause,
                                                  orderBy: "UPPER(\(gSender.SQL_Fieldname!)) ASC")
                var newData:[String] = []
                records.forEach({ (item) in
                    let newItem = item[gSender.SQL_Fieldname] as? String ?? ""
                    newData.append(newItem.trimDoubleApostrophes)
                })
                
                newData.sort { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending }
                
                /* Update UI */
                self.data = newData as NSArray
                self.picker.reloadAllComponents()

                /* Let calling VC know to reload edited data */
                /* Select row */
                if selectRowFor.isNotEmpty {
                    selectedRow = self.data.index(of: selectRowFor)
                }else{
                    selectedRow = 0
                }

                if selectedRow < 0 {
                    selectedRow = 0
                }
                
                if (selectedRow >= 0) && (self.data.count > 0) && (selectedRow < self.data.count) {
                    self.picker.selectRow(selectedRow, inComponent: 0, animated: false)

                    let userInfo:[String:AnyObject] = [gSender.Placeholder: self.data[selectedRow] as AnyObject]
                
                    NotificationCenter.default.post(name: Notification.Name(gSender.NotificationCallbackName),
                                                  object: self.data,
                                                userInfo: userInfo)
                }
            }catch{
            }
        #endif
    }

    func setMultiColData(row:Int,component:Int) {
        var userInfo = [String:AnyObject]()
        let notification:String! = gSender.NotificationCallbackName

        let numColumns:Int = Int(multi_ColData_Original.count)
        var nextComponent:Int = component + 1
        var prevComponent:Int = component - 1
        if prevComponent < 1 { prevComponent = 0 }
        
        if row == 0 {
            for i in nextComponent..<numColumns {
                multi_ColData[i] = ["--"]
                picker.reloadComponent(i)
                
                /* If there is only one choice, set to row 1 as default */
                var newSelectedRow = 0
                if multi_ColData[nextComponent].count == 2 {
                    newSelectedRow = 1
                }
                picker.selectRow(newSelectedRow, inComponent: i, animated: false)
            }
            
            return
        }
        
        if nextComponent < numColumns {
            guard let dataKeyValue:String = multi_ColData[component][row] as String?,
                  let dataKeyPrevValue:String = multi_ColData[prevComponent][picker.selectedRow(inComponent: prevComponent)] as String?,
                  let dataKey:String = multi_ColDataKeys[component] as String?,
                  let dataKeyPrev:String = multi_ColDataKeys[prevComponent] as String?,
                  let dataKeyNext:String = multi_ColDataKeys[nextComponent] as String?
            else {
                return
            }
        
            let colData = gSender.multiDataRecords.filter{
                $0[dataKeyPrev] as? String == dataKeyPrevValue &&
                $0[dataKey] as? String == dataKeyValue
            }

            var filteredData:[String] = []
            for item in colData {
                let itemName = (item[dataKeyNext] as? String)?.trimSpaces ?? ""
                
                if itemName.isNotEmpty && !filteredData.contains(itemName) {
                    filteredData.append(itemName)
                }
            }
            
            filteredData.sort { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending }
            filteredData.insert("--", at: 0)
            
            multi_ColData[nextComponent] = filteredData
            picker.reloadComponent(nextComponent)
            
            /* If there is only one choice, set to row 1 as default */
            var newSelectedRow = 0
            if multi_ColData[nextComponent].count == 2 {
                newSelectedRow = 1
            }
            picker.selectRow(newSelectedRow, inComponent: nextComponent, animated: false)
            nextComponent += 1
        }

        for i in nextComponent..<numColumns {
            multi_ColData[i] = ["--"]
            picker.reloadComponent(i)
            
            /* If there is only one choice, set to row 1 as default */
            var newSelectedRow = 0
            if multi_ColData[i].count == 2 {
                newSelectedRow = 1
            }
            picker.selectRow(newSelectedRow, inComponent: i, animated: false)
        }
        
        var allColumnsSet:Bool = true
        var allColumnsValues:[String] = []
        for i in 0..<numColumns {
            if picker.selectedRow(inComponent: i) < 1 {
                allColumnsSet = false
                break
            }

            let selectedRow = picker.selectedRow(inComponent: i)
            allColumnsValues.append(multi_ColData[i][selectedRow])
        }

        if allColumnsSet && !initializing {
            userInfo.updateValue(allColumnsValues.last as AnyObject, forKey: gSender.Key)
            NotificationCenter.default.post(name: Notification.Name(notification),
                                          object: nil,
                                        userInfo: userInfo)
        }
    }
    
    func selectFirstEntry() {
    /* If there is only one choice, set to row 1 as default */
        for i in 0..<multi_ColDataKeys.count {
            if multi_ColData[i].count == 2 {
                picker.selectRow(1, inComponent: i, animated: false) // Set the row in the picker
                pickerView(picker, didSelectRow: 1, inComponent: i) // Must reload related data in next columns
            }
        }
    }
    
    func enableBtns(row:Int) {
        let filename:String = data[row] as? String ?? ""
    
        if filename.hasSuffix(".pdf") {
            for i in 0..<toolbar.items!.count {
                if let item = toolbar.items?[i] {
                    let title = item.title ?? ""

                    if (title.uppercased() == "SAVE") ||
                       (title.uppercased() == "PRINTTOSIZE") {
                        item.isEnabled = false
                    }else{
                        item.isEnabled = true
                    }
                }
            }
        }else{
            for i in 0..<toolbar.items!.count {
                if let item = toolbar.items?[i] {
                   item.isEnabled = true
                }
            }
        }
    }


// MARK: - *** ACTIONS ***
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        var args = [String:AnyObject].init()

        let datakey:String = gSender.Key
        let value = "\(datePicker.date)"
        
        if datakey.isNotEmpty {
            args.updateValue(value as AnyObject, forKey: datakey)
        }
        
        NotificationCenter.default.post(name: Notification.Name(gSender.NotificationCallbackName),
                                      object: nil,
                                    userInfo: args)
    }
    
    @IBAction func buttonPressed(_ sender:UIBarButtonItem) {
        let selectedID = picker.selectedRow(inComponent: 0)
        let buttonID = sender.tag
        var userInfo:[String:AnyObject] = [:]
       
        if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
            switch category {
                case .fileList:
                    if selectedID > data.count { return }
                  
                    if let filename = data[selectedID] as? String {
                        userInfo = ["filename":filename as AnyObject]

                        sharedFunc.THREAD().doAfterDelay(delay: 0.15, perform: {
                            NotificationCenter.default.post(name: Notification.Name(self.toolbarButtonCallbacks[buttonID]),
                                                          object: nil,
                                                        userInfo: userInfo)
                        })
                    }
                case .list_Add_Edit_Delete:
                    if selectedID > data.count || data.count == 0 {
                        if buttonID != AddEditDeleteBtns.add.rawValue && data.count > 0 {
                            return
                        }
                    }
        
                    if let buttonPressed = AddEditDeleteBtns(rawValue: buttonID) {
                        switch buttonPressed {
                            case .add:
                                let alert = CASAlertView(appearance: CASAlertView.CASAppearance(showCloseButton:false,
                                                                                                shouldAutoDismiss:false))
                                
                                let txt1 = alert.addTextField(placeholder: "\(gSender.Title ?? "")", text: "", setFocus: true)

                                alert.addButton(title: "Save".localizedCAS()) {
                                    if txt1.text!.isNotEmpty {
                                        let newEntry = txt1.text ?? ""
                                        
                                        /* Check for duplicate entry */
                                        if self.data.contains(newEntry) {
                                            alert.viewText.text = "ERROR: Entry already exists."
                                            alert.viewText.textColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                                            txt1.becomeFirstResponder()
                                            return
                                        }

                                        var values:[String:AnyObject] = [String:AnyObject]()
                                        if gSender.SQL_Categoryname!.isNotEmpty {
                                            values.updateValue("\(gSender.Key!.trimReplaceApostrophes)" as AnyObject, forKey: gSender.SQL_Categoryname!)
                                        }
                                        values.updateValue("\(newEntry.trimReplaceApostrophes)" as AnyObject, forKey: gSender.SQL_Fieldname!)
                                        
                                        #if canImport(oldSQL)
                                            do {
                                                /* Write new record */
                                                try sharedFunc.SQL().Insert(db: gSender.SQL_Database!,
                                                                         table: gSender.SQL_Tablename!,
                                                                 fieldsAndVals: values)
                                                
                                                /* Read back record array for category */
                                                self.reloadSingleArrayData(newEntry)

                                                alert.hideView()
                                            }catch{
                                                if (txt1.text?.isEmpty)! {
                                                    alert.viewText.text = "ERROR: Unkown error saving."
                                                    alert.viewText.textColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                                                    txt1.becomeFirstResponder()
                                                }
                                            }
                                        #endif
                                    }else{
                                        if (txt1.text?.isEmpty)! {
                                            alert.viewText.text = "ERROR: Nothing to Save."
                                            alert.viewText.textColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                                            txt1.becomeFirstResponder()
                                        }
                                    }
                                }
                            
                                alert.addButton(title: "Cancel".localizedCAS(),backgroundColor: #colorLiteral(red: 0.5601567626, green: 0.5578907132, blue: 0.5808923841, alpha: 1)) {
                                    sharedFunc.THREAD().doNow(perform: { txt1.resignFirstResponder() })
                                    alert.hideView()
                                }
                            
                                alert.showCustom(title: "Add \(gSender.Title ?? "")",
                                              subTitle: "for \(gSender.Key ?? "")",
                                                 color: #colorLiteral(red: 0.4862943292, green: 0.7080342174, blue: 0.8237298131, alpha: 1),
                                                  icon: #imageLiteral(resourceName: "CAS_Edit").recolor(#colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1))
                                )
                            
                                return
                            case .edit: ()
                                let alert = CASAlertView(appearance: CASAlertView.CASAppearance(showCloseButton:false,
                                                                                                shouldAutoDismiss:false))
                                
                                let txt1 = alert.addTextField(placeholder: "\(gSender.Title ?? "")",
                                                                     text: "\(data[selectedID])",
                                                                 setFocus: true)

                                let item = data[picker.selectedRow(inComponent: 0)] 
                            
                                alert.addButton(title: "Update".localizedCAS()) {
                                    if txt1.text!.isNotEmpty {
                                        let newEntry = txt1.text ?? ""
                                        
                                        /* Check for duplicate entry */
                                        if self.data.contains(newEntry) {
                                            alert.viewText.text = "ERROR: Entry already exists."
                                            alert.viewText.textColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                                            txt1.becomeFirstResponder()
                                            return
                                        }
                                        
                                        var values:[String:AnyObject] = [String:AnyObject]()
                                        var whereClause:String = ""
                                        if gSender.SQL_Categoryname!.isNotEmpty {
                                            values.updateValue("\(gSender.Key!.trimReplaceApostrophes)" as AnyObject, forKey: gSender.SQL_Categoryname!)
                                            whereClause += "UPPER(\(gSender.SQL_Categoryname!))='\(gSender.Key!.uppercased())' AND "
                                        }
                                        values.updateValue("\(newEntry.trimReplaceApostrophes)" as AnyObject, forKey: gSender.SQL_Fieldname!)

                                        whereClause += "UPPER(\(gSender.SQL_Fieldname!))='\((item as AnyObject).uppercased!)'"
                                      
                                        #if canImport(oldSQL)
                                            do {
                                                /* Update record */
                                                try sharedFunc.SQL().Update(db: gSender.SQL_Database!,
                                                                         table: gSender.SQL_Tablename!,
                                                                 fieldsAndVals: values,
                                                                whereCondition: whereClause)
                                                
                                                /* Read back record array for category */
                                                self.reloadSingleArrayData(newEntry)

                                                alert.hideView()
                                            }catch{
                                                if (txt1.text?.isEmpty)! {
                                                    alert.viewText.text = "ERROR: Unkown error updating."
                                                    alert.viewText.textColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                                                    txt1.becomeFirstResponder()
                                                }
                                            }
                                        #endif
                                    }else{
                                        if (txt1.text?.isEmpty)! {
                                            alert.viewText.text = "ERROR: Nothing to Update."
                                            alert.viewText.textColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
                                            txt1.becomeFirstResponder()
                                        }
                                    }
                                }
                            
                                alert.addButton(title: "Cancel".localizedCAS(),backgroundColor: #colorLiteral(red: 0.5601567626, green: 0.5578907132, blue: 0.5808923841, alpha: 1)) {
                                    sharedFunc.THREAD().doNow(perform: { txt1.resignFirstResponder() })
                                    alert.hideView()
                                }
                            
                                alert.showCustom(title: "Edit \(gSender.Title ?? "")",
                                              subTitle: "for \(gSender.Key ?? "")",
                                                 color: #colorLiteral(red: 0.4862943292, green: 0.7080342174, blue: 0.8237298131, alpha: 1),
                                                  icon: #imageLiteral(resourceName: "CAS_Edit").recolor(#colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1))
                                )
                            
                                return
                            case .delete:
                                let alert = CASAlertView(appearance: CASAlertView.CASAppearance(showCloseButton: false))

                                let item = data[picker.selectedRow(inComponent: 0)]
                                
                                #if canImport(oldSQL)
                                    alert.addButton(title: "YES".localizedCAS()) {
                                        let item = self.data[self.picker.selectedRow(inComponent: 0)] as? String ?? ""
                                        let whereClause = "UPPER(\(gSender.SQL_Fieldname!))='\(item.uppercased())'"
                                        
                                        do {
                                            /* Delete record */
                                            try sharedFunc.SQL().Delete(db: gSender.SQL_Database!,
                                                                     table: gSender.SQL_Tablename,
                                                            whereCondition: whereClause)

                                            /* Read back record array for category */
                                            self.selectedRow = -1
                                            self.reloadSingleArrayData("")
                                            
                                            alert.hideView()
                                        }catch{
                                        }
                                    }
                                #endif

                                alert.addButton(title: "NO".localizedCAS(),backgroundColor: #colorLiteral(red: 0.5601567626, green: 0.5578907132, blue: 0.5808923841, alpha: 1)) {}

                                alert.showCustom(title: "SQL_Delete_Title".localizedCAS(),
                                              subTitle: "\n\(item)\n",
                                                 color: #colorLiteral(red: 0.8363168836, green: 0.1580680609, blue: 0.2192102373, alpha: 1),
                                                  icon: #imageLiteral(resourceName: "CAS_Confirm").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
                            
                                return
                        }
                    }
                default: ()
            }
        }
        
        self.dismiss(animated: true)
    }
    
    
// MARK: - *** PICKERVIEW METHODS ***
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isMultiColumn {
            return multi_ColData.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isMultiColumn {
            return multi_ColData[component].count
        }
        
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return isPad ?100: 40
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var spacers:CGFloat = 30
        var fullwidth:CGFloat = (picker.frame.size.width - spacers)
        
        if isMultiColumn {
            spacers = CGFloat((multi_ColWidths.count - 1) * 5)
            
            let width:CGFloat = CGFloat(multi_ColWidths[component])
            if width == 0.0 {
                fullwidth = (picker.frame.size.width - spacers)
                for wide in multi_ColWidths {
                    fullwidth -= CGFloat(wide)
                }
            }else{
                fullwidth = width
            }
        }
        
        return fullwidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title:String = ""
        var image:UIImage = UIImage()
        
        if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
            switch category {
                case .list_Add_Edit_Delete,.simpleList:
                    guard let item = data[row] as? String else {
                        return UIView.init()
                    }
                    
                    title = item.trimDoubleApostrophes
                case .multiColList:
                    guard let colData:[String] = multi_ColData[component] as [String]?,
                          let item:String = colData[row] as String?
                    else {
                        return UIView.init()
                    }
                    
                    title = "\(item.trimDoubleApostrophes)"
                case .fileList:
                    guard let filename:String = data[row] as? String,
                          let img = gSender.thumbnails[row] as UIImage?
                    else {
                        return UIView.init()
                    }
                    
                    image = img
                    
                    #if TARGET_SF // Squareframe specific Apps.
                        title = "\(filename)"
                    #else
                        title = "\(filename.trimDoubleApostrophes)"
                    #endif
                default:
                    guard let info:NSDictionary = data[row] as? NSDictionary
                    else { return UIView.init() }
                    
                    title = (info.object(forKey: "Name") as? String ?? "").trimDoubleApostrophes
            }
        }
        
        if isMultiColumn {
            textColor = multi_ColColors[component]
        }
        
        let attributes: [NSAttributedString.Key:Any] = [
            .font: isPad ?font_Title! :font_Text!,
            .strokeWidth: -2.0,
            .strokeColor:textColor!,
            .foregroundColor:textColor!,
            .paragraphStyle: centerText ?paraCenter :paraLeft
        ]
        
        let ht = pickerView.rowSize(forComponent: component).height
        let width = isMultiColumn ?pickerView.rowSize(forComponent: component).width :pickerView.frame.size.width
        
        let vw:UIView = UIView(frame:CGRect(x:0,y:0,width:width,height:ht))
            vw.backgroundColor = .clear
            vw.isOpaque = false

        var lbl:UILabel!
        var img:UIImageView!
        switch gSender.Type {
            case "Color List":
                lbl = UILabel(frame:CGRect(x:70,y:0,width:width - 110,height:ht))
                img = UIImageView(frame:CGRect(x:5,y:5,width:60,height:ht - 10))
            case "File List":
                lbl = UILabel(frame:CGRect(x:ht + 10,y:0,width:width - 65,height:ht))
                img = UIImageView(frame:CGRect(x:5,y:0,width:ht,height:ht))
            default:
                if isMultiColumn {
                    if component == 0 {
                        title = " \(title)"
                    }

                    lbl = UILabel(frame:CGRect(x:0,y:0,width:width,height:ht))
                }else{
                    lbl = UILabel(frame:CGRect(x:10,y:0,width:width - 20,height:ht))
                }
        }

        lbl.backgroundColor = isMultiColumn ?multi_ColColors[component].withAlphaComponent(0.1) :.clear
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        lbl.isOpaque = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.baselineAdjustment = .alignCenters
        lbl.attributedText = NSAttributedString(string:" \(title) ",attributes:attributes)
        
        if showToolBar {
            if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
                switch category {
                    case .fileList:
                        enableBtns(row: row)
                    default: ()
                }
            }
        }

        switch gSender.Type {
            case "Color List":
                img.isOpaque = false
                img.contentMode = .scaleToFill
                img.image = nil
                img.backgroundColor = UIColor().returnColorForName(grouping:"Crayon", name: title)
                vw.addSubview(img)
                sharedFunc.DRAW().roundCorner(view: img, radius: 10.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.25)
            case "File List":
                img.isOpaque = false
                img.contentMode = .scaleAspectFit
                img.image = image
                img.backgroundColor = .clear
                vw.addSubview(img)
            default: ()
        }
        
        vw.addSubview(lbl)
        
        return vw
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedID = row
        let key:String! = gSender.Type
        let notification:String! = gSender.NotificationCallbackName
        var selectedTxt:String! = ""
        var userInfo = [String:AnyObject]()
        
        if isMultiColumn {
            setMultiColData(row:row,component:component)
            
            return
        }else{
            selectedRow = row

            if gSender.multiDataReliantPlaceholder.isNotEmpty && !initializing {
                sharedFunc.THREAD().doNow {
                    NotificationCenter.default.post(name: Notification.Name("notification_blankRelatedInputField"),
                                                  object: nil,
                                                userInfo: [gSender.multiDataReliantPlaceholder:""])
                }
            }
        }

        if showToolBar {
            if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
                switch category {
                    case .fileList:
                        enableBtns(row: row)
                    case .list_Add_Edit_Delete:
                        if initializing.isFalse {
                            userInfo.updateValue(data[selectedID] as AnyObject, forKey: gSender.Placeholder)
                            
                            NotificationCenter.default.post(name: Notification.Name(notification),
                                                          object: nil,
                                                        userInfo: userInfo)
                        
                            if dismissAfterSelection {
                                self.dismiss(animated: true)
                            }
                        }
                    default: ()
                }
                
                return
            }
        }
        
        switch gSender.Type {
            case "Color List":
                if let item = data[selectedID] as? [String:AnyObject] {
                    selectedTxt = item["Name"] as? String ?? "".trimDoubleApostrophes
                    userInfo = [key:selectedTxt as AnyObject]
                    
                    let newColor = UIColor().returnColorForName(grouping: "Crayon", name: selectedTxt)
                    gAppColor = newColor
                    borderColor = newColor
                    setColors()
                }
            default: ()
        }
        
        if selectedTxt.isNotEmpty && key.isNotEmpty {
            let prefs = UserDefaults.standard
                prefs.set(selectedTxt, forKey:key)
            prefs.synchronize()
        }

        if initializing.isFalse {
            var selectedData = self.data[selectedID] as? String
            if popoverDataReturnCodeInParens.isTrue {
                let leftParenPosition = selectedData?.indexOfCharacter(char: "(") ?? 0
                let rightParenPosition = selectedData?.indexOfCharacter(char: ")") ?? 0
                
                selectedData = selectedData?[(leftParenPosition + 1)..<rightParenPosition]
            }
            
            userInfo.updateValue(selectedData as AnyObject, forKey: gSender.Title)
            sharedFunc.THREAD().doAfterDelay(delay: 0.1) {
                NotificationCenter.default.post(name: Notification.Name(notification),
                                              object: nil,
                                            userInfo: userInfo)
            }

            if dismissAfterSelection {
                self.dismiss(animated: true)
            }
        }
    }

    
// MARK: - *** LIFECYCLE ***
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: blurEffectType)
        
        /* Define Attributed Items */
        paraLeft.lineBreakMode = .byTruncatingTail
        paraLeft.alignment = .left
        
        paraRight.lineBreakMode = .byTruncatingTail
        paraRight.alignment = .right
        
        paraCenter.lineBreakMode = .byTruncatingTail
        paraCenter.alignment = .center
    
        /* Load Defaults */
        data = gSender.Data as NSArray
    }

    override func viewWillAppear(_ animated: Bool) {
        /* Appearance */
        imgIcon.image = iconImage.recolor(borderColor)
        
        /* Set Title */
        let attributes:[NSAttributedString.Key:Any] = [
            .font:font_Title!,
            .foregroundColor:textColor!,
            .paragraphStyle:centerTitle ?paraCenter :paraLeft
        ]
        
        lblScreenTitle.attributedText = NSAttributedString(string:textTitle, attributes:attributes)
   
        /* Set Appearance colors */
        setColors()
        
        /* Load Defaults */
        picker.isHidden = pickerMode_Date
        datePicker.isHidden = !pickerMode_Date
        picker.reloadAllComponents()
        
        if pickerMode_Date {
            if pickerMaxDateIsToday {
                datePicker.maximumDate = Date()
            }
            pickerDate = (gSender.date != nil) ?gSender.date :Date()
            datePicker.date = pickerDate
        }else if isMultiColumn {
            multi_ColData_Original = multi_ColData

            /* Set all components to default */
            if gSender.multiDataSelections.count >= multi_ColDataKeys.count { // Are there prior selections?
                initializing = true
                for i in 0..<multi_ColDataKeys.count {
                    let dataKeyValue = gSender.multiDataSelections[i] // These are the selected text for each column
                    let row = multi_ColData[i].firstIndex(of: dataKeyValue) ?? 0 // This is the picker row for the selected text
                    picker.selectRow(row, inComponent: i, animated: false) // Set the row in the picker
                    pickerView(picker, didSelectRow: row, inComponent: i) // Must reload related data in next columns
                }
                initializing = false
            }else{
                /* If there is only one choice, set to row 1 as default */
                selectFirstEntry()
            }
        }else{
            /* Set Selected Row in Picker (if any, otherwise first row) */
            if (gSender.SelectedItem < 0) || (gSender.SelectedItem > data.count) { gSender.SelectedItem = 0 }
            picker.selectRow(gSender.SelectedItem, inComponent:0, animated:false)
        }
        initializing = false

        /* Setup toolbar */
        toolbar.isHidden = !showToolBar
        toolbar.items = toolbarButtons
        var counter:Int = 0
        for i in 0..<toolbar.items!.count {
            if let item = toolbar.items?[i] {
                let title = item.title ?? ""
                
                if title.isNotEmpty { // Not a flexible or fixed space
                    item.target = self
                    item.action = #selector(buttonPressed)
                    item.tintColor = toolbarColors[counter]
                    item.tag = counter
                    counter += 1
                    
                    if let category = senderCategoryTypes(rawValue: gSender.Category.rawValue) {
                        switch category {
                            case .list_Add_Edit_Delete:
                                if data.count < 1 {
                                    switch title {
                                        case "Add".localizedCAS(): ()
                                        case "Edit".localizedCAS(): item.isEnabled = false
                                        case "Delete".localizedCAS(): item.isEnabled = false
                                        default: ()
                                    }
                                }
                            default: ()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        pickerHeight.constant = isPad ?216 :162
        pickerDateHeight.constant = pickerHeight.constant
        pickerContraint.constant = showToolBar ?37 : 6
        pickerDateContraint.constant = pickerContraint.constant
    }
    

// MARK: - *** DECLARATIONS (OUTLETS) ***
    @IBOutlet weak var picker:UIPickerView!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var lblScreenTitle:UILabel!
    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var divider:UILabel!
    @IBOutlet weak var toolbar:UIToolbar!
    @IBOutlet weak var pickerContraint:NSLayoutConstraint!
    @IBOutlet weak var pickerDateContraint:NSLayoutConstraint!
    @IBOutlet weak var pickerHeight: NSLayoutConstraint!
    @IBOutlet weak var pickerDateHeight: NSLayoutConstraint!

// MARK: - *** DECLARATIONS (VARIABLES) ***
    enum kPICKER_COLOR:Int { case pos,neutral,neg,kpi }
    enum AddEditDeleteBtns:Int { case add,edit,delete }
    enum ViewSaveBtns:Int { case save,view }
    
    var paraLeft = NSMutableParagraphStyle()
    var paraRight = NSMutableParagraphStyle()
    var paraCenter = NSMutableParagraphStyle()
    var initializing = false
    var selectedRow:Int = 0

// MARK: - *** DECLARATIONS (APPEARANCE) ***
    var blurEffectType:UIBlurEffect.Style! = .extraLight
    var textColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var borderColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var backgroundColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var font_Title:UIFont! = UIFont.systemFont(ofSize: 30)
    var font_Text:UIFont! = UIFont.systemFont(ofSize: 18)
    var textTitle:String! = ""
    var centerTitle:Bool = true
    var centerText:Bool = false
    var data:NSArray! = []
    var dismissAfterSelection:Bool = false
    var showToolBar:Bool = false
    var iconImage:UIImage = #imageLiteral(resourceName: "CAS_Picker_List")

// MARK: - *** DECLARATIONS (Presenting VC Configurable TOOLBAR Parameters) ***
    /* Make action = "buttonPressed:" to custom callbacks to calling VC */
    var toolbarButtons:[UIBarButtonItem] = []
    var toolbarButtonCallbacks:[String] = []
    var toolbarColors:[UIColor] = []

// MARK: - *** DECLARATIONS (Presenting VC Configurable DATE Parameters) ***
    var pickerMode_Date:Bool = false
    var pickerDate:Date = Date()
    var pickerMaxDateIsToday:Bool = false
    
// MARK: - *** DECLARATIONS (Presenting VC Configurable MULTI-COLUMN Parameters) ***
    var isMultiColumn:Bool = false
    var multi_ColData:[[String]] = []
    var multi_ColDataKeys:[String] = []
    var multi_ColWidths:[Int] = []
    var multi_ColColors:[UIColor] = []
    var multi_ColData_Original:[[String]] = []
    var multi_ReliantPlaceholder:String = ""
    var popoverDataReturnCodeInParens:Bool = false
}


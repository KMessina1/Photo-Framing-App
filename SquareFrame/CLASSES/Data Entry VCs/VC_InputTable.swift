/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_InputTable.swift
  Author: Kevin Messina
 Created: March 19, 2017

 ©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Photos
import KeepBackgroundCell

// MARK: - *** GLOBAL CONSTANTS ***

// MARK: - *** VIEW CONTROLLER ***
class VC_InputTable:UIViewController,
                    UITableViewDataSource,UITableViewDelegate,
                    UITextFieldDelegate,
                    UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate,
                    UIPopoverPresentationControllerDelegate {
    
    var Version:String { return "2.07" }

// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    func updateUIFromCustomerInfo() {
        /* Set UI to updated information */
        setInputFieldByPlaceholder(placeholder: "First Name", value: customerInfo.firstName)
        setInputFieldByPlaceholder(placeholder: "Last Name", value: customerInfo.lastName)
        setInputFieldByPlaceholder(placeholder: "Email Address", value: customerInfo.email)
        setInputFieldByPlaceholder(placeholder: "Mailing List", value: "\(customerInfo.mailingList ?? true)")
        
        table.reloadData()
    }

    func setInputFieldByPlaceholder(placeholder:String,value:String) {
        var data = inputFields.filter( { $0.placeholder == placeholder }).first
            if data == nil {
                if isSim { print("Error: \(placeholder)") }
            }
            data?.value = value

        dictInput.updateValue(value, forKey: placeholder)
    }
    
    func clearAllFields(exceptCurrentKey:Bool? = false) {
        for i in 0..<self.dictInput.count {
            guard let data = self.inputFields[i] as InputTableStruct? else {
                break
            }
            
            if (exceptCurrentKey!.isTrue && (data.multiDataReliantPlaceholder.uppercased() == "RESET")).isFalse {
                self.dictInput.updateValue("", forKey: data.placeholder)
            }
        }
        
        self.somethingChanged = true
        self.table.reloadData()
    }
    
    func updateInputAccessoryViewText(_ sText:String) {
        var ounces:Double = sText.doubleValue
        let pounds:Int = Int(ounces.convert_oz_lbs)
        let kg:Int = Int(ounces.convert_lbs_kg)
        if pounds > 0 {
            ounces = Double(Int(ounces) - (pounds * 16))
        }
        
        numberInputView_Text.text = "\(pounds) lbs. \(Int(ounces)) oz. (\(kg) kg)"
    }
    
    func saveChanges(_ sender:UIButton) {
        // Required Fields: Note: Name, Address 1, City, State/Prov & Zip/Postal are always required for a complete address.
        // Note: Even if a field is not required, if it has formatting requirements, like a phone number, then it should
        // fail the 'allRequiredFieldsEntered' flag so that it displays message for user to correct it.
        var allRequiredFieldsEntered:Bool = true
        var isDefault:Bool = false
        var notAllRequired_Msg = "INCOMPLETE INFO".localizedCAS()
        
// MARK: ├─➤ Declarations
        /* Addresses */
        var nickname:String = "",
            name:String = "",
            firstname:String = "",
            lastname:String = "",
            address1:String = "",
            address2:String = "",
            city = "",
            state = "",
            zipcode = "",
            country:String = "",
            phone:String = "",
            email:String = "",
            alertTitle1:String = "",
            alertMsg1:String = "",
            alertTitle2:String = "",
            alertMsg2:String = "",
            incompleteMsg:String = ""
        var countryCode:Int = 0

        /* Credit Cards */
        var NameOnCard:String = "",
            CardNumber:String = "",
            CVN:String = ""
        var Type:Int = 0,
            ExpMonth:Int = 0,
            ExpYear:Int = 0

// MARK: ├─➤ Set Variables
// MARK: ├─┼─➤ Credit Card
        if Style == "CreditCard" {
            NameOnCard = (dictInput["Name on card".localizedCAS()] ?? "").trimReplaceApostrophes
            CardNumber = (dictInput["Card Number".localizedCAS()] ?? "").trimReplaceApostrophes
                CardNumber = CardNumber.removeSpaces
                CardNumber = CardNumber.encodeWithXorByte(key: gEncryptionKey)
            nickname = (dictInput["Nickname of card"] ?? "").trimReplaceApostrophes
            Type = (dictInput["Type".localizedCAS()] ?? "").intValue
            CVN = (dictInput["CVN (Security Code)".localizedCAS()] ?? "").trimReplaceApostrophes
            ExpMonth = (dictInput["Expiration Month".localizedCAS()] ?? "-1").intValue
            ExpYear = (dictInput["Expiration Year".localizedCAS()] ?? "-1").intValue

            // Check if expired!
            let year:Int = Date().yearNum
            let month:Int = Date().monthNum
            let expired:Bool = (ExpYear < year) || (ExpYear == year && ExpMonth < month)
            
            let maxChars:Int = (currentCC_NumType == creditCardTypes.amex.rawValue) ?15 :16
            let CVNChars:Int = (currentCC_NumType == creditCardTypes.amex.rawValue) ?4 :3
            
            if (requiredFields.contains("Name on card".localizedCAS()) && NameOnCard.isEmpty) { incompleteMsg = "Name".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("CVN (Security Code)".localizedCAS()) && (CVN.length != CVNChars)) { incompleteMsg = "Verification".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Expiration Year".localizedCAS()) && (ExpYear < year) || (ExpYear > year + 6)) { incompleteMsg = "Year".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Expiration Month".localizedCAS()) && (ExpMonth < 0) || (ExpMonth > 12)) { incompleteMsg = "Month".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Expiration Year".localizedCAS()) && expired) { incompleteMsg = "ExpiredCard_Title".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Card Number".localizedCAS()) && CardNumber.length != maxChars) { incompleteMsg = "BillShipTo_CreditCards_CardNum".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Type".localizedCAS()) && Type < 0) { incompleteMsg = "Type".localizedCAS(); allRequiredFieldsEntered = false }

            notAllRequired_Msg = "INCOMPLETE INFO".localizedCAS()
        } else {
// MARK: ├─┼─➤ Address
            nickname = (dictInput["Account Nickname".localizedCAS()] ?? "").trimReplaceApostrophes
            name = (dictInput["Name".localizedCAS()] ?? "").trimReplaceApostrophes
            firstname = (dictInput["First Name".localizedCAS()] ?? "").trimReplaceApostrophes
            lastname = (dictInput["Last Name".localizedCAS()] ?? "").trimReplaceApostrophes
            address1 = (dictInput["Address Line 1".localizedCAS()] ?? "").trimReplaceApostrophes
            address2 = (dictInput["Address Line 2".localizedCAS()] ?? "").trimReplaceApostrophes
            city = (dictInput["City".localizedCAS()] ?? "").trimReplaceApostrophes
            state = (dictInput["State".localizedCAS()] ?? "").trimReplaceApostrophes
            zipcode = (dictInput["Zip Code".localizedCAS()] ?? "").trimReplaceApostrophes
            country = (dictInput["Country".localizedCAS()] ?? "US").trimReplaceApostrophes
            countryCode = (country == "CA") ?countries.canada.rawValue :countries.usa.rawValue
            phone = (dictInput["Phone Number with Area Code".localizedCAS()] ?? "").trimReplaceApostrophes
            email = (dictInput["Email Address".localizedCAS()] ?? "").trimReplaceApostrophes
            isDefault = NSString(string: dictInput["Set as default".localizedCAS()] ?? "false").boolValue

            if (requiredFields.contains("Name".localizedCAS()) && name.isEmpty && !useFirstAndLastName) { incompleteMsg = "Name".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("First".localizedCAS()) && firstname.isEmpty && useFirstAndLastName) { incompleteMsg = "First Name".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Last".localizedCAS()) && lastname.isEmpty && useFirstAndLastName) { incompleteMsg = "Last Name".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Address Line 1".localizedCAS()) && address1.isEmpty) { incompleteMsg = "Address".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("City".localizedCAS()) && city.isEmpty) { incompleteMsg = "City".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Nickname".localizedCAS()) && nickname.isEmpty) { incompleteMsg = "Acct. Nickname".localizedCAS(); allRequiredFieldsEntered = false }
            if (requiredFields.contains("Phone".localizedCAS()) && phone.isEmpty) { incompleteMsg = "Phone".localizedCAS(); allRequiredFieldsEntered = false }

            /* Validate Country Codes */
            if requiredFields.contains("Country".localizedCAS()) {
                switch countryCode {
                    case countries.usa.rawValue: ()
                    default:
                        incompleteMsg = "Country (US Only)".localizedCAS()
                        allRequiredFieldsEntered = false
                }
                
                /* Validate State & Zip/Postal Codes */
                switch countryCode {
                    case countries.usa.rawValue:
                        if requiredFields.contains("Zip Code".localizedCAS()) && requiredFields.contains("State".localizedCAS()) {
                            if zipcode.count != 5 && zipcode.count != 10 { incompleteMsg = "Zip Code".localizedCAS(); allRequiredFieldsEntered = false }
                            if state.count < 2 { incompleteMsg = "State".localizedCAS(); allRequiredFieldsEntered = false }
                        }
                    default: ()
                }
            }
            
            /* Validate Email address */
            if requiredFields.contains("Email Address".localizedCAS()) && (email.isEmpty || !email.isValidEmail) {
                incompleteMsg = "Email Address".localizedCAS()
                allRequiredFieldsEntered = false
            }
            
            if (nickname.trimSpaces.lowercased() == "primary" ||
                nickname.trimSpaces.lowercased() == "billing") {
              
                let actSheet = sharedFunc.actSheet().setup(vc: self,title: "AccountNickname_Reserved".localizedCAS())
                    actSheet.view.tag = sender.tag
                let title = "Go back & fix".localizedCAS()

                actSheet.addAction(UIAlertAction(title:"\(title) \("Acct. Nickname".localizedCAS())", style:.default, handler:{ action in
                    return
                }))

                actSheet.addAction(UIAlertAction(title:"Exit and don't save".localizedCAS(), style:.destructive, handler:{ action in
                    self.dismiss(animated: true)
                    return
                }))
                
                present(actSheet, animated:true)
                return
            }
            
            email = email.lowercased()
            
            /* Validate Phone Number */
            if phone.count > 0 {
                phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone)
                if phone.count != 10 {
                    incompleteMsg = "Phone Number".localizedCAS()
                    allRequiredFieldsEntered = false
                }
                phone = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: phone)
            }
            
            notAllRequired_Msg = "INCOMPLETE ADDRESS".localizedCAS()

            // Optional (Passed as parameter from calling VC) Required Fields
            for key in requiredFields {
                if (dictInput[key] ?? "").trimSpaces.isEmpty {
                    incompleteMsg = key.localizedCAS()
                    allRequiredFieldsEntered = false
                    break
                }
            }
        }
        
// MARK: ├─➤ Validations
        /* If not all required info, display msg and exit */
        if allRequiredFieldsEntered.isFalse {
            let actSheet: UIAlertController = UIAlertController(
                title: notAllRequired_Msg,
                message: nil,
                preferredStyle: .actionSheet
            )
            
            actSheet.view.tag = sender.tag
            
            let title = "Go back & fix".localizedCAS()
            let _ = actSheet.addAction(UIAlertAction(title:"\(title) \(incompleteMsg)", style:.default, handler:{ action in
                return
            }))

            let _ = actSheet.addAction(UIAlertAction(title:"Exit and don't save".localizedCAS(), style:.destructive, handler:{ action in
                self.dismiss(animated: true)
                return
            }))
            
            actSheet.setTint(color: gAppColor)

            present(actSheet, animated:true)
            return
        }
        
// MARK: ├─➤ Save
        if bypassSave {
            var args = [String:AnyObject].init()
            
            for field in dictInput {
                let inField = (inputFields.filter{ $0.placeholder == field.key }).first
                if inField != nil {
                    let datakey:String = inField?.dataKey ?? ""
                    let cellType:InputTableCellType = inField?.cellType ?? .text
                    var value = field.value
                    
                    if (cellType == .text_Number) || (cellType == .text_Weight) || (cellType == .text_Currency) {
                        value = sharedFunc.STRINGS().removeAllNonNumericChars(string:value)
                    }

                    if (cellType == .swtch) {
                        if value.isEmpty { value = "0"
                        }else if value == "false" { value = "0"
                        }else if value == "true" { value = "1"
                        }
                    
                        /* Only allow 0 or 1 */
                        let intVal = Int(value)!
                        if (intVal < 0) || (intVal > 1) {
                            value = "0"
                        }
                        
                        value = String(describing: Int(value) ?? 0 ) // Make sure it's a number and not blank
                    }

                    if (cellType == .segBar) {
                        if value.isEmpty {
                            value = "0"
                        }
                        
                        value = String(describing: Int(value) ?? 0 ) // Make sure it's a number and not blank
                    }

                    if (inField?.reliantDataKeyNotGreater.isNotEmpty)! {
                        let key = inField?.placeholder ?? ""
                        let reliantKey:String = inField?.reliantDataKeyNotGreater ?? ""
                        let reliantKeyValue:String = dictInput[reliantKey]?.trimReplaceApostrophes ?? ""
                        
                        let qty:Int = Int(reliantKeyValue)!
                        let qtyOnHand:Int = Int(value)!
                        
                        if qtyOnHand > qty {
                            let actSheet = sharedFunc.actSheet().setup(vc: self,title: "\"\(key)\" \("cannot be more than".localizedCAS()) \"\(reliantKey)\"")
                                actSheet.view.tag = sender.tag
                                let title = "Go back & fix".localizedCAS()
                            
                                actSheet.addAction(UIAlertAction(title:"\(title) \(key)", style:.default, handler:{ action in
                                    return
                                }))

                                actSheet.addAction(UIAlertAction(title:"Exit and don't save".localizedCAS(), style:.destructive, handler:{ action in
                                    self.dismiss(animated: true)
                                    return
                                }))
                            
                            present(actSheet, animated:true)
                            return
                        }
                    }
                    
                    if datakey.isNotEmpty {
                        args.updateValue(value.trimReplaceApostrophes as AnyObject, forKey: datakey)
                    }

                    simPrint().info("dataKey: \(datakey) value: \(value.trimReplaceApostrophes)",function:#function,line:#line)
                }
            }
            
            if treatAsEdit {
                args.updateValue(SQL_EditRecordIndex as AnyObject, forKey: "indx")
            }

            NotificationCenter.default.post(name: Notification.Name(NotificationCallbackName),
                                          object: Category,
                                        userInfo: args)
            
            self.dismiss(animated: true)
            return
        }
        
        
// MARK: ├─┼─➤ UPDATE RECORD
        /* Reset all other Default records to false if this record is set to default */
        if isDefault {
            #if canImport(oldSQL)
                do {
                    let _ = try sharedFunc.SQL().Update(db: appInfo.DB.data,
                                                     table: SQL_TableName,
                                             fieldsAndVals: ["IsDefault":false as AnyObject])
                } catch {
                }
            #endif
        }
        
        if treatAsEdit && (saveToDefaults == false) { // Update SQL, Not Defaults
            if SQL_EditRecordIndex < 0 {
                sharedFunc.ALERT().show(
                    title:"SQL_SaveError_Title".localizedCAS(),
                    style:.error,
                    msg:"SQL_SaveError_Msg".localizedCAS()
                )
                self.dismiss(animated: true)
                return
            }
            
            if nickname.isEmpty {
                if (Style == "CreditCard") {
                    var num = CardNumber.trimDoubleApostrophes
                        num = num.encodeWithXorByte(key: gEncryptionKey)
                        num = sharedFunc.STRINGS().formatCreditCard(numString: num,
                                                                       format: creditCardTypes(rawValue: Type)!,
                                                                  spacerWidth: 1,
                                                                    Protected: false)
                    if let _ = creditCardTypes(rawValue: Type) {
                        alertMsg1 = "\(creditCardImgs[Type])\n\(num)"
                    }else{
                        alertMsg1 = "\(num)"
                    }
                }else{
                    alertMsg1 = "\(name.trimDoubleApostrophes)"
                }
            }else{
                alertMsg1 = "\(nickname.trimDoubleApostrophes)"
            }

            alertTitle2 = "SQL_SaveError_Title".localizedCAS()
            alertMsg2 = "SQL_SaveError_Msg".localizedCAS()
            
            var args:[String:Any]
            if Style == "CreditCard" {
                args = ["Nickname":nickname,
                        "NameOnCard":NameOnCard,
                        "CardNumber":CardNumber,
                        "Type":Type,
                        "Code":CVN,
                        "ExpMonth":ExpMonth,
                        "ExpYear":ExpYear,
                        "IsDefault":NSNumber(value: isDefault)]
                alertTitle1 = "SQL_UpdateCC_Title".localizedCAS()
            } else {
                args = ["Nickname":nickname,
                        "Name":name,
                        "Address1":address1,
                        "Address2":address2,
                        "City":city,
                        "State":state,
                        "Zipcode":zipcode,
                        "Country":country,
                        "IsDefault":NSNumber(value: isDefault)]
                alertTitle1 = "SQL_UpdateAddress_Title".localizedCAS()
            }
            
            #if canImport(oldSQL)
                do {
                     let _ = try sharedFunc.SQL().Update(db: appInfo.DB.data,
                                                      table: SQL_TableName,
                                              fieldsAndVals: args as Dictionary<String, AnyObject>,
                                             whereCondition: "Indx=\(SQL_EditRecordIndex)")

                    if self.showStatusMessageOnClose {
                        sharedFunc.ALERT().show(title: alertTitle1,style:.error,msg: alertMsg1)
                    }
                } catch {
                    sharedFunc.ALERT().show(title: alertTitle2,style:.error,msg: alertMsg2)
                }
            #endif
        }else if treatAsEdit.isFalse && saveToDefaults.isFalse { // Insert SQL, Not Defaults
// MARK: ├─┼─➤ ADD RECORD
            if nickname.isEmpty {
                if (Style == "CreditCard") {
                    var num = CardNumber.trimDoubleApostrophes 
                        num = num.encodeWithXorByte(key: gEncryptionKey)
                        num = sharedFunc.STRINGS().formatCreditCard(numString: num,
                                                                       format: creditCardTypes(rawValue: Type)!,
                                                                  spacerWidth: 1,
                                                                    Protected: false)
                    if let _ = creditCardTypes(rawValue: Type) {
                        alertMsg1 = "\(creditCardImgs[Type])\n\(num)"
                    }else{
                        alertMsg1 = "\(num)"
                    }
                }else{
                    alertMsg1 = "\(name.trimDoubleApostrophes)"
                }
            }else{
                alertMsg1 = "\(nickname.trimDoubleApostrophes)"
            }
            
            alertTitle2 = "SQL_SaveError_Title".localizedCAS()
            alertMsg2 = "SQL_SaveError_Msg".localizedCAS()

            var args:[String:Any]
            if Style == "CreditCard" {
                args = ["Nickname":nickname,
                        "NameOnCard":NameOnCard,
                        "CardNumber":CardNumber,
                        "Type":Type,
                        "Code":CVN,
                        "ExpMonth":ExpMonth,
                        "ExpYear":ExpYear,
                        "IsDefault":NSNumber(value: isDefault)
                ]
                alertTitle1 = "SQL_AddedCC_Title".localizedCAS()
            } else {
                args = ["Nickname":nickname,
                        "Name":name,
                        "Address1":address1,
                        "Address2":address2,
                        "City":city,
                        "State":state,
                        "Zipcode":zipcode,
                        "Country":country,
                        "IsDefault":NSNumber(value: isDefault)
                ]
                alertTitle1 = "SQL_AddedAddress_Title".localizedCAS()
            }

            #if canImport(oldSQL)
                do {
                    let _ = try sharedFunc.SQL().Insert(db: appInfo.DB.data,
                                                     table: SQL_TableName,
                                             fieldsAndVals: args as Dictionary<String, AnyObject>)
                    
                    if self.showStatusMessageOnClose {
                        sharedFunc.ALERT().show(title: alertTitle1,style:.error,msg: alertMsg1)
                    }
                } catch {
                    sharedFunc.ALERT().show(title: alertTitle2,style:.error,msg: alertMsg2)
                }
            #endif
        }else if treatAsEdit.isFalse && saveToDefaults.isTrue { // Edit DEFAULTS, Not SQL
// MARK: ├─┼─➤ UPDATE DEFAULTS
            if SQL_TableName.isNotEmpty {
                if Style == "CreditCard" {
                    // No defaults record used in app
                } else {
                    let prefs = UserDefaults.standard
                        prefs.set(firstname, forKey: "\(SQL_TableName).FirstName")
                        prefs.set(lastname, forKey: "\(SQL_TableName).LastName")
                        prefs.set(address1, forKey: "\(SQL_TableName).Addr1")
                        prefs.set(address2, forKey: "\(SQL_TableName).Addr2")
                        prefs.set(city, forKey: "\(SQL_TableName).City")
                        prefs.set(state, forKey: "\(SQL_TableName).State")
                        prefs.set(country, forKey: "\(SQL_TableName).CountryName")
                        prefs.set(zipcode, forKey: "\(SQL_TableName).Zip")
                    
                        if phone.isNotEmpty { prefs.set(phone, forKey: "\(SQL_TableName).Phone") }
                        if email.isNotEmpty { prefs.set(email, forKey: "\(SQL_TableName).Email") }
                    
                    prefs.synchronize()
                    
                    if self.showStatusMessageOnClose {
                        sharedFunc.ALERT().show(
                            title:"SQL_UpdateAddress_Title".localizedCAS(),
                            style:.error,
                            msg:"\"\(firstname.trimDoubleApostrophes) \(lastname.trimDoubleApostrophes)\""
                        )
                    }
                }
            }
        }
        
// MARK: ├─➤ SEND UPDATE NOTIFICATIONS
        switch Category {
            case "MyInfo":
                let key = "MyInfo"
                let value:[String:Any] = [
                             "FirstName":firstname,
                             "LastName":lastname,
                             "Email":email
                ]
                NotificationCenter.default.post(name: Notification.Name(NotificationCallbackName),object:nil,userInfo:[key:value])
            case "Billing Address":
                let key = "BillingInfo"
                let value:[String:Any] = [
                             "FirstName":firstname,
                             "LastName":lastname,
                             "Address1":address1,
                             "Address2":address2,
                             "City":city,
                             "State":state,
                             "ZipCode":zipcode,
                             "Country":country
                ]
                NotificationCenter.default.post(name: Notification.Name(NotificationCallbackName),object:nil,userInfo:[key:value])
            case "Address List":
                let key = "Address"
                let value:[String:Any] = [
                             "Name":name,
                             "Address1":address1,
                             "Address2":address2,
                             "City":city,
                             "State":state,
                             "Zipcode":zipcode,
                             "Country":country]
                NotificationCenter.default.post(name: Notification.Name(NotificationCallbackName),object:nil,userInfo:[key:value])
            case "Credit Card List":
                let key = "CreditCard"
                let value:[String:Any] = [
                     "Nickname":nickname,
                     "NameOnCard":NameOnCard,
                     "CardNumber":CardNumber,
                     "Type":Type,
                     "Code":CVN,
                     "ExpMonth":ExpMonth,
                     "ExpYear":ExpYear,
                     "IsDefault":NSNumber(value: isDefault)
                ]
                NotificationCenter.default.post(name: Notification.Name(NotificationCallbackName),
                                              object:nil,
                                            userInfo:[key:value])
            default: ()
        }
        
        self.dismiss(animated: true)
    }
    
    func initializeData() {
        somethingChanged = false
        requiredFields = []
        
        for i in 0..<inputFields.count {
            guard let fields = self.inputFields[i] as InputTableStruct? else {
                return
            }
            
            let key = fields.placeholder
            let value = fields.value
            dictInput.updateValue(value, forKey: key)

            if fields.required.isTrue {
                requiredFields.append(key)
            }
            
            if key == "name" {
                useFirstAndLastName = false
            }
        
            if key == "Type" {
                currentCC_NumType = Int("\(value)")!
                dictInput.updateValue("\(currentCC_NumType)", forKey: "Type")
            }
        }
    }
    
    func setupPopoverCell(indexPath:IndexPath) ->cell_InputPopoverTable {
        guard let cell = table.dequeueReusableCell(withIdentifier: cellID.inputPopoverTable,for: indexPath) as? cell_InputPopoverTable else {
            return cell_InputPopoverTable()
        }
        
        cell.backgroundColor = .clear
        cell.isOpaque = false
        sharedFunc.DRAW().roundCorner(view: cell.lbl_Required, radius: 5)
        
        cell.txt_Item.textColor = textColor
        cell.txt_Item.borderActiveColor = borderColor_Active
        cell.txt_Item.borderInactiveColor = borderColor_Inactive
        cell.txt_Item.tag = indexPath.row
        cell.txt_Item.placeholderColor = placeholderColor
        cell.txt_Item.placeholderLabel.adjustsFontSizeToFitWidth = true
        cell.txt_Item.placeholderLabel.minimumScaleFactor = 0.5

        cell.txt_Item.font = UIFont(name: textFont.fontName, size: isPad.isTrue ?(textFont.pointSize * 1.5) :textFont.pointSize)
        
        cell.lbl_Item.tag = indexPath.row
        
        return cell
    }
    
    func setupInputCell(indexPath:IndexPath) ->cell_InputTextField {
        guard let cell = table.dequeueReusableCell(withIdentifier: cellID.inputText,for: indexPath) as? cell_InputTextField else {
            return cell_InputTextField()
        }

        cell.backgroundColor = .clear
        cell.isOpaque = false
        cell.tag = indexPath.row
        sharedFunc.DRAW().roundCorner(view: cell.lbl_Required, radius: 5)
        
        cell.txt_Item.textColor = textColor
        cell.txt_Item.borderActiveColor = borderColor_Active
        cell.txt_Item.borderInactiveColor = borderColor_Inactive
        cell.txt_Item.keyboardType = .default
        cell.txt_Item.autocapitalizationType = .sentences
        cell.txt_Item.placeholderColor = placeholderColor
        cell.txt_Item.placeholderLabel.adjustsFontSizeToFitWidth = true
        cell.txt_Item.placeholderLabel.minimumScaleFactor = 0.5
        cell.txt_Item.font = UIFont(name: textFont.fontName, size: isPad.isTrue ?(textFont.pointSize * 1.5) :textFont.pointSize)
        cell.txt_Item.tag = indexPath.row
        
        return cell
    }

    func presentPickerPopover(sender:UITapGestureRecognizer,
                                size:CGSize? = CGSize(width:220,height:150),
                               title:String,
                           iconImage:UIImage? = #imageLiteral(resourceName: "CAS_Picker_List"),
                         showToolBar:Bool? = false,
                       toolbarColors:[UIColor]? = [],
                      toolbarButtons:[UIBarButtonItem]? = [],
              toolbarButtonCallbacks:[String]? = [],
                        isDatePicker:Bool? = false,
                pickerMaxDateIsToday:Bool? = false,
                          isMultiCol:Bool? = false,
                       multi_ColData:[[String]]? = [],
                   multi_ColDataKeys:[String]? = [],
                     multi_ColWidths:[Int]? = [],
                     multi_ColColors:[UIColor]? = [],
            multi_ReliantPlaceholder:String? = "",
                           font_Text:UIFont? = UIFont.systemFont(ofSize: 18)
        ) {
    
        let vc = UIStoryboard(name:"Pickers",bundle:nil).instantiateViewController(withIdentifier: "Popover_Picker") as! Popover_Picker
            vc.modalPresentationStyle = .popover
            vc.preferredContentSize = size!
            vc.popoverPresentationController?.permittedArrowDirections = .any
            vc.popoverPresentationController?.delegate = self
            vc.popoverPresentationController?.sourceView = sender.view ?? self.view
            vc.popoverPresentationController?.sourceRect = sender.view?.bounds ?? self.view.bounds
            
            vc.blurEffectType = .light
            vc.textColor = gAppColor
            vc.borderColor = gAppColor
            vc.backgroundColor = APPTHEME.colors().backgroundColor
            vc.font_Text = font_Text!
        
            vc.showToolBar = showToolBar!
            vc.toolbarButtons = toolbarButtons!
            vc.toolbarButtonCallbacks = toolbarButtonCallbacks!
            vc.toolbarColors = toolbarColors!

            vc.iconImage = iconImage!
            vc.textTitle = title
            vc.centerTitle = true
            vc.dismissAfterSelection = false
            vc.pickerMode_Date = isDatePicker!
            vc.pickerMaxDateIsToday = pickerMaxDateIsToday!
        
            vc.isMultiColumn = isMultiCol!
            vc.multi_ColData = multi_ColData!
            vc.multi_ColDataKeys = multi_ColDataKeys!
            vc.multi_ColWidths = multi_ColWidths!
            vc.multi_ColColors = multi_ColColors!
        
        present(vc, animated: true)
    }

    func presentTablePopover(sender:UITapGestureRecognizer, size:CGSize? = CGSize(width:175,height:150)) {
        let vc = UIStoryboard(name:"Tables",bundle:nil).instantiateViewController(withIdentifier: "Popover_Table") as! Popover_Table
            vc.modalPresentationStyle = .popover
            vc.preferredContentSize = size!
            vc.popoverPresentationController?.delegate = self
            vc.popoverPresentationController?.sourceView = self.view
            vc.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            vc.popoverPresentationController?.permittedArrowDirections = []
        
            vc.borderColor = gAppColor
            vc.blurColor = .light
            vc.font_Title = UIFont(name: (APPFONTS().text_Thin?.fontName)!, size: 32)
            vc.font_Text = UIFont(name: (APPFONTS().text_Light?.fontName)!, size: 14)
            vc.font_TextBold = UIFont(name: (APPFONTS().text_Reg?.fontName)!, size: 14)
            vc.dismissAfterSelection = true
        
        present(vc, animated: true)
    }

    func getPhotoLibraryPermissionStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized: return true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                })
                return false
            case .denied, .restricted:
                sharedFunc.ALERT().show(
                    title:"PhotoLibrary_Title".localizedCAS(),
                    style:.error,
                    msg:"PhotoLibrary_NoAccess".localizedCAS()
                )
                return false
            @unknown default: return false
        }
    }
    
    func selectPhotoFromLibrary() {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imgPicker.modalPresentationStyle = .fullScreen
        imgPicker.view.tag = selectedRow
        
        present(imgPicker, animated: true)
    }

    // MARK: - *** ACTIONS ***
    @IBAction func btnHidePressed(_ sender:UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnPrevPressed(_ sender:UIBarButtonItem) {
        var prevTag:Int = selectedRow
        
        if prevTag <= 0 {
            prevTag = inputFields.count
        }
        
        repeat {
            prevTag -= 1
            
            guard let path = IndexPath(row: prevTag, section: 0) as IndexPath?
            else {
                return
            }

            table.scrollToRow(at: path, at: .top, animated: false)
            
            if let cell = table.cellForRow(at: path) {
                for vw in cell.subviews {
                    for subvw in vw.subviews {
                        if (subvw.isKind(of: HoshiTextField.classForCoder()) ||
                            subvw.isKind(of: UITextField.classForCoder())) &&
                            subvw.isUserInteractionEnabled {

                            subvw.becomeFirstResponder()
                            return
                        }
                    }
                }
            }
            
            if prevTag <= 0 {
                prevTag = inputFields.count
            }
            
        } while prevTag > 0
    }

    @IBAction func btnNextPressed(_ sender:UIBarButtonItem) {
        var nextTag:Int = selectedRow
        
        if nextTag >= inputFields.count - 1 {
            nextTag = -1
        }
        
        repeat {
            nextTag += 1
            
            guard let path = IndexPath(row: nextTag, section: 0) as IndexPath?
            else {
                return
            }

            table.scrollToRow(at: path, at: .top, animated: false)
            
            if let cell = table.cellForRow(at: path) {
                for vw in cell.subviews {
                    for subvw in vw.subviews {
                        if (subvw.isKind(of: HoshiTextField.classForCoder()) ||
                            subvw.isKind(of: UITextField.classForCoder())) &&
                            subvw.isUserInteractionEnabled {
                            
                            subvw.becomeFirstResponder()
                            return
                        }
                    }
                }
            }

            if nextTag >= inputFields.count - 1 {
                nextTag = -1
            }
            
        } while nextTag < (inputFields.count - 1)
    }
    
    @IBAction func removeItem(_ sender:UIButton){
        selectedRow = sender.tag

        guard let fields = self.inputFields[selectedRow] as InputTableStruct? else { return }
        
        dictInput.updateValue("", forKey: fields.placeholder)
        somethingChanged = true
        
        table.reloadData()
    }
    
    @IBAction func selectPhoto(_ sender:UIButton){
        // Get the current authorization state.
        if getPhotoLibraryPermissionStatus().isFalse {
            return
        }

        selectedRow = sender.tag
        selectPhotoFromLibrary()
    }
    
    @IBAction func segChanged(_ sender:UISegmentedControl){
        guard let data = self.inputFields[sender.tag] as InputTableStruct? else {
            return
        }

        somethingChanged = true
        
        let segNum:Int = Int(sender.selectedSegmentIndex)
        
        dictInput.updateValue(String(describing: segNum), forKey: data.placeholder)

        if data.segBarTitles == creditCardNames.arr {
            currentCC_NumType = segNum
        }
        
        if isSim.isTrue { print("segNum: \(segNum)") }
        if isSim.isTrue { print("currentCC_NumType: \(currentCC_NumType)") }
        
        if data.multiDataReliantPlaceholder.isNotEmpty {
            sharedFunc.THREAD().doNow {
                NotificationCenter.default.post(name: Notification.Name("notification_blankRelatedInputField"),
                                              object: nil,
                                            userInfo: [data.multiDataReliantPlaceholder:""])
            }
        }
    }
    
    @IBAction func changeSwitch(_ sender:UISwitch){
        guard let data = self.inputFields[sender.tag] as InputTableStruct? else {
            return
        }
        
        somethingChanged = true
        
        dictInput.updateValue("\(NSNumber(value: sender.isOn))", forKey: data.placeholder)
    }
    
    @IBAction func left(_ sender:UIButton){
        self.view.endEditing(true)
        
        /* Bypass for autosave without asking user */
        if AutoSave.isTrue {
            switch leftButtonFunction {
            case .done,.back,.save:
                somethingChanged = true
                saveChanges(sender)
            default: ()
            }
        }

        var btn1_Title = "Yes".localizedCAS()
        var btn2_Title = "No".localizedCAS()
        var alert_Title = ""
        var alert_Msg = ""

        switch self.leftButtonFunction {
        case .account:
            alert_Title = "\("ExistingCustomer_Title".localizedCAS())?"
            alert_Msg = "ExistingCustomer_Msg".localizedCAS()
            btn1_Title = "Login".localizedCAS()
            btn2_Title = "Cancel".localizedCAS()
        case .done,.back,.save:
            alert_Title = "\("Save".localizedCAS())?"
        case .reset:
            alert_Title = "\("Clear Info".localizedCAS())?"
        default: ()
        }

        if alert_ShowAsAppleStandard.isFalse {
            let alert = CASAlertView(appearance: CASAlertView.CASAppearance(showCloseButton: false))

            alert.addButton(title: btn1_Title,backgroundColor: alert_ButtonColors[0]) {
                switch self.leftButtonFunction {
                case .done,.back,.save:
                    self.saveChanges(sender)
                    if self.NotificationCallbackName.isNotEmpty {
                        NotificationCenter.default.post(name: Notification.Name(self.NotificationCallbackName),object:nil)
                    }
                    self.dismiss(animated: true)
                case .account: ()
                case .reset,.clear: self.clearAllFields()
                }
            }

            alert.addButton(title: btn2_Title,backgroundColor: alert_ButtonColors[1]) {
                switch self.leftButtonFunction {
                case .done,.back,.save:
                    self.dismiss(animated: true)
                default: ()
                }
            }

            alert.showCustom(title: alert_Title,
                          subTitle: alert_Msg,
                             color: alert_ButtonColors[0],
                              icon: alert_IconImage.recolor(#colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)))
        }else{
            let alertController = UIAlertController(
                title: alert_Title,
                message: alert_ShowSubtitle ?alert_Msg :nil,
                preferredStyle: alert_ShowAsActionSheet ?.actionSheet :.alert
            )
            
            let action = UIAlertAction(title: btn1_Title, style: .default) { (action) -> Void in
                switch self.leftButtonFunction {
                case .done,.back,.save:
                    self.saveChanges(sender)
                    if self.NotificationCallbackName.isNotEmpty {
                        NotificationCenter.default.post(name: Notification.Name(self.NotificationCallbackName),object:nil)
                    }
                    self.dismiss(animated: true)
                case .account: ()
                case .reset,.clear: self.clearAllFields()
                }
            }

            let cancel = UIAlertAction(title: btn2_Title, style: .cancel) { (action) -> Void in
                switch self.leftButtonFunction {
                case .done,.back,.save:
                    self.dismiss(animated: true)
                default: ()
                }
            }

            action.setValue(alert_ButtonColors[0], forKey: "titleTextColor")
            cancel.setValue(alert_ButtonColors[1], forKey: "titleTextColor")
            
            alertController.addAction(action)
            alertController.addAction(cancel)

            alertController.view.tintColor = alert_TintColor
            
            self.present(alertController, animated: true)
        }
    }

    @IBAction func right(_ sender:UIButton){
        self.view.endEditing(true)

        /* Bypass for autosave without asking user */
        if AutoSave.isTrue {
            switch rightButtonFunction {
            case .done,.back,.save:
                somethingChanged = true
                saveChanges(sender)
            default: ()
            }
        }

        var btn1_Title = "Yes".localizedCAS()
        var btn2_Title = "No".localizedCAS()
        var alert_Title = ""
        var alert_Msg = ""
        
        switch rightButtonFunction {
        case .account:
            alert_Title = "\("ExistingCustomer_Title".localizedCAS())?"
            alert_Msg = "ExistingCustomer_Msg".localizedCAS()
            btn1_Title = "Login".localizedCAS()
            btn2_Title = "Cancel".localizedCAS()
        case .done,.back,.save:
            alert_Title = "\("Save".localizedCAS())?"
        case .reset:
            alert_Title = "\("Clear Info".localizedCAS())?"
        default: ()
        }
        
        if alert_ShowAsAppleStandard.isFalse {
            let alert = CASAlertView(appearance: CASAlertView.CASAppearance(showCloseButton: false))
        
            alert.addButton(title: btn1_Title) {
                switch self.rightButtonFunction {
                case .done,.back,.save: self.saveChanges(sender)
                case .account: ()
                case .reset,.clear: self.clearAllFields()
                }
            }
            
            alert.addButton(title: btn2_Title,backgroundColor: alert_ButtonColors[1]) {
                switch self.rightButtonFunction {
                case .done,.back,.save:
                    self.dismiss(animated: true)
                default: ()
                }
            }
            
            alert.showCustom(title: alert_Title,
                          subTitle: alert_Msg,
                             color: alert_ButtonColors[0],
                              icon: #imageLiteral(resourceName: "CAS_Edit").recolor(#colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)))
        }else{
            let alertController = UIAlertController(
                title: alert_Title,
                message: alert_Msg,
                preferredStyle: alert_ShowAsActionSheet ?.actionSheet :.alert
            )
            
            let action = UIAlertAction(title: btn1_Title, style: .default) { (action) -> Void in
                switch self.rightButtonFunction {
                case .done,.back,.save:
                    self.saveChanges(sender)
                case .account:
                    customerInfo.email = (alertController.textFields![0] as UITextField).text?.lowercased() ?? ""
                case .reset,.clear: self.clearAllFields()
                }
            }

            let cancel = UIAlertAction(title: btn2_Title, style: .default) { (action) -> Void in
                switch self.rightButtonFunction {
                case .done,.back,.save:
                    self.dismiss(animated: true)
                default: ()
                }
            }

            switch self.rightButtonFunction {
                case .account:
                    alertController.addTextField { (textField : UITextField!) -> Void in
                        textField.placeholder = "Enter email address"
                        textField.keyboardAppearance = .dark
                        textField.keyboardType = .emailAddress
                        textField.autocorrectionType = .no
                        textField.autocapitalizationType = .none
                        textField.returnKeyType = . search
                        textField.enablesReturnKeyAutomatically = true
                        textField.addTarget(
                            alertController,
                            action: #selector(alertController.textDidChangeInEmailAlert),
                            for: .editingChanged
                        )
                    }
                
                    action.isEnabled = false
                    action.setValue(APPTHEME.alert_ButtonEnabled, forKey: "titleTextColor")
                    action.setValue("--", forKey: "title")
                default: ()
            }

            action.setValue(APPTHEME.alert_ButtonEnabled, forKey: "titleTextColor")
            cancel.setValue(APPTHEME.alert_ButtonCancel, forKey: "titleTextColor")
            
            alertController.view.tintColor = alert_TintColor

            alertController.addAction(cancel)
            alertController.addAction(action)
            
            self.present(alertController, animated: true)
        }
    }
    
    
    // MARK: - *** TABLEVIEW ***
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFields.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = self.inputFields[indexPath.row] as InputTableStruct? else {
            return 0
        }
        
        switch data.cellType {
            case .photo: return 150
            default: return 66
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        guard let data = self.inputFields[row] as InputTableStruct? else {
            return UITableViewCell()
        }
        
        switch data.cellType {
// MARK: ├─➤ TEXT FIELDS
            case .text,.text_Phone,.text_Email,.text_Zipcode,.creditCard,.text_CVN,.text_Number,.text_Currency,
                 .text_Decimal,.text_Weight:
                let cell = setupInputCell(indexPath: indexPath)
                    cell.keepSubviewBackground = true
                    cell.lbl_Required.text = "Required".localizedCAS()
                    cell.lbl_Required.isHidden = !requiredFields.contains(data.placeholder)
                    cell.lbl_Required.textColor = gAppColor.withAlphaComponent(0.4)
                    cell.lbl_Required.backgroundColor = gAppColor.withAlphaComponent(0.1)

                let key = data.placeholder
                cell.txt_Item.placeholder = key.localizedCAS()

                if let item = dictInput[key] {
                    cell.txt_Item.text = item
                }else{
                    cell.txt_Item.text = data.value
                }

                cell.txt_Item.keyboardType = .default
                cell.txt_Item.autocapitalizationType = .sentences
                cell.txt_Item.delegate = self
                if isPhone.isTrue { cell.txt_Item.inputAccessoryView = numberInputView }
                
                switch data.cellType {
                    case .text_Decimal:
                        cell.txt_Item.delegate = nil
                        cell.txt_Item.addTarget(self, action: #selector(txtChangedDecimal(_:)), for: .editingChanged)
                        cell.txt_Item.keyboardType = .numberPad
                        
                        if data.decimalPlaces < 1 { // Show Decimal places stepper input view.
                            cell.txt_Item.inputAccessoryView = decimalInputView
                            stepDecimal.tag = row
                            stepDecimal.value = Double(data.decimalPlaces)
                        }
                        
                        cell.txt_Item.text = "\(dictInput[key] ?? "")"
                    case .text_Currency:
                        cell.txt_Item.delegate = nil
                        cell.txt_Item.addTarget(self, action: #selector(txtChangedCurrency(_:)), for: .editingChanged)
                        cell.txt_Item.keyboardType = .numberPad
                        cell.txt_Item.text = "\(dictInput[key] ?? "")"
                    case .text_Number:
                        cell.txt_Item.keyboardType = .numberPad
                        cell.txt_Item.text = "\(dictInput[key] ?? "")"
                    case .text_Weight:
                        cell.txt_Item.keyboardType = .numberPad
                        let value:String = dictInput[key] ?? ""
                        cell.txt_Item.text = "\(value)"
                        updateInputAccessoryViewText(value)
                    case .text_CVN:
                        cell.txt_Item.keyboardType = .numberPad
                        let value:String = dictInput[key] ?? ""
                        cell.txt_Item.text = "\(value)"
                        fld_CVN = row
                    case .creditCard:
                        cell.txt_Item.keyboardType = .numberPad
                        let CCNum = "\(dictInput[key] ?? "" )".removeSpaces
                        cell.txt_Item.text = sharedFunc.STRINGS().formatCreditCard(
                            numString: CCNum,
                            format: creditCardTypes(rawValue:currentCC_NumType)!,
                            spacerWidth: 1,
                            Protected: false
                        )
                        fld_CreditCard = row
                    case .text_Phone:
                        fld_Phone = row
                        cell.txt_Item.keyboardType = .phonePad
                    case .text_Email:
                        cell.txt_Item.keyboardType = .emailAddress
                        cell.txt_Item.autocapitalizationType = .none
                    case .text_Zipcode:
                        fld_Zip = row
                        let country:String! = dictInput["Country".localizedCAS()] ?? "US"
                        let countryCode = (country == "CA")
                            ?countries.canada.rawValue
                            :countries.usa.rawValue
                        cell.txt_Item.keyboardType = (countryCode == countries.usa.rawValue)
                            ?.numberPad
                            :.default
                        cell.txt_Item.autocapitalizationType = .none
                        cell.txt_Item.placeholder = (countryCode == countries.usa.rawValue)
                            ?"Zip Code".localizedCAS()
                            :"Postal Code".localizedCAS()
                    default: ()
                }
                
                cell.txt_Item.tag = row
                
                return cell
// MARK: ├─➤ SEGBAR
            case .segBar:
                let cell:cell_InputSegBar = tableView.dequeueReusableCell(withIdentifier: cellID.inputSegBar,for:indexPath) as! cell_InputSegBar
                    cell.keepSubviewBackground = true
                    cell.tag = row
                    sharedFunc.DRAW().roundCorner(view: cell.lbl_Required, radius: 5)
                    cell.lbl_Required.text = "Required".localizedCAS()
                    cell.lbl_Required.isHidden = !requiredFields.contains(data.placeholder)
                    cell.lbl_Required.textColor = gAppColor.withAlphaComponent(0.4)
                    cell.lbl_Required.backgroundColor = gAppColor.withAlphaComponent(0.1)
                    cell.vwLine.backgroundColor = gAppColor

                if data.segBarTitles.count < 1 {
                    return cell
                }
                
                /* Initialize segBar */
                cell.seg_Item.tintColor = gAppColor
                cell.lbl_Title.textColor = gAppColor
                cell.lbl_Title.text = data.placeholder
                cell.seg_Item.removeAllSegments()
                for i in 0..<data.segBarTitles.count {
                    if data.segShowImages.isTrue {
                        cell.seg_Item.insertSegment(withTitle: data.segBarTitles[i], at: i, animated: false)
                    }else{
                        cell.seg_Item.insertSegment(with: creditCardImgs_Mono[i], at: i, animated: false)
                    }
                    cell.seg_Item.addTarget(self, action: #selector(segChanged), for: .valueChanged)
                }
                
                /* set segment selection */
                let selection = dictInput[data.placeholder] ?? ""
                if selection.isNotEmpty {
                    var segIndex = Int(selection) ?? 0
                    if segIndex > cell.seg_Item.numberOfSegments {
                        segIndex = 0
                    }
                    cell.seg_Item.selectedSegmentIndex = segIndex
                }
                
                cell.seg_Item.tag = row
                
                return cell
// MARK: ├─➤ POPOVERS
            case .popover_Country,.popover_State,.popover_Month,.popover_Year,.popover_Array,.popover_Date,.popover_MultiArray: ()
                let cell = setupPopoverCell(indexPath: indexPath)
                    cell.keepSubviewBackground = true
                    cell.lbl_Required.text = "Required".localizedCAS()
                    cell.lbl_Required.isHidden = !requiredFields.contains(data.placeholder)
                    cell.lbl_Required.textColor = gAppColor.withAlphaComponent(0.4)
                    cell.lbl_Required.backgroundColor = gAppColor.withAlphaComponent(0.1)

                let placeholder = data.placeholder
                let item = dictInput[placeholder] ?? ""
            
                cell.btnRemove.isEnabled = item.isNotEmpty
                cell.btnRemove.alpha = item.isNotEmpty ?kAlpha.twothirds :kAlpha.quarter
                cell.btnRemove.setImage(cell.btnRemove.image(for: .normal)?.recolor(gAppColor), for: .normal)
                cell.btnRemove.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
                cell.btnRemove.tag = row
            
                switch data.cellType {
                    case .popover_Date:
                        cell.txt_Item.text = item
                        cell.txt_Item.placeholder = placeholder
                        cell.tag = row
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_Tap_Date:", delegate: self, numTaps: 1))
                    case .popover_MultiArray:
                        cell.txt_Item.text = item
                        cell.txt_Item.placeholder = placeholder
                        cell.tag = row
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_Tap_MultiArray:", delegate: self, numTaps: 1))
                    case .popover_Array:
                        cell.txt_Item.text = item
                        cell.txt_Item.placeholder = placeholder
                        cell.tag = row
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_Tap_Array:", delegate: self, numTaps: 1))
                    case .popover_Month:
                        let value:Int = (dictInput["Expiration Month".localizedCAS()] ?? "0").intValue
                        var item:String = ""
                        switch value {
                            case 1..<10: item = "0\(value)"
                            case 10...12: item = "\(value)"
                            default: item = ""
                        }
                        cell.txt_Item.text = item
                        cell.txt_Item.placeholder = placeholder.localizedCAS()
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_TapMonth:", delegate: self, numTaps: 1))
                    case .popover_Year:
                        let value:Int = (dictInput["Expiration Year".localizedCAS()] ?? "0").intValue
                        let item = (value > 0) ?"\(value)" :""

                        cell.txt_Item.text = item
                        cell.txt_Item.placeholder = placeholder.localizedCAS()
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_TapYear:", delegate: self, numTaps: 1))
                    case .popover_Country:
                        cell.txt_Item.text = item
                        cell.txt_Item.placeholder = placeholder.localizedCAS()
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_TapCountry:", delegate: self, numTaps: 1))
                    case .popover_State:
                        cell.txt_Item.placeholder = "State".localizedCAS()
                        cell.txt_Item.text = dictInput[placeholder] ?? ""
                        cell.lbl_Item.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_TapState:", delegate: self, numTaps: 1))
                    default: ()
                }
            
                return cell
// MARK: ├─➤ SWITCHES
            case .swtch:
                let cell:cell_InputSwitch = tableView.dequeueReusableCell(withIdentifier: cellID.inputSwitch,for:indexPath) as! cell_InputSwitch
                    cell.keepSubviewBackground = true
                    sharedFunc.DRAW().roundCorner(view: cell.lbl_Required, radius: 5)
                    cell.lbl_Required.text = "Required".localizedCAS()
                    cell.lbl_Required.isHidden = !requiredFields.contains(data.placeholder)
                    cell.lbl_Required.textColor = gAppColor.withAlphaComponent(0.4)
                    cell.lbl_Required.backgroundColor = gAppColor.withAlphaComponent(0.1)
                    cell.vwLine.backgroundColor = gAppColor
                    cell.sw_Item.tag = row
                
                let key = data.placeholder
                if let _ = dictInput[key] {
                    cell.sw_Item.isOn = (dictInput[key] ?? "0").boolValue
                }else{
                    cell.sw_Item.isOn = data.value.boolValue
                }
                
                cell.lbl_Item.text = key.localizedCAS()
                cell.lbl_Item.textColor = gAppColor
                
                return cell
// MARK: ├─➤ PHOTOS
            case .photo:
                let cell:cell_InputPhoto = tableView.dequeueReusableCell(withIdentifier: cellID.inputPhoto,for:indexPath) as! cell_InputPhoto
                    cell.keepSubviewBackground = true
                    sharedFunc.DRAW().roundCorner(view: cell.lbl_Required, radius: 5)
                    cell.lbl_Required.text = "Required".localizedCAS()
                    cell.lbl_Required.isHidden = !requiredFields.contains(data.placeholder)
                    cell.lbl_Required.textColor = gAppColor.withAlphaComponent(0.4)
                    cell.lbl_Required.backgroundColor = gAppColor.withAlphaComponent(0.1)
                    cell.vwLine.backgroundColor = gAppColor
                    cell.imgPhoto.tag = row
                
                let photoURL = dictInput[data.placeholder] ?? ""
                let photoPath = sharedFunc.FILES().dirDocuments(fileName: photoURL)
                cell.imgPhoto.image = photoURL.isNotEmpty ?UIImage(contentsOfFile: photoPath) :#imageLiteral(resourceName: "SelectPhoto")
                cell.imgPhoto.backgroundColor = .clear
                cell.imgPhoto.alpha = photoURL.isNotEmpty ?kAlpha.opaque :kAlpha.quarter
                if photoURL.isNotEmpty {
                    sharedFunc.DRAW().addShadow(view: cell.imgPhoto, offset: 2, radius: 3, opacity: Float(kAlpha.half))
                }else{
                    sharedFunc.DRAW().removeShadow(view: cell.imgPhoto)
                }
                
                cell.btnRemove.isEnabled = photoURL.isNotEmpty
                cell.btnRemove.alpha = photoURL.isNotEmpty ?kAlpha.twothirds :kAlpha.quarter
                cell.btnRemove.setImage(cell.btnRemove.image(for: .normal)?.recolor(gAppColor), for: .normal)
                cell.btnRemove.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
                cell.btnRemove.tag = row
                
                cell.imgPhoto.isUserInteractionEnabled = true
                cell.imgPhoto.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "gesture_Tap_Photo:", delegate: self, numTaps: 2))
                
                return cell
            default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
    }


// MARK: - *** TEXTFIELD METHODS ***
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedRow = textField.tag
        
        if textField.tag == fld_Zip {
            let countryCode = dictInput["Country".localizedCAS()] ?? "US"
            if countryCode == "CA" { // Canada X#X #X#
                let length:Int! = textField.text?.count
                switch length {
                    case 0,2,3,5: textField.keyboardType = .alphabet
                    default: textField.keyboardType = .numbersAndPunctuation
                }
                textField.reloadInputViews()
            }
        }
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        somethingChanged = true
        
        if textField.tag == fld_Zip {
            if countryCode == countries.canada.rawValue { // Canada X#X #X#
                let length:Int! = textField.text?.count
                switch length {
                    case 0,2,3,5: textField.keyboardType = .alphabet
                    default: textField.keyboardType = .numbersAndPunctuation
                }
                textField.reloadInputViews()
            }
        }
        
        /* Update dictionary with updated entry */
        guard let fields = self.inputFields[textField.tag] as InputTableStruct? else {
            return false
        }
        
        dictInput.updateValue("", forKey: fields.placeholder)

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var nextTag:Int = textField.tag
        
        if nextTag >= inputFields.count {
            nextTag = -1
        }
        
        repeat {
            nextTag += 1
            
            if let nextResponder = self.view.viewWithTag(nextTag) {
                if (nextResponder.isKind(of: HoshiTextField.self) || nextResponder.isKind(of: UITextField.self)) &&
                   nextResponder.isUserInteractionEnabled {
                    
                    guard let path = IndexPath(row: nextTag, section: 0) as IndexPath? else {
                        return false
                    }
                
                    table.scrollToRow(at: path, at: .top, animated: true)
                    nextResponder.becomeFirstResponder()

                    return false
                }
            }else{
                guard let path = IndexPath(row: 0, section: 0) as IndexPath? else { return false }

                table.scrollToRow(at: path as IndexPath, at: .top, animated: false)
                if let cell = self.table.cellForRow(at: path) as? cell_InputTextField {
                    cell.txt_Item.becomeFirstResponder()
                }

                return false
            }
        } while nextTag < (inputFields.count - 1)
       
        // No next text field found.
        textField.resignFirstResponder()
    
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var sText:String = textField.text!
        guard let data = self.inputFields[textField.tag] as InputTableStruct? else { return false }
        let cellType = data.cellType

        if (string == "\n") {
            /* Exit on RETURN key, Save the values before leaving into temp dict. */
            textField.resignFirstResponder()
        }else if string.isEmpty {
            somethingChanged = true

            /* With DELETE or BACKSPACE KEY, remove one character from text */
            if sText.length > 0 {
                sText = (sText as NSString).replacingCharacters(in: range, with: string)
            }
            
            if textField.tag == fld_Zip {
                let country:String! = dictInput["Country"] ?? "US"
                let countryCode = (country == "CA") ?countries.canada.rawValue :countries.usa.rawValue
                
                if countryCode == countries.canada.rawValue { // Canada X#X #X#
                    let length:Int! = sText.length
                    switch length {
                        case 0,2,3,5: textField.keyboardType = .alphabet
                        default: textField.keyboardType = .numbersAndPunctuation
                    }
                    textField.reloadInputViews()
                }
            }

            if cellType == .text_Number {
                sText = sharedFunc.STRINGS().formatAsNumber(string: sText, decimalPlaces: 0)
            }else if cellType == .text_Weight {
                sText = sharedFunc.STRINGS().formatAsNumber(string: sText, decimalPlaces: 0)
                updateInputAccessoryViewText(sText)
            }
        }else{
            /* Update the label of selected segment with new text. */
            sText = (sText as NSString).replacingCharacters(in: range, with: string)

            somethingChanged = true
        }
        
        /* Test certain fields for formatting */
        if string.isNotEmpty {
// MARK: ├─➤ Phone Number
            if textField.tag == fld_Phone {
                sText = sharedFunc.STRINGS().stripPhoneNumFormatting(text: sText)
                let numbersOnly = sharedFunc.STRINGS().containsValidCharacters(text: string, charSet: kCharSet.VALID.numbersOnly)
                
                // Numeric only
                if numbersOnly.isFalse || sText.count > 10 {
                    if isSim.isFalse {
                        sharedFunc.AUDIO().vibratePhone()
                    }
                    return false
                }else{
                    sText = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: sText)
                }
// MARK: ├─➤ Zip & Postal Code
            } else if textField.tag == fld_Zip {
                sText = sharedFunc.STRINGS().stripZipCodeFormatting(text: sText)
                let length:Int! = sText.length
                
                let country:String! = dictInput["Country"] ?? "US"
                let countryCodeRegion = (country == "CA") ?"CA" :"US"
                let countryCode = (country == "CA") ?countries.canada.rawValue :countries.usa.rawValue
                if countryCode == countries.canada.rawValue { // Canada X#X #X#
                    do {
                        try sharedFunc.TEXT().DataEntry_Length(length: length,max: 6)
                    } catch {
                        return false
                    }
                    
                    switch length {
                        case 1,3,5: // Alpha only
                            if string.isNotEmpty {
                                do {
                                    try sharedFunc.TEXT().DataEntry_InvalidChars(text: string,charSet:kCharSet.VALID.alphaOnly)
                                } catch {
                                    return false
                                }
                            }

                            textField.keyboardType = .numberPad
                        default: // numeric only
                            if string.isNotEmpty {
                                do {
                                    try sharedFunc.TEXT().DataEntry_InvalidChars(text: string,charSet:kCharSet.VALID.numbersOnly)
                                } catch {
                                    return false
                                }
                            }
                            
                            textField.keyboardType = .alphabet
                    }

                    sText = sharedFunc.STRINGS().formatZipCode(text: sText.uppercased(),countryCode:countryCodeRegion)
                    textField.reloadInputViews()
                }else{ // US is default #####-####
                    if string.isNotEmpty {
                        do {
                            try sharedFunc.TEXT().DataEntry_Length(length: length,max: 9)
                        } catch {
                            return false
                        }

                        do {
                            try sharedFunc.TEXT().DataEntry_InvalidChars(text: string,charSet:kCharSet.VALID.numbersOnly)
                        } catch {
                            return false
                        }
                    }

                    sText = sharedFunc.STRINGS().formatZipCode(text: sText,countryCode:countryCodeRegion)
                }
// MARK: ├─➤ Credit Card Number
            } else if textField.tag == fld_CreditCard {
                let numbersOnly = sharedFunc.STRINGS().containsValidCharacters(text: string, charSet: kCharSet.VALID.numbersOnly)
                
                var maxChars = 0
                if let type = creditCardTypes(rawValue:currentCC_NumType) {
                    switch type {
                        case .amex: maxChars = 15
                        case .visa,.mastercard,.discover: maxChars = 16
                    }
                }
                
                let temp = sText.removeSpaces
                if numbersOnly.isFalse || temp.count > maxChars {
                    if isSim.isFalse {
                        sharedFunc.AUDIO().vibratePhone()
                    }
                    return false
                }
                
                sText = sText.removeSpaces
                sText = sharedFunc.STRINGS().formatCreditCard(numString: sText,
                                                                 format: creditCardTypes(rawValue: currentCC_NumType)!,
                                                            spacerWidth: 1,
                                                              Protected: false)
// MARK: ├─➤ Number
            } else if (cellType == .text_Number) {
                let numbersOnly = sharedFunc.STRINGS().containsValidCharacters(text: string, charSet: kCharSet.VALID.decimalPad)
                
                if numbersOnly.isFalse {
                    if isSim.isFalse { sharedFunc.AUDIO().vibratePhone() }
                    return false
                }
                
                // Limit to 1 decimal point
                if sharedFunc.STRINGS().containsDecimalPoint(string:sText) && string == "." {
                    if isSim.isFalse { sharedFunc.AUDIO().vibratePhone() }
                    return false
                }

                sText = sharedFunc.STRINGS().formatAsNumber(string: sText, decimalPlaces: 0)
// MARK: ├─➤ Weight
            } else if (cellType == .text_Weight) {
                let numbersOnly = sharedFunc.STRINGS().containsValidCharacters(text: string, charSet: kCharSet.VALID.decimalPad)
                
                if numbersOnly.isFalse {
                    if isSim.isFalse { sharedFunc.AUDIO().vibratePhone() }
                    return false
                }
                
                // Limit to 1 decimal point
                if sharedFunc.STRINGS().containsDecimalPoint(string:sText) && string == "." {
                    if isSim.isFalse { sharedFunc.AUDIO().vibratePhone() }
                    return false
                }

                sText = sharedFunc.STRINGS().formatAsNumber(string: sText, decimalPlaces: 0)

                updateInputAccessoryViewText(sText)
// MARK: ├─➤ Credit Card CVN
            } else if textField.tag == fld_CVN {
                let numbersOnly = sharedFunc.STRINGS().containsValidCharacters(text: string, charSet: kCharSet.VALID.numbersOnly)
                
                var maxChars = 0
                if let type = creditCardTypes(rawValue:currentCC_NumType) {
                    switch type {
                        case .amex: maxChars = 4
                        case .visa,.mastercard,.discover: maxChars = 3
                    }
                }
                
                if numbersOnly.isFalse || sText.count > maxChars {
                    if isSim.isFalse {
                        sharedFunc.AUDIO().vibratePhone()
                    }
                    return false
                }
            }else{
// MARK: ├─➤ Default Alphanumeric
                let alphaNumericOnly = sharedFunc.STRINGS().containsValidCharacters(text: string, charSet: kCharSet.VALID.chars)
                
                // Alphanumeric only
                if alphaNumericOnly.isFalse {
                    if isSim.isFalse {
                        sharedFunc.AUDIO().vibratePhone()
                    }
                    return false
                }
            }
        }
        
        textField.text = sText
        
        /* Update dictionary with updated entry */
        guard let fields = self.inputFields[textField.tag] as InputTableStruct? else {
            return false
        }

        dictInput.updateValue(sText, forKey: fields.placeholder)
    
        return false
    }

    @IBAction func txtChangedCurrency(_ sender: HoshiTextField) { // Delegate for text field MUST be nil to work!
        if let amountString = sender.text?.currencyInputFormatting() {
            sender.text = amountString
            
            /* Update dictionary with updated entry */
            guard let fields = self.inputFields[sender.tag] as InputTableStruct? else { return }

            dictInput.updateValue(amountString, forKey: fields.placeholder)
        }
    }
    
    @objc func txtChangedDecimal(_ sender: HoshiTextField) { // Delegate for text field MUST be nil to work!
        guard let fields = self.inputFields[sender.tag] as InputTableStruct? else { return }

        let decimalPlaces = fields.decimalPlaces
        
        if let amountString = sender.text?.decimalInputFormatting(decimalPlaces: decimalPlaces) {
            sender.text = amountString
            
            /* Update dictionary with updated entry */
            dictInput.updateValue(amountString, forKey: fields.placeholder)
        }
    }
    
    @objc func numDecimalPlacesChanged(_ sender:UIStepper){
        let row = sender.tag
        guard var fields = inputFields[row] as InputTableStruct? else { return }

        let decimalPlaces = Int(sender.value)
            fields.decimalPlaces = decimalPlaces
        
        let item = dictInput[fields.placeholder]
        guard let cell = table.cellForRow(at: IndexPath(row:row,section:0)) as? cell_InputTextField else { return }
        
        if let amountString = item?.decimalInputFormatting(decimalPlaces: decimalPlaces) {
            cell.txt_Item.text = amountString
            
            /* Update dictionary with updated entry */
            dictInput.updateValue(amountString, forKey: fields.placeholder)
        }
    }
    
    
// MARK: - *** IMAGE PICKER ***
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            sharedFunc.ALERT().show(
                title:"IMAGE_GetError_Title".localizedCAS(),
                style:.error,
                msg:"IMAGE_GetError_Msg".localizedCAS()
            )
            picker.dismiss(animated: true)
            return
        }

        let fileName = "photoForItemIndx_\( SQL_EditRecordIndex ).jpg"
        
        do {
            let fileURL = try! FileManager.default
                .url(for: .documentDirectory,in: .userDomainMask,appropriateFor: nil,create: false)
                .appendingPathComponent(fileName)

            try chosenImage.jpegData(compressionQuality: 0.50)?
                .write(to: fileURL, options: .atomic)

            somethingChanged = true
        } catch {
            sharedFunc.ALERT().show(
                title:"IMAGE_GetError_Title".localizedCAS(),
                style:.error,
                msg:"IMAGE_GetError_Msg".localizedCAS()
            )
            picker.dismiss(animated: true)
            return
        }
    
        let index = imgPicker.view.tag
        guard let fields = self.inputFields[index] as InputTableStruct? else { return }
        
        dictInput.updateValue(fileName, forKey: fields.placeholder)
        
        table.reloadData()

        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
// MARK: - *** GESTURES ***
    @objc func gesture_Tap_Photo(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        if getPhotoLibraryPermissionStatus().isFalse { // Get the current authorization state.
            return
        }

        selectedRow = (sender.view?.tag)!
        selectPhotoFromLibrary()
    }
    
    @objc func gesture_Tap_Date(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        let row = sender.view?.tag ?? nil
        if row != nil {
            guard let data = inputFields[row!] as InputTableStruct? else { return }
            guard let value = dictInput[data.placeholder] as String? else { return }
        
            gSender.Data = []
            gSender.SelectedItem = 0
            gSender.Type = "Date"
            gSender.Category = .date
            gSender.Title = "Select Date"
            gSender.NotificationCallbackName = "notification_DateChanged"
            gSender.Key = data.placeholder
            gSender.date = value.isNotEmpty ?value.convertToDate(format: kDateFormat.MMM_d_yyyy) :Date()
            
            presentPickerPopover(sender: sender,
                                   size: CGSize(width:250,height: 216),
                                  title: gSender.Title,
                              iconImage: #imageLiteral(resourceName: "CAS_Picker_Date"),
                            showToolBar: false,
                           isDatePicker: true,
                   pickerMaxDateIsToday: true )
        }
    }

    @objc func gesture_Tap_MultiArray(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        let row = sender.view?.tag ?? nil
        if row != nil {
            guard var data = inputFields[row!] as InputTableStruct?,
                  let value = dictInput[data.placeholder] as String?,
                  let dataKey = data.multiDataKeys.last as String?
            else {
                return
            }

            /* Check that related if (if one) is filled out */
            let reliantField:String = data.multiDataReliantPlaceholder
            let reliantDataKey:String = data.multiDataReliantDataKey
            
            /* RELIANT FIELD contains data, get it to filter first column */
            if reliantField.isNotEmpty && reliantDataKey.isNotEmpty {
                let reliantFieldContents = dictInput[reliantField] as String?
                
                if (reliantFieldContents?.isNotEmpty)! {
                    /* Filter first column on reliant field contents */
                    let colData = data.multiDataRecords.filter{ $0[reliantDataKey] as? String == reliantFieldContents }
                    let colDataKey = data.multiDataKeys[0]
                    var filteredData:[String] = ["--"]
                    for item in colData {
                        let itemName = (item[colDataKey] as? String ?? "").trimSpaces
                        
                        if itemName.isNotEmpty && !filteredData.contains(itemName) {
                            filteredData.append(itemName)
                        }
                    }
                    
                    filteredData.sort { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending }
                    data.multiData[0] = filteredData
                }else{
                    sharedFunc.ALERT().show(
                        title:"InputData_ReliantFldBlank_Title".localizedCAS(),
                        style:.error,
                        msg:"InputData_ReliantFldBlank_Msg".localizedCAS()
                    )
                    return
                }
            }
            
            /* Create Selected Rows */
            let record = data.multiDataRecords.filter{ $0[dataKey] as? String == value }
            let indx = record.first?["indx"] as? Int ?? NSNotFound
            if indx != NSNotFound {
                data.multiDataSelections = []
                for i in 0..<data.multiData.count {
                    let item = record.first?[data.multiDataKeys[i]] as? String ?? ""
                    data.multiDataSelections.append(item)
                }
            }
   
            gSender.Data = []
            gSender.multiData = data.multiData
            gSender.multiDataRecords = data.multiDataRecords
            gSender.multiDataSelections = data.multiDataSelections
            gSender.multiDataWidths = data.multiDataWidths
            gSender.multiDataColors = data.multiDataColors
            gSender.multiDataReliantPlaceholder = ""
            gSender.SelectedItem = 0
            gSender.Type = ""
            gSender.Category = .multiColList
            gSender.Title = data.placeholder
            gSender.NotificationCallbackName = "notification_UpdateFromMultipleData"
            gSender.Key = data.placeholder
            
            presentPickerPopover(sender: sender,
                                   size: CGSize(width: isPad.isTrue ?600 :320,height: 216),
                                  title: gSender.Title,
                              iconImage: data.image,
                            showToolBar: false,
                           isDatePicker: false,
                   pickerMaxDateIsToday: false,
                             isMultiCol: true,
                          multi_ColData: data.multiData,
                      multi_ColDataKeys: data.multiDataKeys,
                        multi_ColWidths: data.multiDataWidths,
                        multi_ColColors: data.multiDataColors,
                              font_Text: UIFont(name: Font.Avenir.Light.regular, size: isPad.isTrue ?32 :14)
             )
        }
    }

    @objc func gesture_Tap_Array(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        let row = sender.view?.tag ?? NSNotFound
        if row == NSNotFound { return }
        
        guard let data = self.inputFields[row] as InputTableStruct?,
              let popoverData = self.inputFields[row].popoverData as [String]?
        else {
            return
        }

        gSender.Data = popoverData as NSArray
        gSender.Key = Category
        gSender.Title = data.placeholder
        gSender.Placeholder = data.placeholder
        let currentValue = dictInput[data.placeholder] ?? ""
        gSender.ValueText = currentValue
        gSender.SelectedItem = gSender.Data.index(of: currentValue)
        gSender.NotificationCallbackName = "notification_UpdateFromArray"
        gSender.multiDataReliantPlaceholder = data.multiDataReliantPlaceholder
        
        if data.showAsPicker.isTrue {
            gSender.isEditable = false

            var imgIcon:String = "CAS_Picker_List"
            
            if data.isEditable.isTrue {
                gSender.Category = .list_Add_Edit_Delete
                gSender.SQL_Database = appInfo.DB.data
                switch data.dataKey {
                    case "manufacturer":
                        gSender.SQL_Tablename = "tblManufacturers"
                        gSender.SQL_Fieldname = "manufacturer"
                        gSender.SQL_Categoryname = "category"
                        gSender.Title = "Manufacturers"
                        imgIcon = "CAS_Picker_Factory"
                    case "vendor":
                        gSender.SQL_Tablename = "tblVendors"
                        gSender.SQL_Fieldname = "name"
                        gSender.Key = "vendor"
                        gSender.SQL_Categoryname = ""
                        gSender.Title = "Vendors"
                        imgIcon = "CAS_Picker_Store"
                    default:
                        gSender.SQL_Tablename = ""
                        gSender.SQL_Fieldname = ""
                        gSender.SQL_Categoryname = ""
                        imgIcon = "CAS_Picker_List"
                }
                
                let btnAdd = UIBarButtonItem.btnAdd
                let btnEdit = UIBarButtonItem.btnEdit
                let btnDelete = UIBarButtonItem.btnDelete
                let flexibleSpace = UIBarButtonItem.flexibleSpace
                let fixedSpace = UIBarButtonItem.fixedSpace
                    fixedSpace.width = 6
                let showToolBar = true

                presentPickerPopover(sender: sender,
                                       size: CGSize(width: isPad.isTrue ?500 :320,height: showToolBar ?248 :204),
                                      title: gSender.Title,
                                  iconImage: UIImage(named:imgIcon),
                                showToolBar: showToolBar,
                              toolbarColors: [gAppColor,gAppColor,#colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)],
                             toolbarButtons: [fixedSpace,btnAdd,
                                              flexibleSpace,btnEdit,
                                              flexibleSpace,btnDelete,
                                              fixedSpace],
                     toolbarButtonCallbacks: ["notification_addSelected",
                                              "notification_editSelected",
                                              "notification_deleteSelected"],
                     font_Text: UIFont(name: Font.Avenir.Light.regular, size: isPad.isTrue ?32 :18)
                )
            }else{
                gSender.Category = .simpleList
                
                if data.dataKey == "hardwareType" {
                    imgIcon = "CAS_Picker_List"
                }
                
                presentPickerPopover(sender: sender,
                                       size: CGSize(width: isPad.isTrue ?500 :320,height: 204),
                                      title: gSender.Title,
                                  iconImage: UIImage(named:imgIcon),
                                showToolBar: false,
                                  font_Text: UIFont(name: Font.Avenir.Light.regular, size: isPad.isTrue ?32 :18)
                )
            }
        }else{
            gSender.Data = popoverData as NSArray
            gSender.Category = .simpleList
            gSender.Key = Category
            gSender.Title = data.placeholder
            gSender.ValueText = dictInput[data.placeholder] ?? ""
            gSender.NotificationCallbackName = "notification_UpdateFromArray"
            gSender.isEditable = false
            
            presentTablePopover(sender: sender,size:CGSize(width:220,height:220))
        }
    }

    @objc func gesture_TapMonth(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        gSender.Category = .simpleList
        gSender.Title = "Month".localizedCAS()
        var months:Array<String> = []
        for i in 1...12 {
            let numString = (i < 10) ?"0\(i)" :"\(i)"
            months.append("\(numString) (\(sharedFunc.DATES().returnMonthNameFromNum(monthNum: i).Name.localizedCAS()))")
        }
        
        gSender.Data = months as NSArray
        gSender.Key = "Expiration Month".localizedCAS()
        let month:Int = "\(dictInput[gSender.Key]!)".intValue
        let monthPadded:String = (month < 10) ?"0\(month)" :"\(month)"
        let monthString:String = (month > 0) ?"\(monthPadded) (\(sharedFunc.DATES().returnMonthNameFromNum(monthNum: month).Name.localizedCAS()))" :""
        gSender.ValueText = monthString
        gSender.NotificationCallbackName = "notification_UpdateFromArray"
        gSender.isEditable = false

        presentTablePopover(sender: sender,size:CGSize(width:180, height:200))
    }
    
    @objc func gesture_TapYear(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        gSender.Category = .simpleList
        gSender.Title = "Year".localizedCAS()
        let currentYear:Int! = Date().yearNum

        var expYears:[String] = []
        for i in 0..<9 {
            expYears.append("\(currentYear! + i)")
        }
        gSender.Data = expYears as NSArray
        
        gSender.Key = "Expiration Year"
        let year = dictInput[gSender.Key]?.intValue ?? 0
        let yearString = "\(year)"
        gSender.ValueText = yearString
        gSender.NotificationCallbackName = "notification_UpdateFromArray"
        gSender.isEditable = false

        presentTablePopover(sender: sender,size:CGSize(width:190,height:190))
    }
    
    @objc func gesture_TapState(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        gSender = SENDER_INFO.init()
        
        var states = Jurisdictions.US.StatesAndDCAndPR
            states.sort{ $0.name < $1.name }
        gSender.Data = []
        for state in states {
            gSender.Data = gSender.Data.adding(["Name":state.name,"Code":state.code]) as NSArray?
        }
        
        gSender.Category = .jurisdictionList
        gSender.Title = "State".localizedCAS()
        gSender.ValueText = dictInput["State".localizedCAS()] ?? ""
        gSender.NotificationCallbackName = "notification_UpdateState"
        gSender.isEditable = false

        presentTablePopover(sender: sender,size:CGSize(width:250,height:300))
    }

    @objc func gesture_TapCountry(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)

        let countries:[Jurisdictions.JurisdictionStruct] = Jurisdictions().returnJurisdictionForCode("US", andType: .country)
//            countries = countries + Jurisdictions().returnJurisdictionForCode("CA", andType: .country)
        
        gSender.Data = []
        for country in countries {
            gSender.Data = gSender.Data.adding(["Name":country.name,"Code":country.code,"FlagImgName":country.flagImgName]) as NSArray?
        }
        gSender.Category = .countryList
        gSender.Title = "Country".localizedCAS()
        gSender.ValueText = dictInput["Country".localizedCAS()] ?? ""
        gSender.NotificationCallbackName = "notification_UpdateCountry"
        gSender.isEditable = false
        
        presentTablePopover(sender: sender,size:CGSize(width:220,height:120))
    }
    

// MARK: - *** NOTIFICATIONS ***
    @objc func notification_blankRelatedInputField(_ sender: Notification) {
        guard let key = sender.userInfo!.first!.0 as? String else { return }
        
        somethingChanged = true
        if key.uppercased() == "RESET" {
            clearAllFields(exceptCurrentKey:true)
        }else{
            dictInput.updateValue("", forKey: key)
        }
        
        table.reloadData()
    }

    @objc func notification_DateChanged(_ sender: Notification) {
        guard let key = sender.userInfo!.first!.0 as? String,
              var value = sender.userInfo!.first!.1 as? String
        else { return }

        value = DateFormatter().MMMdyyyy.string(from: value.convertToDate(format: kDateFormat.DATE))
        
        somethingChanged = true
        dictInput.updateValue(value, forKey: key)
        table.reloadData()
    }

    @objc func notification_UpdateFromMultipleData(_ sender: Notification) {
        guard let key = sender.userInfo!.first!.0 as? String,
              let value = sender.userInfo!.first!.1 as? String
        else { return }
        
        somethingChanged = true
        dictInput.updateValue(value, forKey: key)
        table.reloadData()
    }
    
    @objc func notification_UpdateFromArray(_ sender: Notification) {
        guard let userInfo = sender.userInfo as? [String:Any] else { return }

        let key = gSender.Key ?? ""
        let value = userInfo[key] as? String ?? ""
        
        somethingChanged = true
        dictInput.updateValue(value, forKey: key)
        table.reloadData()
    }
    
    @objc func notification_UpdateState(_ sender: Notification) {
        somethingChanged = true
        
        let key = "State"
        guard let value = sender.userInfo?[key] as? String else { return }
        
        dictInput.updateValue(value, forKey: key.localizedCAS())
        table.reloadData()
    }
    
    @objc func notification_UpdateCountry(_ sender: Notification) {
        let country = sender.userInfo?["Code"] as? String ?? ""

        somethingChanged = true
        countryCode = countries.usa.rawValue
        dictInput.updateValue(country, forKey: "Country".localizedCAS())

//        let oldCountry = dictInput["Country".localizedCAS()] ?? ""
//        if oldCountry != country {
//            countryCode = (country == "CA") ?countries.canada.rawValue :countries.usa.rawValue
//            // Blank out related fields
//            dictInput.updateValue(country, forKey: "Country".localizedCAS())
//            dictInput.updateValue("", forKey: "State".localizedCAS())
//            dictInput.updateValue("", forKey: "Zip Code".localizedCAS())
//        }
        
        table.reloadData()
    }
    
    func notification_InputTable_UpdateArray(_ sender: Notification) {
        somethingChanged = true
        
        let key = "Array"
        guard let value = sender.userInfo?[key] as? String else { return }
        
        dictInput.updateValue(value, forKey: key)
        table.reloadData()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if isPad { return }
            
        guard let keyboardHt = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }

        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHt + 25, right: 0.0)
        
        table.contentInset = contentInsets
        table.scrollIndicatorInsets = contentInsets
    }
     
    @objc func keyboardWillHide(_ sender: Notification) {
        if isPad { return }

        table.contentInset = UIEdgeInsets.zero
        table.scrollIndicatorInsets = UIEdgeInsets.zero
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
        table.backgroundColor = gAppColor.withAlphaComponent(0.05)
        table.isOpaque = false
        
        imgPicker.delegate = self
        
        /* Decimal Input View */
        decimalInputView = UIView(frame: CGRect(x:0,y: 0,width: UIScreen.main.bounds.width,height: 50))
        decimalInputView.backgroundColor = #colorLiteral(red: 0.475, green: 0.502, blue: 0.53, alpha: 1)
        
        let lbl = UILabel(frame: CGRect(x:0,y: 0,width: 130,height: 50))
            lbl.textAlignment = .right
            lbl.text = "Decimal Places:"
            lbl.textColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)

        stepDecimal = UIStepper(frame: CGRect(x:140,y: 10,width: 94,height: 29))
            stepDecimal.tintColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
            stepDecimal.minimumValue = 0
            stepDecimal.maximumValue = 4
            stepDecimal.addTarget(self, action: #selector(numDecimalPlacesChanged(_:)), for: .valueChanged)
        
        decimalInputView.addSubview(lbl)
        decimalInputView.addSubview(stepDecimal)
        
        /* Number Input View */
        numberInputView = UIView(frame: CGRect(x:0,y: 0,width: UIScreen.main.bounds.width,height: 30))
            numberInputView_Text.backgroundColor = .clear
            numberInputView_Text.isOpaque = false
            numberInputView.backgroundColor = #colorLiteral(red: 0.475, green: 0.502, blue: 0.53, alpha: 1).withAlphaComponent(kAlpha.threequarter)
        
        toolbar = UIToolbar(frame: CGRect(x:0,y: -10,width: UIScreen.main.bounds.width,height: 36))
        
        let fixedSpace = UIBarButtonItem.fixedSpace
            fixedSpace.width = 6

        btnNext = UIBarButtonItem(title: "Next▶︎", style: .plain, target: self, action: #selector(btnNextPressed))
            btnNext.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnNext.setTitleTextAttributes([.font:APPFONTS().buttonTitles!,.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .normal)
        btnPrev = UIBarButtonItem(title: "◀︎Prev", style: .plain, target: self, action: #selector(btnPrevPressed))
            btnPrev.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnPrev.setTitleTextAttributes([.font:APPFONTS().buttonTitles!,.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .normal)
        btnHide = UIBarButtonItem(title: "Hide▼", style: .plain, target: self, action: #selector(btnHidePressed))
            btnHide.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnHide.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnHide.setTitleTextAttributes([.font:APPFONTS().buttonTitles!,.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .normal)
        
        toolbar.items = [
            fixedSpace,
            btnPrev,
            fixedSpace,
            fixedSpace,
            btnNext,
            UIBarButtonItem.flexibleSpace,
            btnHide,
            fixedSpace
        ]

        toolbar.barStyle = .default
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.isTranslucent = true
        toolbar.isOpaque = false
        toolbar.backgroundColor = .clear
        toolbar.barTintColor = .clear
        toolbar.tintColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)

        numberInputView.addSubview(toolbar)
        
        numberInputView_Text = UILabel(frame: CGRect(x:10,y: 0,width: UIScreen.main.bounds.width - 60,height: 44))
            numberInputView_Text.backgroundColor = .clear
            numberInputView_Text.isOpaque = false
            numberInputView_Text.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            numberInputView_Text.text = ""
            numberInputView_Text.tag = 99
        
        numberInputView.addSubview(numberInputView_Text)
        
        /* Load Defaults */
        initializeData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Appearance */
        
        /* Validate parameter settings */
        if (saveToDefaults == false && SQL_TableName.isEmpty) {
            sharedFunc.ALERT().show(
                title:"SQL_BlankTableError_Title".localizedCAS(),
                style:.error,
                msg:"SQL_BlankTableError_Msg".localizedCAS()
            )
        }

        if saveToDefaults.isTrue && treatAsEdit.isTrue {
            sharedFunc.ALERT().show(
                title:"SQL_TreatEditError1_Title".localizedCAS(),
                style:.error,
                msg:"SQL_TreatEditError1_Msg".localizedCAS()
            )
        }
        
        if saveToDefaults.isFalse && treatAsEdit.isFalse && (SQL_EditRecordIndex >= 0) {
            sharedFunc.ALERT().show(
                title:"SQL_TreatEditError2_Title".localizedCAS(),
                style:.error,
                msg:"SQL_TreatEditError2_Msg".localizedCAS()
            )
        }
    
        lbl_Title.text = titleText.isNotEmpty ?titleText :""
        
        btn_Left.setImage(showLeftButtonAsImage ?leftButtonImage :UIImage(), for: .normal)
        btn_Left.setTitle(showLeftButtonAsImage ?"" :" \(leftButtonTitles[0])", for: .normal)
        btn_Left.setTitleColor(showLeftButtonAsImage ?.clear :leftButtonTitleColors[0], for: .normal)

        btn_Right.setImage(showRightButtonAsImage ?rightButtonImage :UIImage(), for: .normal)
        btn_Right.setTitle(showRightButtonAsImage ?"" :"\(rightButtonTitles[0]) ", for: .normal)
        btn_Right.setTitleColor(showRightButtonAsImage ?.clear :rightButtonTitleColors[0], for: .normal)
        
        // Notifications
        let NC = NotificationCenter.default
            NC.addObserver(self,selector:#selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification,object: nil)
            NC.addObserver(self,selector:#selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification,object: nil)
            NC.addObserver(self,selector:#selector(notification_UpdateState(_:)), name:NSNotification.Name("notification_UpdateState"),object: nil)
            NC.addObserver(self,selector:#selector(notification_UpdateCountry(_:)), name:NSNotification.Name("notification_UpdateCountry"),object: nil)
            NC.addObserver(self,selector:#selector(notification_UpdateFromArray(_:)), name:NSNotification.Name("notification_UpdateFromArray"),object: nil)
            NC.addObserver(self,selector:#selector(notification_DateChanged(_:)), name:NSNotification.Name("notification_DateChanged"),object: nil)
            NC.addObserver(self,selector:#selector(notification_UpdateFromMultipleData(_:)), name:NSNotification.Name("notification_UpdateFromMultipleData"),object: nil)
            NC.addObserver(self,selector:#selector(notification_blankRelatedInputField(_:)), name:NSNotification.Name("notification_blankRelatedInputField"),object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        /* Appearance */
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
        
        toolbar.sizeToFit() // sets colors for toolbar and it's contents defined in view did load
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /* Notifications */
        let NC = NotificationCenter.default
            NC.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NC.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_UpdateState"), object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_UpdateCountry"), object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_UpdateFromArray"), object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_DateChanged"), object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_UpdateFromMultipleData"), object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_blankRelatedInputField"), object: nil)
    }
    
    
    // MARK: - *** DECLARATIONS (Outlets) ***
//    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btn_Left:UIButton!
    @IBOutlet weak var btn_Right:UIButton!
    @IBOutlet weak var table:UITableView!
    @IBOutlet weak var lbl_Title:UILabel!
    @IBOutlet weak var vw_Topbar:UIView!

    // MARK: - *** DECLARATIONS (Variables) ***
    enum countries:Int { case usa,canada }
    enum functions:Int { case reset,save,account,done,back,clear }
 
    var toolbar:UIToolbar! = UIToolbar.init()
    var btnNext:UIBarButtonItem! = UIBarButtonItem.init()
    var btnPrev:UIBarButtonItem! = UIBarButtonItem.init()
    var btnHide:UIBarButtonItem! = UIBarButtonItem.init()
    var placeholderText:String = ""
    var fld_CVN:Int! = -1
    var fld_CreditCard:Int! = -1
    var fld_Zip:Int! = -1
    var fld_Phone:Int! = -1
    var fld_Number:Int! = 9999
    var countryCode:Int! = countries.usa.rawValue
    var dictInput:[String:String] = [:]
    var requiredFields:[String] = []
    var somethingChanged:Bool = false
    var useFirstAndLastName:Bool = true
    var currentCC_NumType:Int = 0
    var imgPicker = UIImagePickerController()
    var numberInputView:UIView = UIView.init()
    var numberInputView_Text:UILabel = UILabel()
    var decimalInputView:UIView = UIView.init()
    var stepDecimal:UIStepper = UIStepper.init()
    var selectedRow:Int = 0
    
    /* User Defined Parameters for DATA to be passed from calling VC */
    var inputFields:[InputTableStruct] = []
    var treatAsEdit:Bool = false
    var saveToDefaults:Bool = false
    var bypassSave:Bool = false
    var SQL_EditRecordIndex:Int = -1
    var SQL_TableName:String = ""
    var Style:String = ""
    var Category:String = ""
    var NotificationCallbackName:String = ""
    var titleText:String = ""
    var decimalPlaces:Int = 0
    var AutoSave:Bool = false
    
    /* User Defined Parameters for APPEARANCE to be passed from calling VC */
    var showStatusMessageOnClose:Bool = true

    var alert_ShowAsAppleStandard:Bool = false
    var alert_IconImage:UIImage = #imageLiteral(resourceName: "CAS_Confirm")
    var alert_ShowAsActionSheet:Bool = false
    var alert_ShowSubtitle:Bool = true
    var alert_ButtonColors:[UIColor] = [APPTHEME.alert_ButtonCancel,APPTHEME.alert_ButtonEnabled]
    var alert_TintColor:UIColor = gAppColor
    
    var showLeftButtonAsImage:Bool = true
    var leftButtonImage:UIImage = #imageLiteral(resourceName: "Back").recolor(gAppColor)
    var leftButtonTitles:[String] = ["Cancel".localizedCAS(),"Save".localizedCAS(),"Update".localizedCAS()]
    var leftButtonTitleColors:[UIColor] = [APPTHEME.alert_ButtonCancel,APPTHEME.alert_ButtonEnabled,APPTHEME.alert_ButtonEnabled]
    var leftButtonFunction:functions = .save

    var showRightButtonAsImage:Bool = true
    var rightButtonImage:UIImage = #imageLiteral(resourceName: "Trashcan2").recolor(gAppColor)
    var rightButtonTitles:[String] = ["Reset".localizedCAS()]
    var rightButtonTitleColors:[UIColor] = [APPTHEME.alert_ButtonCancel,APPTHEME.alert_ButtonEnabled]
    var rightButtonFunction:functions = .reset
    
    var borderColor_Active:UIColor = APPTHEME.borderColor_Active
    var borderColor_Inactive:UIColor = APPTHEME.borderColor_Inactive
    var placeholderColor:UIColor = APPTHEME.placeholderColor
    var textColor:UIColor = APPTHEME.textColor
    var textFont:UIFont = UIFont.systemFont(ofSize: 18)
    
    // MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let inputText            = "cell_InputTextField"
        static let inputSwitch          = "cell_InputSwitch"
        static let inputSegBar          = "cell_InputSegBar"
        static let inputPhoto           = "cell_InputPhoto"
        static let inputPopoverTable    = "cell_InputPopoverTable"
    }
}

//extension HoshiTextField {
//    override open func caretRect(for position: UITextPosition) -> CGRect {
//        return CGRect.zero
//    }
//
//    override open var selectedTextRange: UITextRange? {
//        get {
//            return nil
//        }
//
//        set {
//            return
//        }
//    }
//}

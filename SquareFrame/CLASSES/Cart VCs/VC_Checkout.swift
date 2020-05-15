/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_Checkout.swift
 Author: Kevin Messina
Created: August 31, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftyJSON
import Alamofire
import ContactsUI
import Stripe

// MARK: - *** GLOBAL CONSTANTS ***

class VC_Checkout:UIViewController,
                  UITableViewDelegate,UITableViewDataSource,
                  CNContactPickerDelegate,
                  StripeControllerDelegate,
                  UIGestureRecognizerDelegate,
                  UIPopoverPresentationControllerDelegate
{
    
    func adaptivePresentationStyle(for controller:UIPresentationController,traitCollection:UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    func scrollTable(
        indexPath:IndexPath,
        scrollPosition:UITableView.ScrollPosition? = .bottom,
        animated:Bool? = false,
        delay:Double? = 0.15
    ) {
        if let _ = self.table.cellForRow(at: IndexPath(row:0,section:rowType.shipTo.rawValue)) as? cell_ShipTo {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay!) {
                self.table.scrollToRow(at: indexPath, at: scrollPosition!, animated: animated!)
            }
        }
    }
    
    @objc func getCustomerNumberFromEmail(email:String,updateCustomerInfo:Bool,completion: @escaping (Bool,Int,Int) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,-1,-1) }
        if email.isEmpty {
            sharedFunc.ALERT().show(
                title:"Server.noEmail.Title".localized(),
                style:.error,
                msg:"Server.noEmail.Msg".localized()
            )
            return completion(false,-1,-1)
        }
        
        if order.customer_countryCode.isEmpty {  order.customer_countryCode = "US" }
        
        Customers().searchByEmailOrAdd(showMsg: true, email: email) { (success, customerRec, addressRec, error) in
            order.customerNum = "-1"
            order.customerID = -1
            customerInfo.ID = -1
            customerInfo.address.id = -1
            shippingAddresses = []
            
            if success {
                order.customerNum = "\( customerRec.id )"
                order.customerID = customerRec.id
                customerInfo.ID = customerRec.id
                customerInfo.address.id = addressRec.id
                
                if updateCustomerInfo {
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
                            email: addressRec.email,
                            moltinID: addressRec.moltinID
                        )
                    )
                    
                    appFunc.keychain.MYINFO().save()
                }

                simPrint().info("customerRec.id: \( customerRec.id ) addressRec.id: \( addressRec.id )",function:#function,line:#line)
                
                if (customerRec.id > 0) {
                    self.getCustomerAddresses()
                    completion(true, customerRec.id,addressRec.id)
                }else{
                    sharedFunc.ALERT().show(
                        title:"Server.CustomerAddError.Title".localized(),
                        style:.error,
                        msg:"Server.CustomerAddError.Msg".localized()
                    )
                    return completion(false,-1,-1)
                }
            }else{
                sharedFunc.ALERT().show(
                    title:"Server.CustomerAddError.Title".localized(),
                    style:.error,
                    msg:"Server.CustomerAddError.Msg".localized()
                )
                return completion(false,-1,-1)
            }
        }
    }

    func getCustomerAddresses() {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }
        
        simPrint().info("getCustomerAddresses - customerInfo.ID: \( customerInfo.ID! )",function:#function,line:#line)

        if (customerInfo.ID! < 1) {
            simPrint().error("No customerID found for this customer: \( customerInfo.ID! )",function:#function,line:#line)
            shippingAddresses = []
        }else{
            Customers.address().search(showMsg: true, customerID: customerInfo.ID!) { (success, addressRecords, error) in
                waitHUD().hideNow()
                shippingAddresses = success
                    ?addressRecords.sorted(by: { (($0.lastName < $1.lastName) && ($0.firstName < $1.firstName)) })
                    :[]
            
                simPrint().error("Saved Addresses: \( shippingAddresses.count )",function:#function,line:#line)
            }
        }
    }
    

// MARK: - *** CHECKOUT FUNCTIONS *** -
    func sendServerEmails() {
        if isAdhoc && isSimDevice {
            let alertController = UIAlertController(
                title: "Send Email?",
                message: "For AdHoc Only, do you want to send email files or bypass?",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "SEND", style: .default) { (action) -> Void in
                sendServerEmailToCompany(attachments:self.attachments_CompanyList,sendToCustomer:true,completion: { (success,error) in
                    waitHUD().hideNow()
                    simPrint().success("Customer email and Company email \( success ?"sent." :"FAILED to send." )",function:#function,line:#line)
                    isAdhoc ?self.displayOrderAuditMessage() :self.aSKUserToViewLastOrder()
                })
            }
            
            let dismissAction = UIAlertAction(title: "BYPASS", style: .destructive) { (action) -> Void in
                simPrint().success("Customer email and Company email BYPASSED!!!",function:#function,line:#line)
                isAdhoc ?self.displayOrderAuditMessage() :self.aSKUserToViewLastOrder()
            }
            
            alertController.addAction(okAction)
            alertController.addAction(dismissAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            sendServerEmailToCompany(attachments:attachments_CompanyList,sendToCustomer:true,completion: { (success,error) in
                waitHUD().hideNow()

                simPrint().success("Customer email and Company email \( success ?"sent." :"FAILED to send." )",function:#function,line:#line)

                isAdhoc ?self.displayOrderAuditMessage() :self.aSKUserToViewLastOrder()
            })
        }
    }
    
    func finishOrder(cardID:String) {
        // PRODUCTION CHECK: ✅ MAKE SURE FALSE FOR PRODUCTION
        let testOrder = false
        
        /* Double-check phone is saved without formatting */
        var phone1 = order.customer_phone
            phone1 = sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone1)
            phone1 = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: phone1)
        order.customer_phone = phone1
        var phone2 = order.shipTo_phone
            phone2 = sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone2)
            phone2 = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: phone2)
        order.shipTo_phone = phone2
        
        /* Sascha's pay.php script */
        Orders().completeOrder(order_id: order.id, ccToken: cardID, testOrder:testOrder, completion: { (success, error, errorMSG) in
            waitHUD().hideNow()
            if success {
                /* Redeem Coupon */
                if (order.couponID > 0) {
                    self.redeemCoupon( completion: { (success, error) in
                        self.sendServerEmails()
                    })
                }else{
                    self.sendServerEmails()
                }
            }else{
                waitHUD().hideNow()
                sharedFunc.ALERT().show(title: "Order.NotCompleted".localized(),style:.error,msg: errorMSG)
            }
        })
    }
    
    func setCreditCardAmount(amountInPennies:Int) {
        /* Initialize Stripe */
        stripe = StripeController.init(
            host: self,
            customerId: "\( order.customerID )",
            amount: amountInPennies,
            delegate: self
        )
    }

    func addNewCustomer(completion: @escaping (Bool) -> Void) {
        let todaysDateExtended = Date().toString(format: kDateFormat.MMM_d_yyyy_EEEE_at_hmm_a)

        if order.customer_countryCode.isEmpty { order.customer_countryCode = "US" }
        
        let paramsWithAddress:Alamofire.Parameters =  [
            // Customer
            "firstName" : order.customer_firstName,
            "lastName" : order.customer_lastName,
            "phone" : sharedFunc.STRINGS().stripPhoneNumFormatting(text: order.customer_phone),
            "email" : order.customer_email,
            "notes" : "Customer added on \(todaysDateExtended).",
            // Address
            "address1" : order.customer_address1,
            "address2" : order.customer_address2,
            "city" : order.customer_city,
            "stateCode" : order.customer_stateCode,
            "zip" : sharedFunc.STRINGS().stripZipCodeFormatting(text: order.customer_zip),
            "countryCode" : order.customer_countryCode,
            // Calling App
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Customers().addCustomerWithAddress(params:paramsWithAddress) { (success,customerID,error) in
            if success {
                order.customerNum = "\( customerID )"
                order.customerID = customerID
                customerInfo.ID = customerID
                
                appFunc.keychain.MYINFO().save()
            }
            
            completion(success)
        }
    }
    
    func updateCustomer(completion: @escaping (Bool) -> Void) {
        let todaysDateExtended = Date().toString(format: kDateFormat.MMM_d_yyyy_EEEE_at_hmm_a)
        
        let paramsWithAddress:Alamofire.Parameters =  [
            // Customer
            "customerID" : customerInfo.ID!,
            "firstName" : order.customer_firstName,
            "lastName" : order.customer_lastName,
            "phone" : sharedFunc.STRINGS().stripPhoneNumFormatting(text: order.customer_phone),
            "email" : order.customer_email,
            "notes" : "Customer added on \(todaysDateExtended).",
            // Address
            "addressID" : customerInfo.address.id,
            "address1" : order.customer_address1,
            "address2" : order.customer_address2,
            "city" : order.customer_city,
            "stateCode" : order.customer_stateCode,
            "zip" : sharedFunc.STRINGS().stripZipCodeFormatting(text: order.customer_zip),
            "countryCode" : order.customer_countryCode,
            // Calling App
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        Customers().updateCustomerWithAddress(params:paramsWithAddress) { (success,customerID,addressID,error) in
            var somethingChanged:Bool = false
            
            if customerID != customerInfo.ID! {
                customerInfo.ID = customerID
                order.customerID = customerInfo.ID
                order.customerNum = "\( customerInfo.ID! )"
                somethingChanged = true
            }

            if addressID != customerInfo.address.id {
                customerInfo.address.id = addressID
                somethingChanged = true
            }

            if somethingChanged {
                appFunc.keychain.MYINFO().save()
            }
            
            completion(success)
        }
    }
    
    func showOrderError(error:orderError) {
        waitHUD().hideNow()

        var title:String = ""
        var msg:String = ""

        switch error {
        case .customer_NotCreated:
            title = "Cart.Create.Error_Title".localized()
            msg = "Cart.Create.Error_Msg".localized()
        case .cart_NotCreated:
            title = "Cart.Customer.Create.Error_Title".localized()
            msg = "Cart.Customer.Create.Error_Msg".localized()
        default: ()
        }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedCAS(), style: .default) { (action) -> Void in })
        self.present(alert, animated: true)
    }

    func BuildCart(updateTable:Bool? = true) {
        if (shipToAddressRequiresSalesTax(stateCode:order.shipTo_stateCode) && (taxRate < 0.01)) {
            getSalesTaxRate()
        }else{
            calculateTotals()
        }

        if (updateTable?.isTrue)! {
            table.reloadData()
        }
    }

    
// MARK: - *** DATA ENTRY FUNCTIONS *** -
    func displayAddressesToSelectFrom(section:Int) {
        var Addresses:[String] = []
        for address in shippingAddresses {
            Addresses.append(sharedFunc.STRINGS().buildAddress(
                Name: "\( address.firstName ) \( address.lastName )",
                Addr1: address.address1,
                Addr2: address.address2,
                City: address.city,
                State: address.stateCode,
                Zip: address.zip,
                Country: address.countryCode,
                MultiLine: true,
                ZipOnSepLine: true)
            )
        }

        gSender.Data = Addresses as NSArray
        gSender.Title = "Select Address"
        gSender.Category = .simpleList
        gSender.NotificationCallbackName = "checkout_UpdateTableFromShipAddress"
        gSender.Key = ""
        gSender.ValueText = ""
        gSender.isEditable = false
        gSender.SelectedItem = section

        if section == rowType.shipTo.rawValue {
            let cell = self.table.cellForRow(at: IndexPath(row:0,section:rowType.shipTo.rawValue)) as? cell_ShipTo
            if cell != nil { self.presentTablePopover(cell!.btn_Edit,size:CGSize(width:300,height:300),variableHt:true) }
        }
    }

    func displaySelectedAddress(_ contact:CNContact,selection:Int? = 0,section:Int) {
        let oldEmail = order.customer_email
        let address = (contact.postalAddresses)[selection!]

        /* Get data from selected Contact */
        let firstName = contact.givenName
        let lastName = contact.familyName
        let address1 = address.value.street
        let address2 = ""
        let city = address.value.city
        let stateCode = returnCodeForState(state:address.value.state)
        let zipCode = address.value.postalCode
        let countryCode = returnCodeForCountry(country:address.value.country)
        let email = "\(contact.emailAddresses.first?.value ?? "")"
        var phone = "\(contact.phoneNumbers.first?.value.stringValue ?? "")"
            phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone)
            phone = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: phone)

        /* Update Order */
// MARK: ├─➤ Contacts
        if section == rowType.contactInfo.rawValue {
            /* Update Order */
            order.customer_firstName = firstName
            order.customer_lastName = lastName
            order.customer_address1 = address1
            order.customer_address2 = address2
            order.customer_city = city
            order.customer_stateCode = stateCode
            order.customer_zip = zipCode
            order.customer_countryCode = countryCode
            order.customer_phone = phone
            order.customer_email = email

            /* Update CustomerInfo */
            customerInfo = CustomerInfo.init(
                ID: -1,
                firstName: order.customer_firstName,
                lastName: order.customer_lastName,
                email: order.customer_email,
                phone: order.customer_phone,
                mailingList: true,
                address: Customers.address.init(
                    id: -1,
                    customerID: -1,
                    firstName: order.customer_firstName,
                    lastName: order.customer_lastName,
                    address1: order.customer_address1,
                    address2: order.customer_address2,
                    city: order.customer_city,
                    stateCode: order.customer_stateCode,
                    zip: order.customer_zip ,
                    countryCode: order.customer_countryCode,
                    phone: order.customer_phone,
                    email: order.customer_email
                )
            )

            /* Update Keychain */
            appFunc.keychain.MYINFO().save()
    
            self.BuildCart(updateTable: true)
            
            simPrint().info("DisplaySelectedAddress: customerNumber: \( order.customerID )",function:#function,line:#line)

            /* See if the new email address has a customer number associated with it. */
            if email.isNotEmpty {
                getCustomerNumberFromEmail(email: email,updateCustomerInfo:false) { (success, customerID, addressID) in
                    waitHUD().hideNow()

                    if email != oldEmail { // blank ship to and payment info
                        /* Update SHIPTO */
                        order.shipToID = -1
                        order.shipTo_firstName = ""
                        order.shipTo_lastName = ""
                        order.shipTo_address1 = ""
                        order.shipTo_address2 = ""
                        order.shipTo_city = ""
                        order.shipTo_stateCode = ""
                        order.shipTo_zip = ""
                        order.shipTo_countryCode = ""
                        order.shipTo_phone = ""
                        order.shipTo_email = ""
                        
                        /* Update PAYMENT */
                        order.paymentCard = ""
                    }

                    /* Update Keychain */
                    appFunc.keychain.MYINFO().save()
                    
                    self.BuildCart(updateTable: true)
                    
                    let indexPath = IndexPath(row:0,section:rowType.shipTo.rawValue)
                    if let _ = self.table.cellForRow(at: indexPath) as? cell_ShipTo {
                        self.scrollTable(indexPath: indexPath)
                    }
                }
            }
        }else if section == rowType.shipTo.rawValue {
// MARK: ├─➤ ShipTo
            /* Update Order */
            order.shipToID = -1
            order.shipTo_firstName = firstName
            order.shipTo_lastName = lastName
            order.shipTo_address1 = address1
            order.shipTo_address2 = address2
            order.shipTo_city = city
            order.shipTo_stateCode = stateCode
            order.shipTo_zip = zipCode
            order.shipTo_countryCode = countryCode
            order.shipTo_phone = phone
            order.shipTo_email = email
            
            let addressStruct = Customers.address.init(
                id: -1,
                customerID: order.customerID,
                firstName: firstName,
                lastName: lastName,
                address1: address1,
                address2: address2,
                city: city,
                stateCode: stateCode,
                zip: zipCode,
                countryCode: countryCode,
                phone: phone,
                email: email,
                moltinID: ""
            )
            
            Customers.address().searchForMatch(address: addressStruct) { (success, addressID, error) in
                order.shipToID = addressID

                self.BuildCart(updateTable: true)
                
                let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
                if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                    self.scrollTable(indexPath: indexPath)
                }
            }
        }
    }
    
    func displayContacts(tag:Int) {
        if CAS_Contacts().authorizedAccess().isTrue {
            let contactPicker = CNContactPickerViewController()
                contactPicker.delegate = self
                contactPicker.modalPresentationStyle = .currentContext
                contactPicker.predicateForEnablingContact = NSPredicate(format: "postalAddresses.@count > 0")
                contactPicker.view.tag = tag

            self.present(contactPicker, animated: true)
        }
    }

    func dataEntry(section:Int) {
        let vc = setupInputTableVC()
            // Data
            vc.SQL_TableName = "edit"
            vc.SQL_EditRecordIndex = -1
            vc.bypassSave = true
            vc.saveToDefaults = false
            vc.Style = ""
            vc.AutoSave = false
            vc.NotificationCallbackName = "checkout_UpdateTable"

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

// MARK: ├─➤ Build Data
        struct DataVal {
            var firstName:String = ""
            var lastName:String = ""
            var address1:String = ""
            var address2:String = ""
            var city:String = ""
            var stateCode:String = ""
            var zipCode:String = ""
            var countryCode:String = ""
            var phone:String = ""
            var email:String = ""
        }
        
        struct DataKeys {
            var firstName:String = ""
            var lastName:String = ""
            var address1:String = ""
            var address2:String = ""
            var city:String = ""
            var stateCode:String = ""
            var zipCode:String = ""
            var countryCode:String = ""
            var phone:String = ""
            var email:String = ""
        }

        var dataVal = DataVal.init()
        var dataKeys = DataKeys.init()

        if section == rowType.contactInfo.rawValue {
            vc.titleText = "BillShipTo_MyInfo".localizedCAS()
            vc.Category = "MyInfo"
            dataVal.firstName = order.customer_firstName
            dataVal.lastName = order.customer_lastName
            dataVal.address1 = order.customer_address1
            dataVal.address2 = order.customer_address2
            dataVal.city = order.customer_city
            dataVal.stateCode = order.customer_stateCode
            dataVal.zipCode = order.customer_zip
            dataVal.countryCode = order.customer_countryCode.isNotEmpty ?order.customer_countryCode :"US"
            dataVal.phone = order.customer_phone
            dataVal.email = order.customer_email
            dataKeys.firstName = prefKeys.MyInfo.firstName
            dataKeys.lastName = prefKeys.MyInfo.lastName
            dataKeys.address1 = prefKeys.MyInfo.addr1
            dataKeys.address2 = prefKeys.MyInfo.addr2
            dataKeys.city = prefKeys.MyInfo.city
            dataKeys.stateCode = prefKeys.MyInfo.state
            dataKeys.zipCode = prefKeys.MyInfo.zip
            dataKeys.countryCode = prefKeys.MyInfo.country
            dataKeys.phone = prefKeys.MyInfo.phone
            dataKeys.email = prefKeys.MyInfo.email
        }else if section == rowType.shipTo.rawValue {
            vc.titleText = "BillShipTo_ShipInfo".localizedCAS()
            vc.Category = "ShipTo"
            dataVal.firstName = order.shipTo_firstName
            dataVal.lastName = order.shipTo_lastName
            dataVal.address1 = order.shipTo_address1
            dataVal.address2 = order.shipTo_address2
            dataVal.city = order.shipTo_city
            dataVal.stateCode = order.shipTo_stateCode
            dataVal.zipCode = order.shipTo_zip
            dataVal.countryCode = order.shipTo_countryCode.isNotEmpty ?order.shipTo_countryCode :"US"
            dataVal.phone = order.shipTo_phone
            dataVal.email = order.shipTo_email
            dataKeys.firstName = prefKeys.ShipTo.firstName
            dataKeys.lastName = prefKeys.ShipTo.lastName
            dataKeys.address1 = prefKeys.ShipTo.addr1
            dataKeys.address2 = prefKeys.ShipTo.addr2
            dataKeys.city = prefKeys.ShipTo.city
            dataKeys.stateCode = prefKeys.ShipTo.state
            dataKeys.zipCode = prefKeys.ShipTo.zip
            dataKeys.countryCode = prefKeys.ShipTo.country
            dataKeys.phone = prefKeys.ShipTo.phone
            dataKeys.email = prefKeys.ShipTo.email
        }
        
// MARK: ├─➤ Add Fields
        vc.inputFields.append(InputTableStruct(
            cellType: .text,
            placeholder: "First Name".localizedCAS(),
            value: dataVal.firstName,
            dataKey: dataKeys.firstName,
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text,
            placeholder: "Last Name".localizedCAS(),
            value: dataVal.lastName,
            dataKey: dataKeys.lastName,
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text,
            placeholder: "Address Line 1".localizedCAS(),
            value: dataVal.address1,
            dataKey: dataKeys.address1,
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text,
            placeholder: "Address Line 2".localizedCAS(),
            value: dataVal.address2,
            dataKey: dataKeys.address2
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text,
            placeholder: "City".localizedCAS(),
            value: dataVal.city,
            dataKey: dataKeys.city,
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .popover_State,
            placeholder: "State".localizedCAS(),
            value: dataVal.stateCode,
            dataKey: dataKeys.stateCode,
            image: #imageLiteral(resourceName: "CAS_Picker_Location"),
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .popover_Country,
            placeholder: "Country".localizedCAS(),
            value: dataVal.countryCode,
            dataKey: dataKeys.countryCode,
            image: #imageLiteral(resourceName: "CAS_Picker_Country"),
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text_Zipcode,
            placeholder: "Zip Code".localizedCAS(),
            value: dataVal.zipCode,
            dataKey: dataKeys.zipCode,
            required: true
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text_Phone,
            placeholder: "Phone Number with Area Code".localizedCAS(),
            value: dataVal.phone,
            dataKey: dataKeys.phone,
            required: (section == rowType.contactInfo.rawValue)
        ))
        vc.inputFields.append(InputTableStruct(
            cellType: .text_Email,
            placeholder: "Email Address".localizedCAS(),
            value: dataVal.email,
            dataKey: dataKeys.email,
            required: (section == rowType.contactInfo.rawValue)
        ))

        present(vc, animated: true)
    }

    func editGiftMessage() {
        self.view.endEditing(true)

        let vc = gBundle.instantiateViewController(withIdentifier: "VC_GiftMessage") as! VC_GiftMessage
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .coverVertical

        present(vc, animated: true)
    }
    
    
// MARK: - *** GENERAL FUNCTIONS ***
    func presentTablePopover(_ sender:UIButton, size:CGSize? = CGSize(width: 175,height: 150),variableHt:Bool? = false) {
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
            vc.usesVariableHtCell = variableHt!

        present(vc, animated: true)
    }

    @discardableResult func validateContactInfo() -> (isValid:Bool,isBlank:Bool,issues:String) {
        var issues:String = ""

        if order.customer_firstName.isEmpty { issues += "\("First Name".localizedCAS())" }
        if order.customer_lastName.isEmpty { issues += issues.isEmpty ?"\("Last Name".localizedCAS())" :", \("Last Name".localizedCAS())"}
        if order.customer_address1.isEmpty { issues += issues.isEmpty ?"\("Address".localizedCAS())" :"\(", Address".localizedCAS())"}
        if order.customer_city.isEmpty { issues += issues.isEmpty ?"\("City".localizedCAS())" :", \("City".localizedCAS())"}
        if order.customer_stateCode.isEmpty { issues += issues.isEmpty ?"\("State".localizedCAS())" :", \("State".localizedCAS())"}
        if order.customer_email.isEmpty { issues += issues.isEmpty ?"\("Email".localizedCAS())" :", \("Email".localizedCAS())"}
        if order.customer_phone.isEmpty { issues += issues.isEmpty ?"\("Phone".localizedCAS())" :", \("Phone".localizedCAS())"}
        if order.customer_zip.isEmpty { issues += issues.isEmpty ?"\("Zip Code".localizedCAS())" :", \("Zip Code".localizedCAS())"}

        /* Validate Country */
        let country = order.customer_countryCode
        if country.isNotEmpty {
            if country == "USA" || country == "U.S." || country == "United States"  || country == "United States of America" {
                order.customer_countryCode = "US"
            }

            if country != "US" {
                issues += issues.isEmpty ?"\("Country must be US".localized())" :", \("Country must be US".localized())"
            }
        }else{
            issues += issues.isEmpty ?"\("Country".localizedCAS())" :", \("Country".localizedCAS())"
        }
        
        /* Validate Zip */
        if country == "US" {
            if ((order.customer_zip.count == 5) || (order.customer_zip.count == 9)).isFalse  { issues += issues.isEmpty ?"\("Zip Code".localizedCAS())" :", \("Zip Code".localizedCAS())"}
        }else if country == "CA" {
            if (order.customer_zip.count < 6)  { issues += issues.isEmpty ?"\("Zip Code".localizedCAS())" :", \("Zip Code".localizedCAS())"}
        }
        
        let AllFieldsBlank:Bool = (
            order.customer_firstName.isEmpty &&
            order.customer_lastName.isEmpty &&
            order.customer_address1.isEmpty &&
            order.customer_city.isEmpty &&
            order.customer_stateCode.isEmpty &&
            order.customer_zip.isEmpty &&
            order.customer_countryCode.isEmpty &&
            order.customer_email.isEmpty &&
            order.customer_phone.isEmpty
        )

        return (issues.isEmpty,AllFieldsBlank,"\("INCOMPLETE INFO".localizedCAS()):\n\(issues)")
    }

    @discardableResult func validateShipTo() -> (isValid:Bool,isBlank:Bool,issues:String) {
        var issues:String = ""

        if order.shipTo_firstName.isEmpty { issues += "\("First Name".localizedCAS())" }
        if order.shipTo_lastName.isEmpty { issues += issues.isEmpty ?"\("Last Name".localizedCAS())" :", \("Last Name".localizedCAS())"}
        if order.shipTo_address1.isEmpty { issues += issues.isEmpty ?"\("Address".localizedCAS())" :"\(", Address".localizedCAS())"}
        if order.shipTo_city.isEmpty { issues += issues.isEmpty ?"\("City".localizedCAS())" :", \("City".localizedCAS())"}
        if order.shipTo_stateCode.isEmpty { issues += issues.isEmpty ?"\("State".localizedCAS())" :", \("State".localizedCAS())"}
        if order.shipTo_zip.isEmpty { issues += issues.isEmpty ?"\("Zip Code".localizedCAS())" :", \("Zip Code".localizedCAS())"}

        /* Validate Country */
        let country = order.shipTo_countryCode
        if country.isNotEmpty {
            if country == "USA" || country == "U.S." || country == "United States"  || country == "United States of America" {
                order.shipTo_countryCode = "US"
            }

            if country != "US" {
                issues += issues.isEmpty ?"\("Country must be US".localized())" :", \("Country must be US".localized())"
            }
        }else{
            issues += issues.isEmpty ?"\("Country".localizedCAS())" :", \("Country".localizedCAS())"
        }

        /* Validate Zip */
        if country == "US" {
            if ((order.shipTo_zip.count == 5) || (order.shipTo_zip.count == 9)).isFalse { issues += issues.isEmpty ?"\("Zip Code".localizedCAS())" :", \("Zip Code".localizedCAS())"}
        }else if country == "CA" {
            if (order.shipTo_zip.count < 6)  { issues += issues.isEmpty ?"\("Zip Code".localizedCAS())" :", \("Zip Code".localizedCAS())"}
        }
        
        let AllFieldsBlank:Bool = (
            order.shipTo_firstName.isEmpty &&
            order.shipTo_lastName.isEmpty &&
            order.shipTo_address1.isEmpty &&
            order.shipTo_city.isEmpty &&
            order.shipTo_stateCode.isEmpty &&
            order.shipTo_zip.isEmpty &&
            order.shipTo_countryCode.isEmpty
        )

        return (issues.isEmpty,AllFieldsBlank,"\("INCOMPLETE INFO".localizedCAS()):\n\(issues)")
    }

    func validateCountry(_ country:String) -> String {
        if country.uppercased() == "US" ||
           country.uppercased() == "USA" ||
           country.uppercased() == "U.S." ||
           country.uppercased() == "U.S.A." ||
           country.uppercased() == "UNITED STATES" {

            return "US"
        }else{
            // NOTE: ⚠️ If other countries are valid, delete this entry to force US
            return "US"
        }
    }

    func validateInfo(section:String) -> Bool {
        var valid = false

        if order.shipTo_countryCode.isNotEmpty { order.shipTo_countryCode = validateCountry(order.shipTo_countryCode) }
        if order.customer_countryCode.isNotEmpty { order.customer_countryCode = validateCountry(order.customer_countryCode) }

        if section == "MyInfo" {
            valid = isCustomerInfoFilledOut()
        } else if section == "ShipTo" {
            valid = isShipToFilledOut()
        } else if section == "GiftMsg" {
            valid = order.giftMessage.isNotEmpty
        } else if section == "Payment" {
            valid = order.paymentCard.isNotEmpty
        } else if section == "BuyButton" {
            let freeOrder = Coupons().isOrderFree.isTrue
            let creditCardSelected = (stripe?.context.selectedPaymentOption != nil)

            if freeOrder { //ByPass CC selected for validation
                valid = (
                    (order.customerID > 0) &&
                    order.customer_email.isNotEmpty &&
                    order.customer_lastName.isNotEmpty &&
                    order.customer_firstName.isNotEmpty &&
                    isShipToFilledOut().isTrue
                )
            }else{
                valid = (
                    (order.customerID > 0) &&
                    order.customer_email.isNotEmpty &&
                    order.customer_lastName.isNotEmpty &&
                    order.customer_firstName.isNotEmpty &&
                    isShipToFilledOut().isTrue &&
                    creditCardSelected.isTrue
                )
            }
        } else {
           valid = false
        }

        return valid
    }

    func enableBuyBtn() {
        let allReqFldsEntered = validateInfo(section: "BuyButton")
        btn_Buy.isEnabled = allReqFldsEntered
        
        btn_Buy.setTitleColor(allReqFldsEntered ?#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1) :#colorLiteral(red: 0.5601567626, green: 0.5578907132, blue: 0.5808923841, alpha: 1), for: .normal)
        btn_Buy.backgroundColor = allReqFldsEntered ?#colorLiteral(red: 0.9527310729, green: 0.8001964688, blue: 0.4281107187, alpha: 1) : #colorLiteral(red: 0.8075229526, green: 0.8046451211, blue: 0.8198773861, alpha: 1)
        
        sharedFunc.DRAW().roundCorner(view: btn_Buy, radius: 5.0, color: btn_Buy.isEnabled ?gAppColor :.clear, width: 0.5)
    }
    
// MARK: -
    func getSalesTaxRate() {
        taxRate = 0.00
        order.taxAmt = 0.00

        /* Calculate tax if shipping destination state = GA */
        if shipToAddressRequiresSalesTax(stateCode: order.shipTo_stateCode) {
            let msg = "SERVER.SalesTax.Searching".localized()
            CAS_SalesTax().getSalesTax(zipcode: order.shipTo_zip,rappleMsg:msg ,vc: self,completion: { (success, newTaxRate) in
                if success {
                    self.taxRate = newTaxRate
                }else{
                    /* Set fallback GA State Sales Tax min. 6% tax rate */
                    self.taxRate = 0.06
                    sharedFunc.ALERT().show(
                        title:"SERVER.SalesTax.NotFound.title".localized(),
                        style:.error,
                        msg:"SERVER.SalesTax.NotFound.title".localized()
                    )
                }

                self.calculateTotals()
            })
        }
    }

    func calculateTotals(tableRefresh:Bool? = true) {
        order.productCount = localCart.itemCount
        order.shippingAmt = CMS_defaulShipingRate
        order.subtotal = localCart.subtotal

        /* Calculate Discount */
        let discount = Coupons().calculateDiscount()

        /* Calculate Pre-Tax Total */
        var pretaxTotal:Decimal = (order.subtotal + order.shippingAmt)

        if discount.hasDiscount.isTrue && discount.entireOrderIsFree.isFalse {
            pretaxTotal -= Decimal(discount.amount)
        }

        if pretaxTotal < 0.00 { pretaxTotal = 0.00 }
        pretaxTotal = Decimal(String(format:"%0.2f", pretaxTotal.doubleValue).doubleValue)

        /* Calculate Sales Tax */
        order.taxAmt = shipToAddressRequiresSalesTax(stateCode:order.shipTo_stateCode)
            ?Decimal(String(format:"%0.2f",(taxRate * pretaxTotal.doubleValue)).doubleValue)
            :0.00

        if discount.entireOrderIsFree {
            order.taxAmt = 0.00
        }

        /* Calculate Order Total + Sales Tax */
        var postTaxTotal:Decimal = (pretaxTotal + order.taxAmt)
        if postTaxTotal < 0.00 { postTaxTotal = 0.00 }

        order.totalAmt = discount.entireOrderIsFree
            ?0.00
            :Decimal(String(format:"%0.2f", postTaxTotal.doubleValue).doubleValue)

        /* If Entire Order Free, Bypass Payment */
        if discount.entireOrderIsFree {
            order.paymentCard = ""
            selectedPayment = CREDITCARD.creditCARD.init()
        }

        if tableRefresh!.isTrue { table.reloadData() }
    }

    
// MARK: - *** CREDIT CARD FUNCTIONS ***
    @objc func chooseCreditCard() {
        /* Validation */
        if (order.customerID <= 0) {
            addNewCustomer { (success) in
                if success.isFalse {
                    sharedFunc.ALERT().show(
                        title: "Checkout.CustomerID.Missing_Title".localized(),
                        style:.error,
                        msg:"Checkout.CustomerID.Missing_Msg".localized()
                    )
                }else{
                    self.chooseCreditCard()
                }
            }
        }else{
            setCreditCardAmount(amountInPennies: Int(order.totalAmt.doubleValue * 100.0))
            stripe?.choose()
        }
    }
    

// MARK: - *** COUPON FUNCTIONS ***
    func getCouponCode(showErrorMsg:String? = "") {
        let alert = UIAlertController(
            title: "Coupon".localizedCAS(),
            message: showErrorMsg,
            preferredStyle: .alert
        )

        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Coupon".localizedCAS()
            textField.text = ""
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .allCharacters
            textField.returnKeyType = .done
            textField.enablesReturnKeyAutomatically = false
        }

        let okAction = UIAlertAction(title: "Apply".localizedCAS(), style: .default) { (action) -> Void in
            if let firstTextField = alert.textFields![0] as UITextField? {
                let firstText:String = firstTextField.text!

                let coupon_code = firstText.uppercased().removeSpaces
                self.validateCouponCode(coupon_code)
            }
        }

        let dismissAction = UIAlertAction(title: "Cancel".localizedCAS(), style: .destructive) { (action) -> Void in
            if (order.couponID > 0) {
                self.invalidateCoupon()
            }

            self.calculateTotals()
            self.table.reloadData()
            let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
            if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                self.scrollTable(indexPath: indexPath)
            }
        }

        alert.addAction(okAction)
        alert.addAction(dismissAction)

        /* Appearance */
        alert.view.tintColor = gAppColor
        sharedFunc.DRAW().roundCorner(view: alert.view, radius: 16, color: gAppColor, width: 2.25)

        self.present(alert, animated: true)
    }

    func invalidateCoupon() {
        order.couponID = 0
        order.discountAmt = 0.0
        selectedCoupon = Coupons.couponStruct.init()
    }
    
    func resetCouponCode() {
        invalidateCoupon()

        /* Recalculate orderSales Tax */
        self.calculateTotals()

        waitHUD().hideNow()

        self.getCouponCode(showErrorMsg: "Coupon.Invalid".localizedCAS())
    }

    func validateCouponCode(_ coupon_code:String,coupon_ID:Int? = 0) {
        Coupons().search(coupon_code: coupon_code, coupon_ID:coupon_ID ,completion: { (found, record) in
            if found.isTrue {
                // Confirm valid and has not been redeemed already if limit of one per customer
                Coupons().isValid(coupon: record, completion: { (valid, errorMsg) in
                    if valid.isTrue {
                        selectedCoupon = record
                        order.couponID = selectedCoupon.id.intValue
                        
                        /* Recalculate orderSales Tax */
                        self.calculateTotals()
                    }else{
                        self.getCouponCode(showErrorMsg: "\(errorMsg)")
                        self.invalidateCoupon()
                    }
                })
            }else{ // Invalid, display message in alert and reset alert input
                self.getCouponCode(showErrorMsg: "Coupon.NotFound".localizedCAS())
                self.invalidateCoupon()
            }
        })
    }

    
// MARK: - *** ACTIONS ***
    @IBAction func setCouponCode(_ sender:UISwitch) {
        if sender.isOn {
            getCouponCode()
        }else{
            /* If Entire Order Free, Bypass Payment */
            if Coupons().isOrderFree {
                order.paymentCard = ""
                selectedPayment = CREDITCARD.creditCARD.init()
            }

            invalidateCoupon()

            calculateTotals()
            let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
            if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                self.scrollTable(indexPath: indexPath)
            }
        }
    }

    @IBAction func cancel(_ sender:UIButton){
        AppDelegate().saveCurrentSessionData()
        
        self.dismiss(animated: true)
    }

    @IBAction func giftMsg(_ sender: UISwitch) {
        if sender.isOn {
            editGiftMessage()
        }else{
            order.giftMessage = ""
        }

        table.reloadData()
        let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
        if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
            self.scrollTable(indexPath: indexPath)
        }
    }

    @IBAction func selectContactAddress(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let actSheet = sharedFunc.actSheet().setup(vc:self,barButton:nil,buttonRect:nil,title:"Select Your Address".localized(),message:nil)

        actSheet.addAction(UIAlertAction(title:"Contacts".localized(), style: .default, handler:{ action in
            if CAS_Contacts().authorizedAccess().isTrue {
                self.displayContacts(tag: rowType.contactInfo.rawValue)
            }else{
                CAS_Contacts().requestForAccess(completionHandler: { Void in
                    if CAS_Contacts().authorizedAccess().isTrue {
                        self.displayContacts(tag: rowType.contactInfo.rawValue)
                    }
                })
            }
        }))
        
        let title = order.customer_lastName.isEmpty ?"New".localized() :"Edit".localizedCAS()
        actSheet.addAction(UIAlertAction(title:title, style: .default, handler:{ action in
            self.dataEntry(section:rowType.contactInfo.rawValue)
        }))
        
        present(actSheet, animated:true)
    }
    
    @IBAction func selectShippingAddress(_ sender: UIButton) {
        self.view.endEditing(true)

        let actSheet = sharedFunc.actSheet().setup(vc:self,barButton:nil,buttonRect:nil,title:"Select Ship To".localized(),message:nil)

        actSheet.addAction(UIAlertAction(title:"Contacts".localized(), style: .default, handler:{ action in
            if CAS_Contacts().authorizedAccess().isTrue {
                self.displayContacts(tag: rowType.shipTo.rawValue)
            }else{
                CAS_Contacts().requestForAccess(completionHandler: { Void in
                    if CAS_Contacts().authorizedAccess().isTrue {
                        self.displayContacts(tag: rowType.shipTo.rawValue)
                    }
                })
            }
        }))
        
        let title = order.shipTo_lastName.isEmpty ?"New".localized() :"Edit".localizedCAS()
        actSheet.addAction(UIAlertAction(title:title, style: .default, handler:{ action in
            self.dataEntry(section:rowType.shipTo.rawValue)
        }))
        
        if (shippingAddresses.count > 0) {
            actSheet.addAction(UIAlertAction(title:"Saved".localized() + " (\( shippingAddresses.count ))", style: .default, handler:{ action in
                self.displayAddressesToSelectFrom(section: rowType.shipTo.rawValue)
            }))
        }
        
        actSheet.addAction(UIAlertAction(title:"Same As Contact".localized(), style: .default, handler:{ action in
            order.shipToID = customerInfo.address.id
            order.shipTo_firstName = order.customer_firstName
            order.shipTo_lastName = order.customer_lastName
            order.shipTo_address1 = order.customer_address1
            order.shipTo_address2 = order.customer_address2
            order.shipTo_city = order.customer_city
            order.shipTo_stateCode = order.customer_stateCode
            order.shipTo_zip = order.customer_zip
            order.shipTo_countryCode = order.customer_countryCode
            order.shipTo_phone = order.customer_phone
            order.shipTo_email = order.customer_email
            
            self.BuildCart(updateTable: true)
            let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
            if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                self.scrollTable(indexPath: indexPath)
            }
        }))
        
        present(actSheet, animated:true)
    }


    @IBAction func completeOrder(_ sender:UIButton){
        /* If no network, don't complete order */
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }

        /* Stopgap for accidental charging cc more than $1 */
        if (isSimDevice && order.totalAmt > 1.00) {
            sharedFunc.ALERT().show(
                title: "SIMULATOR MODE",
                style:.error,
                msg: "DON'T PROCEED WITHOUT COUPON CODE!!!!"
            )
            return
        }

        /* New AppStore version available? Force Update */
        let testUser = isTestDeviceOrUser()
        let _ = ApplicationInfo().getAppStoreInfo { (appStoreInfo, needsUpdating, appStoreVer, currentVer, error) in
            if needsUpdating && testUser.isFalse {
                ApplicationInfo().forceSirenUpdate(
                    appStoreVersion: appStoreVer,
                    currentVersion: currentVer
                )
            }else{
                /* Are CMS Services Available? */
                Server.CMS_Services().isActive { (isActive,msg_eng,msg_esp,major,build,revision,requiresUpdate) in
                    if requiresUpdate {
                        waitHUD().hideNow()
                        sharedFunc.ALERT().show(
                            title:"Siren_Update_Title".localized(),
                            style:.error,
                            msg:"Siren_Update_Msg".localized()
                        )
                        return
                    }else if (isActive || testUser) {
                        /* Allow test users backdoor bypass to server availability = OFF to be able to test */
                        showTestUserInfo(CMS_Services_Active:isActive)

                        /* Notify user NOT TO INTERRUPT Order upload */
                        let alert = UIAlertController(
                            title: "Server.DontIntterrupt.Title".localized(),
                            message: "Server.DontIntterrupt.Msg".localized(),
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(UIAlertAction(title: "OK".localizedCAS(), style: .default) { (action) in
                            /* Validate the Coupon again, server status may have changed since entered. */
                            let hasCoupon:Bool = (order.couponID > 0)
                            if hasCoupon.isFalse {
                                self.invalidateCoupon()
                                self.calculateTotals()
                                self.processOrder()
                            }else{
                                waitHUD().showNow(msg: "Checkout.Validating Coupon".localized())
                                
                                Coupons().search(coupon_code: "",coupon_ID: order.couponID, showMsg:false, completion: { (found, record) in
                                    if found {
                                        Coupons().isValid(coupon: record, completion: { (valid, errorMsg) in
                                            valid ?self.processOrder() :self.resetCouponCode()
                                        })
                                    }else{ // Invalid, display message in alert and reset alert input
                                        self.resetCouponCode()
                                    }
                                })
                            }
                        })
                        
                        alert.addAction(UIAlertAction(title: "Cancel".localizedCAS(), style: .cancel) { (action) in })
                        
                        self.present(alert, animated: true)
                    }else{
                        sharedFunc.ALERT().show(
                            title:"Server.DontIntterrupt.Title".localized(),
                            style:.error,
                            msg:(gAppLanguageCode == "en") ?msg_eng :msg_esp
                        )
                        return
                    }
                }
            }
        }
    }

    func processOrder() {
        // PRODUCTION CHECK: ✅ MAkE SURE THIS IS FALSE FOR PRODUCTION.
        isBetaTest = false

        /* If new customer, create in CMS */
        if (order.customerID <= 0) {
            addNewCustomer { (success) in
                if success.isFalse {
                    sharedFunc.ALERT().show(
                        title: "Checkout.CustomerID.Missing_Title".localized(),
                        style:.error,
                        msg:"Checkout.CustomerID.Missing_Msg".localized()
                    )
                    return
                }else{
                    self.processOrder()
                }
            }
        }

        /* Initialize Stripe incase amount has changed (Sales tax, etc.) */
        setCreditCardAmount(amountInPennies: Int(order.totalAmt.doubleValue * 100.0))

        /* Convert local cart items and save to CMS */
        Cart().saveLocalCartItemsToCMS() { (success) in
            sharedFunc.THREAD().doNothingFor(seconds: 2)

            if success {
                Cart().convertCartToOrder() { (success,orderID) in
                    if success && (orderID > 0) {
                        self.tryUploadingFiles()
                    }else{
                        sharedFunc.ALERT().show(
                            title:"Cart.Order.Error_Title".localized(),
                            style:.error,
                            msg:"Cart.Order.Error_Msg".localized()
                        )
                    }
                }
            }else{
                sharedFunc.ALERT().show(
                    title:"Cart.Create.Error_Title".localized(),
                    style:.error,
                    msg:"Cart.Create.Error_Msg".localized()
                )
            }
        }

        return
    }

    func tryUploadingFiles() {
        createOrderPDFs(completion: { (success,attachments_CompanyList,error) in
            self.attachments_CompanyList = attachments_CompanyList
            waitHUD().hideNow()

            if success {
                if isAdhoc {
                    if isBetaTest.isFalse {
                        Coupons().isOrderFree
                            ?self.finishOrder(cardID: "")
                            :self.stripe?.pay()
                    }else{
                        sharedFunc.ALERT().show(
                            title: "TESTING INFO",
                            style:.error,
                            msg: "AdHoc Environment with Beta Test = On"
                        )
                    }
                }else{
                    Coupons().isOrderFree
                        ?self.finishOrder(cardID: "")
                        :self.stripe?.pay()
                }
            }else{
                sharedFunc.THREAD().doAfterDelay(delay: 2.0, perform: {
                    let alert = UIAlertController(title: "Server.FailedCreateOrder.Msg".localized(),message: "\(error.description).", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "RETRY", style: .default) { (action) in
                        self.tryUploadingFiles()
                    })

                    alert.addAction(UIAlertAction(title: "CANCEL", style: .default) { (action) in
                        order.orderNum = ""
                    })

                    self.present(alert, animated: true)
                })
            }
        })
    }

    func redeemCoupon( completion: @escaping (Bool,orderError) -> Void) {
        let dateString:String = Date().toString(format: kDateFormat.yyyyMMdd)

        let redemption = Coupons.redemptionStruct.init(
            id: "",
            date: dateString,
            coupon_code: selectedCoupon.code,
            coupon_id: selectedCoupon.id,
            coupon_value: "\( order.discountAmt )",
            order_num: order.orderNum,
            customer_name: "\( order.customer_firstName ) \( order.customer_lastName )",
            customer_num: order.customerNum
        )

        simPrint().info("\( redemption.allPropertiesPrintToConsole() )",function:#function,line:#line)
        
        Coupons.REDEMPTIONS().insert(redemption: redemption, completion: { (success,error) in
            completion(success,success ?.none :error)
        })
    }


    func displayOrderAuditMessage() {
        waitHUD().hideNow()

        var msg = "(R&D) Check CMS Order to make sure changes were made for:"
            msg += "\n\nOrder# \(order.orderNum)"
            msg += "\n\nCustomerID = \(order.customerID)"
            msg += "\n\nCoupon = \( selectedCoupon.description.isEmpty ?"n/a" :selectedCoupon.description)"
            msg += String(format: "\n\nSales Tax = $%0.2f",order.taxAmt.doubleValue)
            msg += String(format: "\nDiscount = $%0.2f",order.discountAmt.doubleValue)
            msg += String(format: "\nTotal = $%0.2f",order.totalAmt.doubleValue)
            msg += "\n\nItems: \(Int(order.productCount))"

        let alert = UIAlertController(title: "ORDER UPDATE",message: msg, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
            order.orderNum = ""
            self.cleanupOrderFiles()
            self.aSKUserToViewLastOrder()
        })

        self.present(alert, animated: true)
    }

    func cleanupOrderFiles() {
        appFunc().resetOrderAndcleanupOrderFiles()

        /* Hide Right Menu */
        self.presentingViewController?.slideMenuController()?.closeRightNonAnimation()
    }

    func aSKUserToViewLastOrder() {
        waitHUD().hideNow() 

        order.orderNum = ""
        cleanupOrderFiles()

        /* Ask user if they want to view Order Confirmation */
        let alert = UIAlertController(
            title: "Server.viewLastOrder.Title".localized(),
            message: "Order_Receipt_Display".localizedCAS(),
            preferredStyle: .alert
        )

        let no = UIAlertAction(title: "No".localizedCAS(), style: .default) { (action) -> Void in
            sharedFunc.THREAD().doAfterDelay(delay: 0.2, perform: {
                // force carousel reload
                NotificationCenter.default.post(
                    name: Notification.Name("notification_ShowOrderPlaced"),
                    object: nil,
                    userInfo: nil
                )
            })
            self.dismiss(animated: false)
        }

        let yes = UIAlertAction(title: "Yes".localizedCAS(), style: .default) { (action) -> Void in
            let params:[String:Any] = [
                "title":"Order_Details".localizedCAS().uppercased(),
                "msg:":"\"\(currentOrder.filename)\"\n\("FILE_NotFound".localizedCAS().trimSpaces)",
                "url": buildOrderFileURLS().lastOrderPath
            ]

            sharedFunc.THREAD().doAfterDelay(delay: 0.2, perform: {
                NotificationCenter.default.post(
                    name: Notification.Name("notification_ShowOrderPlaced"),
                    object: nil,
                    userInfo: ["OrderInfo":params]
                )
            })

            self.dismiss(animated: false)
        }

        no.setValue(APPTHEME.alert_ButtonEnabled, forKey: "titleTextColor")
        yes.setValue(APPTHEME.alert_ButtonEnabled, forKey: "titleTextColor")

        alert.addAction(no)
        alert.addAction(yes)

        self.present(alert, animated: true)
    }
    
    
// MARK: - *** TABLEVIEW ***
    func numberOfSections(in tableView: UITableView) -> Int {
        var numSections:Int = 2

        if validateInfo(section: "MyInfo").isTrue {
            numSections += 1
            if validateInfo(section: "ShipTo").isTrue {
                numSections += 3 // +2 for Gift Msg & Promo Code sections.
            }
        }

        return numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let cellRow = rowType(rawValue: section) { switch cellRow {
            case .payment: return 20
            default: ()
        }}

        return 5
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 7 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellRow = rowType(rawValue: indexPath.section) {
            switch cellRow {
            case .summary: return UITableView.automaticDimension
                case .giftMsg: return order.giftMessage.isEmpty ?75 :140
                case .coupon:
                    if (order.couponID <= 0) {
                        self.invalidateCoupon()
                    }

                    return (order.couponID <= 0) ?75 :100
                case .payment: return 92
                default: return UITableView.automaticDimension
            }
        }
        
        return 132
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        enableBuyBtn()

        if let cellRow = rowType(rawValue: section) {
            switch cellRow {
// MARK: ├─➤ Summary Info
                case .summary:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.summary,for:indexPath) as? cell_Summary
                    else { return UITableViewCell() }
                    
                    cell.tag = rowType.summary.rawValue

                    calculateTotals(tableRefresh:false)

                    /* Apearance */
                    sharedFunc.DRAW().roundCorner(view: cell, radius: 5.0, color: gAppColor, width: 1.25)

                    // Header
                    cell.vw_Header.backgroundColor = gAppColor
                    cell.lbl_Header.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.lbl_Header.text = "BillShipTo_Summary".localizedCAS()

                    /* Condition Display */
                    let hasDiscount = (order.discountAmt > 0.00)
                    let hasTax = shipToAddressRequiresSalesTax(stateCode:order.shipTo_stateCode)

                    /* Display Info */
                    var itemTitles = "\(order.productCount) \("Checkout_Items".localized())"
                        itemTitles.append("\n\("Checkout_Shipping".localized())")
                    var itemAmounts = String(format:"$%0.2f",order.subtotal.doubleValue)
                        itemAmounts.append( String(format:"\n$%0.2f",order.shippingAmt.doubleValue))

                    if hasDiscount.isTrue {
                        itemTitles.append( "\n\("Coupon".localizedCAS()) \("Checkout_Discount".localized())" )
                        itemAmounts.append( String(format:"\n-$%0.2f",order.discountAmt.doubleValue))
                    }
                    if hasTax.isTrue {
                        itemTitles.append("\n\("Checkout_SalesTax".localized())")
                        itemAmounts.append( String(format:"\n$%0.2f",order.taxAmt.doubleValue))
                    }

                    cell.lbl_ItemTitles.text = itemTitles
                    cell.lbl_Items.text = itemAmounts
                    cell.lbl_Total_Title.text = "Checkout_Total".localized()
                    cell.lbl_Total.text = String(format:"$%0.2f",order.totalAmt.doubleValue)

                    return cell
// MARK: ├─➤ Contact Info
                case .contactInfo:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.shipTo,for:indexPath) as? cell_ShipTo
                    else { return UITableViewCell() }
                    
                    cell.tag = rowType.contactInfo.rawValue

                    /* Apearance */
                    sharedFunc.DRAW().roundCorner(view: cell, radius: 5.0, color: gAppColor, width: 1.25)

                    // Header
                    cell.vw_Header.backgroundColor = gAppColor
                    cell.lbl_Header.text = "Contact Info".localized()

                    cell.btn_Edit.tag = rowType.contactInfo.rawValue
                    cell.btn_Edit.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.15)
                    cell.btn_Edit.setTitle("Edit".localizedCAS(), for: .normal)
                    cell.btn_Edit.setImage(UIImage.init(), for: .normal)
//                    cell.btn_Edit.setImage(#imageLiteral(resourceName: "list").recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), for: .normal)
                    cell.btn_Edit.addTarget(self, action: #selector(selectContactAddress(_:)), for: .touchUpInside)
                    sharedFunc.DRAW().roundCorner(view: cell.btn_Edit, radius: 3.0, color:#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), width: 1.0)

                    /*  Is Customer? */
                    let isCustomer = (order.customerID > 0)
                    if sharedFunc.APP().isAdhocMode() {
                        cell.lbl_ID.text = isCustomer ?"\( order.customerID )\n\( customerInfo.address.id )" :""
                        cell.img_ID.image = #imageLiteral(resourceName: "addressBook").recolor(.white)
                        cell.lbl_ID.isHidden = isCustomer ?false :true
                        cell.img_ID.isHidden = isCustomer ?false :true
                        cell.img_ID.isHidden = isCustomer ?false :true
                    }else{
                        cell.lbl_ID.isHidden = true
                        cell.img_ID.isHidden = true
                        cell.img_ID.isHidden = true
                    }
                    
                    /*  Validation */
                    let sectionInfo = validateContactInfo()
                    cell.lbl_Incomplete.isHidden = sectionInfo.isValid.isTrue
                    cell.lbl_Incomplete.text = sectionInfo.isBlank ?"Select \(cell.lbl_Header.text ?? "Select info")" :sectionInfo.issues

                    // Display
                    cell.lbl_Name.text = "\(order.customer_firstName) \(order.customer_lastName)"
                    var address:String = sharedFunc.STRINGS().buildAddress(
                        Name: "",
                        Addr1: order.customer_address1,
                        Addr2: order.customer_address2,
                        City: order.customer_city,
                        State: order.customer_stateCode,
                        Zip: order.customer_zip,
                        Country: order.customer_countryCode,
                        MultiLine: true,
                        ZipOnSepLine: false
                    )

                    let phone = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: order.customer_phone)
                    if phone.isNotEmpty { address += "\n\( phone )" }

                    if order.customer_email.isNotEmpty { address += "\n\( order.customer_email )" }

                    simPrint().info("Table Cell: CustomerID: \( order.customerID )",function:#function,line:#line)
                    
                    cell.lbl_Address.text = address

                    return cell
// MARK: ├─➤ ShipTo Info
                case .shipTo:
                    guard let cell1 = tableView.dequeueReusableCell(withIdentifier: cellID.shipTo,for:indexPath) as? cell_ShipTo
                    else { return UITableViewCell() }
                    
                    cell1.tag = rowType.shipTo.rawValue

                    /* Apearance */
                    sharedFunc.DRAW().roundCorner(view: cell1, radius: 5.0, color: gAppColor, width: 1.25)

                    // Header
                    cell1.vw_Header.backgroundColor = gAppColor
                    cell1.lbl_Header.text = "Ship to".localized()

                    cell1.btn_Edit.tag = rowType.shipTo.rawValue
                    cell1.btn_Edit.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.15)
                    cell1.btn_Edit.setTitle("Edit".localizedCAS(), for: .normal)
                    cell1.btn_Edit.setImage(UIImage.init(), for: .normal)
//                    cell1.btn_Edit.setImage(#imageLiteral(resourceName: "list").recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), for: .normal)
                    cell1.btn_Edit.addTarget(self, action: #selector(selectShippingAddress(_:)), for: .touchUpInside)
                    sharedFunc.DRAW().roundCorner(view: cell1.btn_Edit, radius: 3.0, color:#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), width: 1.0)

                    /*  Validation */
                    let sectionInfo = validateShipTo()
                    cell1.lbl_Incomplete.isHidden = sectionInfo.isValid.isTrue
                    cell1.lbl_Incomplete.text = sectionInfo.isBlank ?"Select \(cell1.lbl_Header.text ?? "Select info")" :sectionInfo.issues

                    /*  Is existing Address? */
                    let addressExists = ((order.shipToID > 0) && cell1.lbl_Incomplete.isHidden)
                    if sharedFunc.APP().isAdhocMode() {
                        cell1.lbl_ID.text = addressExists ?"\( order.shipToID )" :""
                        cell1.img_ID.image = #imageLiteral(resourceName: "addressBook").recolor(.white)
                        cell1.lbl_ID.isHidden = addressExists ?false :true
                        cell1.img_ID.isHidden = addressExists ?false :true
                        cell1.img_ID.isHidden = addressExists ?false :true
                    }else{
                        cell1.lbl_ID.isHidden = true
                        cell1.img_ID.isHidden = true
                        cell1.img_ID.isHidden = true
                    }
                    
                    // Display
                    cell1.lbl_Name.text = "\(order.shipTo_firstName) \(order.shipTo_lastName)"
                    var address:String = sharedFunc.STRINGS().buildAddress(
                        Name: "",
                        Addr1: order.shipTo_address1,
                        Addr2: order.shipTo_address2,
                        City: order.shipTo_city,
                        State: order.shipTo_stateCode,
                        Zip: order.shipTo_zip,
                        Country: order.shipTo_countryCode,
                        MultiLine: true,
                        ZipOnSepLine: false
                    )

                    let phone = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: order.shipTo_phone)
                    if phone.isNotEmpty { address += "\n\(phone)" }

                    if order.shipTo_email.isNotEmpty { address += "\n\(order.shipTo_email)" }

                    cell1.lbl_Address.text = address

                    return cell1
// MARK: ├─➤ GiftMsg Info
                case .giftMsg:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.giftMsg,for:indexPath) as? cell_GiftMsg
                    else {
                        return UITableViewCell()
                    }

                    cell.tag = rowType.giftMsg.rawValue
                    
                    /* Apearance */
                    sharedFunc.DRAW().roundCorner(view: cell, radius: 5.0, color: gAppColor, width: 1.25)

                    // Header
                    cell.vw_Header.backgroundColor = gAppColor
                    cell.lbl_Header.text = "Gift Message".localized()

                    // Validations
                    let validate = validateInfo(section: "GiftMsg")
                    cell.vw_Message.isHidden = validate.isFalse
                    cell.btn_Edit.tag = rowType.giftMsg.rawValue
                    cell.btn_Edit.isHidden = true
                    cell.btn_Edit.isEnabled = false

                    // Gift Message
                    let giftText = order.giftMessage
                    cell.swGiftMsg.isOn = order.giftMessage.isNotEmpty
                    cell.vw_Message.alpha = cell.swGiftMsg.isOn ?kAlpha.solid :kAlpha.third
                    cell.txt_GiftText.isUserInteractionEnabled = cell.swGiftMsg.isOn

                    sharedFunc.DRAW().roundCorner(view: cell.vw_Message, radius: 2, color: gAppColor, width: 1)
                    sharedFunc.DRAW().addShadow(view: cell.vw_Message, offsetSize: CGSize(width:2,height:2), radius: 2, opacity: 0.5)
                    cell.lbl_GiftMsg.text = "Gift_Msg".localizedCAS()
                    let attribs:[NSAttributedString.Key:Any] = [
                        .font: UIFont(name: "HelveticaNeue-CondensedBold", size: 8.0)!
                    ]
                    cell.txt_GiftText.attributedText = NSAttributedString(string: giftText, attributes: attribs)
                    cell.txt_GiftText.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)

                    /* Add Tap Gesture */
                    let tap = sharedFunc.GESTURES().returnTap(selector: "gesture_TapGiftMsg:", delegate: self, numTaps: 1,cancelTouches: true)
                    cell.txt_GiftText.removeGestureRecognizer(tap)
                    cell.txt_GiftText.addGestureRecognizer(tap)

                    return cell
// MARK: ├─➤ Coupons
                case .coupon:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.coupon,for:indexPath) as? cell_Coupon
                    else { return UITableViewCell() }

                    cell.tag = rowType.coupon.rawValue
                    
                    if (order.couponID <= 0) {
                        invalidateCoupon()
                    }

                    /* Apearance */
                    sharedFunc.DRAW().roundCorner(view: cell, radius: 5.0, color: gAppColor, width: 1.25)

                    // Header
                    cell.vw_Header.backgroundColor = gAppColor
                    cell.lbl_Header.text = "Coupon".localizedCAS()
                    cell.btn_Edit.tag = rowType.coupon.rawValue
                    cell.btn_Edit.isHidden = true
                    cell.btn_Edit.isEnabled = false
                    cell.lbl_BetaTest.isHidden = true

                    // Coupon
                    cell.swCoupon.isOn = (order.couponID > 0)
                    cell.lbl_Code.text = (order.couponID > 0)
                        ?"(\( order.couponID )) \( selectedCoupon.code )"
                        :"Promo_Code_Optional".localizedCAS()
                    let scope = (order.couponID > 0)
                        ?"\( selectedCoupon.description )"
                        :""
                    cell.lbl_Description.text = "\( scope )".trimSpaces

                    cell.lbl_Code.font = UIFont.systemFont(ofSize: (order.couponID <= 0) ?12 :20)

                    return cell
// MARK: ├─➤ Payment Info
                case .payment:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.payment,for:indexPath) as? cell_Payment
                    else { return UITableViewCell() }

                    /* Apearance */
                    sharedFunc.DRAW().roundCorner(view: cell, radius: 5.0, color: gAppColor, width: 1.25)
                    sharedFunc.DRAW().roundCorner(view: cell.img_CC, radius: 2.0, color: gAppColor, width: 0.5)
                    sharedFunc.DRAW().addShadow(view: cell.img_CC, radius: 2, opacity: 0.5)

                    // Header
                    cell.vw_Header.backgroundColor = gAppColor
                    cell.lbl_Header.text = "BillShipTo_Payment".localizedCAS()

                    // Edit Button
                    cell.btn_Edit.tag = section
                    cell.btn_Edit.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.15)
                    cell.btn_Edit.setTitle("Edit".localizedCAS(), for: .normal)
                    cell.btn_Edit.setImage(UIImage.init(), for: .normal)
//                    cell.btn_Edit.setImage(#imageLiteral(resourceName: "list").recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), for: .normal)
                    cell.btn_Edit.addTarget(self, action: #selector(chooseCreditCard), for: .touchUpInside)
                    sharedFunc.DRAW().roundCorner(view: cell.btn_Edit, radius: 3.0, color:#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), width: 1.0)

                    // Order Free -or- Payment Not Selected?
                    let isSelected = (stripe?.context.selectedPaymentOption != nil)
// KM: If can't get last 4 digits of card.
//                    let isSelected = order.paymentCard.isNotEmpty
                    if Coupons().isOrderFree.isTrue || isSelected.isFalse{
                        cell.lbl_Incomplete.isHidden = false
                        cell.img_CC.isHidden = true
                        cell.lbl_CCNum.isHidden = true
                        cell.lbl_CCName.isHidden = true
                        cell.lbl_ApplePay.isHidden = true
                        cell.lbl_BetaTest.isHidden = true
                        cell.lbl_Exp.isHidden = true
                        cell.btn_Edit.isHidden = false
                        cell.btn_Edit.isEnabled = true

                        if Coupons().isOrderFree.isTrue {
                            cell.btn_Edit.isHidden = true
                            cell.btn_Edit.isEnabled = false
                        }
                        
                        cell.lbl_Incomplete.text = Coupons().isOrderFree.isTrue
                            ?"Checkout.ComplimentaryOrder".localized()
                            :"Checkout.NoPaymentSelected".localized()
                        
                        return cell
                    }

                    /* Credit Card */
                    cell.lbl_Incomplete.isHidden = true
                    cell.btn_Edit.isHidden = false
                    cell.btn_Edit.isEnabled = true
                    cell.lbl_BetaTest.isHidden = true
                    cell.lbl_CCNum.isHidden = false
                    cell.img_CC.isHidden = false
                    
                    cell.lbl_CCNum.text = isSelected ?"Payment Selected" :""
                    cell.lbl_CCName.text = ""
                    cell.lbl_Exp.text = ""
                    cell.img_CC.image = isSelected ?#imageLiteral(resourceName: "paymentSelected") :UIImage.init()

                    return cell
            }
        }

        return UITableViewCell()
    }
    
   
// MARK: - *** CREDIT CARD delegate Functions ***
    func completed(with paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        // MARK: - 📌 Stripe API update KM 12/4/19
//        let cardID = paymentResult.source.stripeID // Old Version
        let cardID = paymentResult.paymentMethod?.stripeId ?? "" // New version
        
        finishOrder(cardID:cardID)
        completion(nil)
    }
    
    func failed(with error: Error) {
        NSLog("\(error)")
    }
    
    func selected() { // This is called when the user selects a payment type
        if let paymentFields = stripe?.context.selectedPaymentOption?.description.components(separatedBy: ";") {
            print(paymentFields)
        }
    }

    
// MARK: - *** CONTACTS Functions ***
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let tag = picker.view.tag

        if contact.postalAddresses.count < 1 {
            return
        }

        selectedContact = contact
        byPassTableReload = true

        if selectedContact.postalAddresses.count == 1 {
            displaySelectedAddress(selectedContact, section: tag)
            picker.dismiss(animated: false)
            return
        }else if selectedContact.postalAddresses.count > 1 {
            var addresses:[String] = []

            for address in selectedContact.postalAddresses {
                let country = returnCodeForCountry(country:address.value.country)
                let state = returnCodeForState(state:address.value.state)

                addresses.append(sharedFunc.STRINGS().buildAddress(
                    Name: "",
                    Addr1: address.value.street,
                    Addr2: "",
                    City: address.value.city,
                    State: state,
                    Zip: address.value.postalCode,
                    Country: country,
                    MultiLine: true,
                    ZipOnSepLine: true)
                )
            }

            gSender.Data = addresses as NSArray
            gSender.Title = "Select Address"
            gSender.Category = .simpleList
            gSender.NotificationCallbackName = "checkout_UpdateFromContacts"
            gSender.ValueText = ""
            gSender.isEditable = false

            if tag == rowType.contactInfo.rawValue {
                gSender.Key = "MyInfo"
            }else if tag == rowType.shipTo.rawValue {
                gSender.Key = "ShipTo"
            }
            
            if let cell = self.table.cellForRow(at: IndexPath(row:0,section:tag)) as? cell_ShipTo {
                sharedFunc.THREAD().doAfterDelay(delay: 0.15, perform: {
                    self.presentTablePopover(cell.btn_Edit,size:CGSize(width:300,height:200),variableHt:true)
                })
            }

            picker.dismiss(animated: false)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        byPassTableReload = true
        simPrint().info("Cancel Contact Picker",function:#function,line:#line)
    }
    
    
// MARK: - *** GESTURES ***
    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func gesture_TapGiftMsg(_ sender:UITapGestureRecognizer){
        editGiftMessage()
    }


// MARK: - *** NOTIFICATIONS ***
    @objc func shippingAddressesLoaded(_ sender: Notification) {
        sharedFunc.THREAD().doAfterDelay(delay: 0.15, perform: {
            waitHUD().hideNow()
        })
    }
    
    @objc func checkout_UpdateFromContacts(_ sender: Notification) {
        guard let selection = sender.object as? Int else { return }

        var row_current = 0
        var row_next = 0

// MARK: ├─➤ ContactInfo
        if gSender.Key == "MyInfo" {
            row_current = rowType.contactInfo.rawValue
            row_next = rowType.shipTo.rawValue
            displaySelectedAddress(selectedContact,selection:selection, section: row_current)
            let indexPath = IndexPath(row:0,section:row_next)
            if let _ = self.table.cellForRow(at: indexPath) as? cell_ShipTo {
                self.scrollTable(indexPath: indexPath,scrollPosition: .middle)
            }
// MARK: ├─➤ ShipTo
        }else if gSender.Key == "ShipTo" {
            row_current = rowType.shipTo.rawValue
            row_next = rowType.coupon.rawValue
            displaySelectedAddress(selectedContact,selection:selection, section: row_current)
            calculateTotals()
            let indexPath = IndexPath(row:0,section:row_next)
            if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                self.scrollTable(indexPath: indexPath,scrollPosition: .middle)
            }
        }
    }

    @objc func checkout_UpdateTableFromShipAddress(_ sender: Notification) {
        guard let selection = sender.object as? Int,
              let section = sender.userInfo?["selectedItem"] as? Int
        else { return }

        /* Set Values */
        if let goto = rowType(rawValue: section) { switch goto {
            case .shipTo:
                let address = shippingAddresses[selection]
                
                order.shipToID = address.id
                order.shipTo_firstName = address.firstName
                order.shipTo_lastName = address.lastName
                order.shipTo_address1 = address.address1
                order.shipTo_address2 = address.address2
                order.shipTo_city = address.city
                order.shipTo_stateCode = address.stateCode
                order.shipTo_zip = address.zip
                order.shipTo_countryCode = address.countryCode
                order.shipTo_email = address.email
                order.shipTo_phone = address.phone
            default: ()
        }}

        self.BuildCart(updateTable: true)
        
        let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
        if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
            self.scrollTable(indexPath: indexPath)
        }
    }

    @objc func checkout_UpdateTable(_ sender: Notification) {
        guard let section = sender.object as? String,
              let data = sender.userInfo as? [String:Any]
        else { return }

        // This is to monitor if anything has changed and whether to update Contact Info or not.
        let orderBeforeEdit = order
        
// MARK: ├─➤ ShipTo
        if section == "ShipTo" {
            /* Build Data */
            let firstName = (data[prefKeys.ShipTo.firstName] as? String ?? "").trimSpaces
            let lastName = (data[prefKeys.ShipTo.lastName] as? String ?? "").trimSpaces
            let address1 = (data[prefKeys.ShipTo.addr1] as? String ?? "").trimSpaces
            let address2 = (data[prefKeys.ShipTo.addr2] as? String ?? "").trimSpaces
            let city = (data[prefKeys.ShipTo.city] as? String ?? "").trimSpaces
            let stateCode = (data[prefKeys.ShipTo.state] as? String ?? "").trimSpaces
            let zipCode = (data[prefKeys.ShipTo.zip] as? String ?? "").trimSpaces
            let countryCode = (data[prefKeys.ShipTo.country] as? String ?? "").trimSpaces
            let phone = (data[prefKeys.ShipTo.phone] as? String ?? "").trimSpaces
            let email = (data[prefKeys.ShipTo.email] as? String ?? "").trimSpaces

            /* Update Order */
            order.shipTo_firstName = firstName
            order.shipTo_lastName = lastName
            order.shipTo_address1 = address1
            order.shipTo_address2 = address2
            order.shipTo_city = city
            order.shipTo_stateCode = stateCode
            order.shipTo_zip = zipCode
            order.shipTo_countryCode = countryCode
            order.shipTo_phone = phone
            order.shipTo_email = email

            let newAddress = Customers.address.init(
                id: order.shipToID,
                customerID: order.customerID,
                firstName: firstName,
                lastName: lastName,
                address1: address1,
                address2: address2,
                city: city,
                stateCode: stateCode,
                zip: sharedFunc.STRINGS().stripZipCodeFormatting(text: zipCode),
                countryCode: countryCode,
                phone: sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone),
                email: email,
                moltinID: ""
            )
            
            Customers.address().searchForMatch(showMsg: true, address: newAddress) { (success, addressID, error) in
                if success { order.shipToID = addressID }
                
                /* Update Address */
                Customers().updateRecord(vc: self, showMsg: false, params: newAddress.params!, action: dbActions.PHP.address.update) { (success, error) in
                    self.BuildCart(updateTable: true)
                    let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
                    if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                        self.scrollTable(indexPath: indexPath)
                    }
                }
            }
// MARK: ├─➤ Customer Info
        }else if section == "MyInfo" {
            /* Build Data */
            let firstName = (data[prefKeys.MyInfo.firstName] as? String ?? "").trimSpaces
            let lastName = (data[prefKeys.MyInfo.lastName] as? String ?? "").trimSpaces
            let address1 = (data[prefKeys.MyInfo.addr1] as? String ?? "").trimSpaces
            let address2 = (data[prefKeys.MyInfo.addr2] as? String ?? "").trimSpaces
            let city = (data[prefKeys.MyInfo.city] as? String ?? "").trimSpaces
            let stateCode = (data[prefKeys.MyInfo.state] as? String ?? "").trimSpaces
            let zipCode = (data[prefKeys.MyInfo.zip] as? String ?? "").trimSpaces
            let countryCode = (data[prefKeys.MyInfo.country] as? String ?? "").trimSpaces
            let phone = (data[prefKeys.MyInfo.phone] as? String ?? "").trimSpaces
            let email = (data[prefKeys.MyInfo.email] as? String ?? "").trimSpaces

            /* Update Order */
            order.customerID = orderBeforeEdit.customerID
            order.customerNum = orderBeforeEdit.customerNum
            order.customer_firstName = firstName
            order.customer_lastName = lastName
            order.customer_address1 = address1
            order.customer_address2 = address2
            order.customer_city = city
            order.customer_stateCode = stateCode
            order.customer_zip = zipCode
            order.customer_countryCode = countryCode
            order.customer_phone = phone
            order.customer_email = email
            
            /* Blank shipTo and payment info */
            if email != orderBeforeEdit.customer_email {
                /* Update SHIPTO */
                order.shipTo_firstName = ""
                order.shipTo_lastName = ""
                order.shipTo_address1 = ""
                order.shipTo_address2 = ""
                order.shipTo_city = ""
                order.shipTo_stateCode = ""
                order.shipTo_zip = ""
                order.shipTo_countryCode = ""
                order.shipTo_phone = ""
                order.shipTo_email = ""
                
                /* Update PAYMENT */
                order.paymentCard = ""
            }

            /* Update Keychain */
            let customerID = (customerInfo.ID! > 0) ?customerInfo.ID! :-1
            let addressID = (customerInfo.address.id > 0) ?customerInfo.address.id :-1
            customerInfo = CustomerInfo.init(
                ID: customerID,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                mailingList: true,
                address: Customers.address.init(
                    id: addressID,
                    customerID: customerID,
                    firstName: firstName,
                    lastName: lastName,
                    address1: address1,
                    address2: address2,
                    city: city,
                    stateCode: stateCode,
                    zip: zipCode,
                    countryCode: countryCode,
                    phone: phone
                )
            )

            appFunc.keychain.MYINFO().save()
            
            /* See if the new email address has a customer number associated with it. */
            getCustomerNumberFromEmail(email: email,updateCustomerInfo:false) { (success, customerNumber,addressNumber) in
                appFunc.keychain.MYINFO().save()
                self.BuildCart(updateTable: true)
                waitHUD().hideNow()
                
                /* Order ContactInfo changed, then this is an update to CMS record IF existing customer */
                if (orderBeforeEdit.customerID > 0) {
                    if Orders.orderStruct().customerInfoHasChanged(order1: order, order2: orderBeforeEdit).isTrue {
                        var params:Alamofire.Parameters = Customers.address.init(
                            id: addressNumber,
                            customerID: customerNumber,
                            firstName: firstName,
                            lastName: lastName,
                            address1: address1,
                            address2: address2,
                            city: city,
                            stateCode: stateCode,
                            zip: sharedFunc.STRINGS().stripPhoneNumFormatting(text: zipCode),
                            countryCode: countryCode,
                            phone: sharedFunc.STRINGS().stripPhoneNumFormatting(text: phone),
                            email: email,
                            moltinID: ""
                        ).params!
                        
                        params.updateValue(customerNumber, forKey: "customerID")
                        params.updateValue(firstName, forKey: "firstName")
                        params.updateValue(lastName, forKey: "lastName")
                        params.updateValue(email, forKey: "email")
                        params.updateValue(phone, forKey: "phone")

                        Server().dumpParams(params)
                        
                        Customers().updateCustomerWithAddress(showMsg:false,params:params,completion:{ (success,customerID,addressID,error) in
                            let indexPath = IndexPath(row:0,section:rowType.shipTo.rawValue)
                            if let _ = self.table.cellForRow(at: indexPath) as? cell_ShipTo {
                                self.scrollTable(indexPath: indexPath,scrollPosition: .middle)
                            }
                        })
                    }else{
                        let indexPath = IndexPath(row:0,section:rowType.shipTo.rawValue)
                        if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                            self.scrollTable(indexPath: indexPath,scrollPosition: .middle)
                        }
                    }
                }else{
                    let indexPath = IndexPath(row:0,section:rowType.shipTo.rawValue)
                    if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
                        self.scrollTable(indexPath: indexPath,scrollPosition: .middle)
                    }
                }
            }
        }
    }
    
    @objc func notification_updateGiftMsg(_ sender: Notification) {
        guard let giftMessage = sender.object as? String else { return }

        order.giftMessage = giftMessage

        table.reloadData()
        let indexPath = IndexPath(row:0,section:rowType.coupon.rawValue)
        if let _ = self.table.cellForRow(at: indexPath) as? cell_Coupon {
            self.scrollTable(indexPath: indexPath)
        }
    }

    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        sharedFunc.DRAW().roundCorner(view: btn_Buy, radius: 5)
        lbl_Title.textColor = gAppColor
        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)
        vw_Topbar.isOpaque = false
        vw_Topbar.backgroundColor = .clear
        
        /* Table Dynamic Row Height */
        table.allowsSelection = false
        table.allowsMultipleSelection = false
        table.allowsSelectionDuringEditing = false
        table.allowsMultipleSelectionDuringEditing = false
        table.estimatedRowHeight = 90
        table.rowHeight = UITableView.automaticDimension
        
        /* Localization */
        let title = "CART_Checkout_Title".localizedCAS()
        lbl_Title.text = isAdhoc ?"R&D \( title  )" :title
        btn_Cancel.setImage(btn_Cancel.image(for: .normal)?.recolor(gAppColor), for: .normal)
        lbl_Terms.text = "Checkout_Terms".localizedCAS()
        
        btn_Buy.setTitle("Complete Your Order".localizedCAS(), for: .normal)

        /* Defaults */
        byPassTableReload = false

        /* Notifications */
        let NC = NotificationCenter.default
            NC.addObserver(self,selector:#selector(notification_updateGiftMsg(_:)), name:NSNotification.Name("notification_updateGiftMsg"),object: nil)
            NC.addObserver(self,selector:#selector(checkout_UpdateTable(_:)), name:NSNotification.Name("checkout_UpdateTable"),object: nil)
            NC.addObserver(self,selector:#selector(checkout_UpdateFromContacts(_:)), name:NSNotification.Name("checkout_UpdateFromContacts"),object: nil)
            NC.addObserver(self,selector:#selector(checkout_UpdateTableFromShipAddress(_:)), name:NSNotification.Name("checkout_UpdateTableFromShipAddress"),object: nil)
            NC.addObserver(self,selector:#selector(shippingAddressesLoaded(_:)), name:NSNotification.Name("shippingAddressesLoaded"),object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        /* Build Cart */
        BuildCart(updateTable: !byPassTableReload)
        
        /* Display Data */

        /* Load Shipping Addresses if existing Customer */
        if byPassTableReload.isFalse {
            byPassTableReload = true
        }

        /* Notifications */
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /* update UI */
        if (order.couponID > 0) {
            validateCouponCode("",coupon_ID: order.couponID)
        }

        calculateTotals(tableRefresh: !byPassTableReload)
        
        if byPassTableReload { byPassTableReload = false }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* Appearance */
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
    }

    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet weak var vw_Topbar:UIView!
    @IBOutlet weak var btn_Cancel:UIButton!
    @IBOutlet weak var btn_Buy:UIButton!
    @IBOutlet weak var divider:UILabel!
    @IBOutlet weak var lbl_Title:UILabel!
    @IBOutlet weak var lbl_Terms:UILabel!
    @IBOutlet weak var table:UITableView!

// MARK: - *** DECLARATIONS (Variables) ***
    enum rowType:Int { case summary,contactInfo,shipTo,giftMsg,coupon,payment }
    
    var selectedContact:CNContact!
    var taxRate:Double = 0.00
    var stripe:StripeController?
    var byPassTableReload:Bool! = false
    var attachments_CompanyList:[String] = []

    // MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let shipTo_Section = "cell_ShipTo_Section"
        static let shipTo = "cell_ShipTo"
        static let giftMsg = "cell_GiftMsg"
        static let payment = "cell_Payment"
        static let billing = "cell_Billing"
        static let summary = "cell_Summary"
        static let coupon = "cell_Coupon"
    }
}



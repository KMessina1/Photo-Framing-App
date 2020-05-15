/*--------------------------------------------------------------------------------------------------------------------------
   File: Cells.swift
 Author: Kevin Messina
Created: Jan. 26, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** FAQ ***
class cell_FAQTopic:UITableViewCell {
    @IBOutlet var lbl_Topic:UILabel!
    @IBOutlet var lbl_Body:UILabel!
}

// MARK: - *** CHECKOUT ***
class cell_Coupon:UITableViewCell {
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    @IBOutlet var lbl_Code:UILabel!
    @IBOutlet var lbl_Description:UILabel!
    @IBOutlet var swCoupon:UISwitch!
    @IBOutlet var lbl_BetaTest:UILabel!
}

class cell_GiftMsg:UITableViewCell {
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    @IBOutlet var vw_Message:UIView!
    @IBOutlet var lbl_GiftMsg:UILabel!
    @IBOutlet var txt_GiftText:UITextView!
    @IBOutlet var swGiftMsg:CAS_Switch!
    @IBOutlet weak var constraint_GiftMsg: NSLayoutConstraint!
}

class cell_ShipTo:UITableViewCell {
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    @IBOutlet var lbl_Name:UILabel!
    @IBOutlet var lbl_Address:UILabel!
    @IBOutlet var lbl_Incomplete:UILabel!
    @IBOutlet weak var lbl_ID: UILabel!
    @IBOutlet weak var img_ID: UIImageView!
}

class cell_Account:UITableViewCell {
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    @IBOutlet var lbl_titleName:UILabel!
    @IBOutlet var lbl_titleEmail:UILabel!
    @IBOutlet var lbl_titleCustNum:UILabel!
    @IBOutlet var lbl_Name:UILabel!
    @IBOutlet var lbl_Email:UILabel!
    @IBOutlet var lbl_CustNum:UILabel!
    @IBOutlet var lbl_Incomplete:UILabel!
}

class cell_Payment:UITableViewCell {
    @IBOutlet var lbl_CCNum:UILabel!
    @IBOutlet var lbl_CCName:UILabel!
    @IBOutlet var lbl_Exp:UILabel!
    @IBOutlet var img_CC:UIImageView!
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    @IBOutlet var lbl_Incomplete:UILabel!
    @IBOutlet var lbl_BetaTest:UILabel!
    @IBOutlet var lbl_ApplePay:UILabel!
}

class cell_Contact:UITableViewCell {
    @IBOutlet var lbl_TitlePhone:UILabel!
    @IBOutlet var lbl_TitleEmail:UILabel!
    @IBOutlet var lbl_Phone:UILabel!
    @IBOutlet var lbl_Email:UILabel!
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    
}

class cell_Summary:UITableViewCell {
    @IBOutlet var lbl_ItemTitles:UILabel!
    @IBOutlet var lbl_Items:UILabel!
    @IBOutlet var lbl_Total_Title:UILabel!
    @IBOutlet var lbl_Total:UILabel!
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
}

class cell_Billing:UITableViewCell {
    @IBOutlet var lbl_Name:UILabel!
    @IBOutlet var lbl_Address:UILabel!
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var lbl_Header:UILabel!
    @IBOutlet var btn_Edit:UIButton!
    @IBOutlet var lbl_Incomplete:UILabel!
}


// MARK: - *** SHOPPING CART ***
class cell_ShoppingCart:UITableViewCell {
    @IBOutlet var lbl_Color:UILabel!
    @IBOutlet var lbl_Size:UILabel!
    @IBOutlet var lbl_Format:UILabel!
    @IBOutlet var lbl_Quantity:UILabel!
    @IBOutlet var lbl_Price:UILabel!
    @IBOutlet var img_Thumbnail:UIImageView!
    @IBOutlet var step_Qty:UIStepper!
    @IBOutlet var lbl_Title_Color:UILabel!
    @IBOutlet var lbl_Title_Size:UILabel!
    @IBOutlet var lbl_Title_Format:UILabel!
    @IBOutlet var lbl_Title_Price:UILabel!
    @IBOutlet var lbl_Title_Quantity:UILabel!
    @IBOutlet var vw_Line:UIView!
    @IBOutlet var vw_Qty:UIStackView!
}

// MARK: - *** ORDERS ***
class cell_Orders:UITableViewCell {
    @IBOutlet var lbl_date_Title:UILabel!
    @IBOutlet var lbl_date:UILabel!
    @IBOutlet var lbl_number_Title:UILabel!
    @IBOutlet var lbl_number:UILabel!
    @IBOutlet var lbl_shipTo_Title:UILabel!
    @IBOutlet var lbl_shipTo:UILabel!
    @IBOutlet var lbl_total_Title:UILabel!
    @IBOutlet var lbl_total:UILabel!
    @IBOutlet var lbl_items_Title:UILabel!
    @IBOutlet var lbl_items:UILabel!
    @IBOutlet var lbl_status_Title:UILabel!
    @IBOutlet var lbl_status:UILabel!
}

// MARK: - *** PHOTOS ***
class cell_Browser:UICollectionViewCell {
    @IBOutlet var img_Photo:UIImageView!
}

class cell_BrowserText:UICollectionViewCell {
    @IBOutlet var lbl_Text:UILabel!
}


// MARK: - *** ACCOUNT ***
class cell_Reset:UITableViewCell {
    @IBOutlet var sw_Reset:CAS_Switch!
    @IBOutlet var lbl_Title:UILabel!
}

class cell_SFAcct:UITableViewCell {
    @IBOutlet var sw_MailingList:UISwitch!
    @IBOutlet var btn_Privacy:UIButton!
    @IBOutlet var lbl_notes:UILabel!
    @IBOutlet var lbl_CustNum_Title:UILabel!
    @IBOutlet var lbl_CustNum:UILabel!
}

class cell_BillingSection:UITableViewCell {
    @IBOutlet var img_Logo:UIImageView!
    @IBOutlet var lbl_Name:UILabel!
    @IBOutlet var btn_Edit:UIButton!
}

class cell_AccountSection:UITableViewCell {
    @IBOutlet var img_Logo:UIImageView!
    @IBOutlet var lbl_Name:UILabel!
}

class cell_MyInfo:UITableViewCell {
    @IBOutlet var lbl_Email:UILabel!
    @IBOutlet var lbl_TitleEmail:UILabel!
}

class cell_CC:UITableViewCell {
    @IBOutlet var lbl_CardNum:UILabel!
    @IBOutlet var lbl_Exp:UILabel!
    @IBOutlet var lbl_CVN:UILabel!
    @IBOutlet var lbl_Name:UILabel!
    @IBOutlet var lbl_Nickname:UILabel!
    @IBOutlet var lbl_ExpTitle:UILabel!
    @IBOutlet var lbl_CVNTitle:UILabel!
    @IBOutlet var img_Card:UIImageView!
}

// MARK: -
class cell_InstagramInfo:UITableViewCell {
    @IBOutlet var lbl_Fullname:UILabel!
    @IBOutlet var img_Profile:UIImageView!
    @IBOutlet var img_Instagram:UIImageView!
    @IBOutlet var btn_Login:UIButton!
}


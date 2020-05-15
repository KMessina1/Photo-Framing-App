/*--------------------------------------------------------------------------------------------------------------------------
 File: VC_InputTable_Cells.swift
 Author: Kevin Messina
 Created: June 15, 2017
 
 ©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 --------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** ENUM CONSTANTS ***
public enum InputTableCellType { case
        text,segBar,swtch,text_Number,text_Decimal,text_Weight,text_Currency,text_Notes,text_Zipcode,text_Phone,text_Email,
        popover_Country,popover_State,
        popover_Month,popover_Year,
        popover_Array,popover_Date,popover_MultiArray,
        photo,
        text_CVN,creditCard
    }

// MARK: - *** GLOBAL STRUCTS ***
public struct InputTableStruct {
    var cellType:InputTableCellType
    var placeholder:String
    var value:String
    var dataKey:String
    var image:UIImage
    var reliantDataKeyNotGreater:String
    var popoverData:[String]
    var multiData:[[String]]
    var multiDataRecords:[[String:AnyObject]]
    var multiDataSelections:[String]
    var multiDataKeys:[String]
    var multiDataWidths:[Int]
    var multiDataColors:[UIColor]
    var multiDataReliantPlaceholder:String
    var multiDataReliantDataKey:String
    var decimalPlaces:Int
    var segBarTitles:[String]
    var segShowImages:Bool
    var showAsPicker:Bool
    var isEditable:Bool
    var required:Bool
    
    init(cellType:InputTableCellType,
         placeholder:String,
         value:String? = "",
         dataKey:String,
         image:UIImage? = #imageLiteral(resourceName: "CAS_Picker_List"),
         reliantDataKeyNotGreater:String? = "",
         popoverData:[String]? = [],
         multiData:[[String]]? = [],
         multiDataRecords:[[String:AnyObject]]? = [],
         multiDataSelections:[String]? = [],
         multiDataKeys:[String]? = [],
         multiDataWidths:[Int]? = [],
         multiDataColors:[UIColor]? = [],
         multiDataReliantPlaceholder:String? = "",
         multiDataReliantDataKey:String? = "",
         decimalPlaces:Int? = 0,
         segBarTitles:[String]? = [],
         segShowImages:Bool? = false,
         showAsPicker:Bool? = false,
         isEditable:Bool? = false,
         required:Bool? = false) {
        
        self.cellType = cellType
        self.placeholder = placeholder
        self.value = value!
        self.image = image!
        self.dataKey = dataKey
        self.reliantDataKeyNotGreater = reliantDataKeyNotGreater!
        self.popoverData = popoverData!
        self.multiData = multiData!
        self.multiDataRecords = multiDataRecords!
        self.multiDataSelections = multiDataSelections!
        self.multiDataKeys = multiDataKeys!
        self.multiDataWidths = multiDataWidths!
        self.multiDataColors = multiDataColors!
        self.multiDataReliantPlaceholder = multiDataReliantPlaceholder!
        self.multiDataReliantDataKey = multiDataReliantDataKey!
        self.decimalPlaces = decimalPlaces!
        self.segBarTitles = segBarTitles!
        self.segShowImages = segShowImages!
        self.showAsPicker = showAsPicker!
        self.isEditable = isEditable!
        self.required = required!
    }
}

// MARK: - *** CLASSES ***
class cell_InputSegBar:UITableViewCell {
    @IBOutlet var seg_Item:UISegmentedControl!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var lbl_Required: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
}

class cell_InputPhoto:UITableViewCell {
    @IBOutlet var imgPhoto:UIImageView!
    @IBOutlet var btnSelect:UIButton!
    @IBOutlet var btnRemove:UIButton!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var lbl_Required: UILabel!
}

class cell_InputTextField:UITableViewCell {
    @IBOutlet var txt_Item:HoshiTextField!
    @IBOutlet weak var lbl_Required: UILabel!
}

class cell_InputSwitch:UITableViewCell {
    @IBOutlet var sw_Item:CAS_Switch!
    @IBOutlet var lbl_Item:UILabel!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var lbl_Required: UILabel!
}

class cell_InputPopoverTable:UITableViewCell {
    @IBOutlet var txt_Item:HoshiTextField!
    @IBOutlet var lbl_Item:UILabel!
    @IBOutlet weak var lbl_Required: UILabel!
    @IBOutlet var btnRemove:UIButton!
}


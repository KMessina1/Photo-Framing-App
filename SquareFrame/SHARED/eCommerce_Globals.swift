/*--------------------------------------------------------------------------------------------------------------------------
    File: eCommerce_Globals.swift
  Author: Kevin Messina
 Created: January 23, 2018
 
 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 --------------------------------------------------------------------------------------------------------------------------*/


// MARK: - ******************************
// MARK: SERVER SCRIPT CONSTANTS
// MARK: ****************************** -


// MARK: - ******************************
// MARK: GLOBAL CONSTANTS
// MARK: ****************************** -
//MARK: Moltin
let statusUpdateColors:[UIColor] = orderProgressColors.arr
let statusUpdateImages:[UIImage] = [#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport"),#imageLiteral(resourceName: "WIN_ImportExport")]
let Shipping_Prices:[Double]! = [5.00,10.00]
let Frame_Format_Names:[String]! = ["Square","Rectangular"]
let Frame_Format_Names_All:[String]! = [
    "Square","Square","Square","Square",
    "Rectangular","Rectangular","Rectangular","Rectangular"
]
let Frame_Format_Sizes_All:[String]! = [
    "4x4","4x4","5x5","8x8",
    "4x6","4x6","5x7","8x10"
]
let Frame_Color_Names:[String]! = ["Natural","Black","White","Walnut","Gray Wash"]
let Frame_Color_Codes:[String]! = ["na","bk","wh","br","gy"]
let Frame_Size_Names_Square:[String]! = ["4\"x4\"","4\"x4\"","5\"x5\"","8\"x8\""]
let Frame_Size_Names_Rect:[String]! = ["4\"x6\"","4\"x6\"","5\"x7\"","8\"x10\""]
let Frame_Size_Names:[String]! = [
    "4\"x4\"","4\"x4\"","5\"x5\"","8\"x8\"",
    "4\"x6\"","4\"x6\"","5\"x7\"","8\"x10\""
]
let Frame_FramedSize_Names:[String]! = [
    "5⅞\"x5⅞\"","8⅛\"x8⅛\"","9⅝\"x9⅝\"","13⅛\"x13⅛\"",
    "5⅞\"x7⅞\"","8⅛\"x10⅛\"","9⅝\"x11⅝\"","13⅛\"x15⅛\""
]
let Frame_FramedSize_NamesDecimal:[String]! = [
    "5.8x5.8","8.13x8.13","9.63x9.63 ","13.13x13.13",
    "5.8x7.8","8.13x10.13","9.63x11.63","13.13x15.13"
]
let FrameImages:[String]! = [
    "Frame_Square_Natural","Frame_Square_Black","Frame_Square_White","Frame_Square_Brown","Frame_Square_Gray",
    "Frame_Rect_Natural","Frame_Rect_Black","Frame_Rect_White","Frame_Rect_Brown","Frame_Rect_Gray"
]
let FrameSwatches:[String]! = [
    "Swatch_Natural","Swatch_Black","Swatch_White","Swatch_Brown","Swatch_Gray",
    "Swatch_Natural","Swatch_Black","Swatch_White","Swatch_Brown","Swatch_Gray"
]

let noPhoto_Square:UIImage = UIImage(named: "NoPhoto_Sq")!
let noPhoto_Rect:UIImage = UIImage(named: "NoPhoto_Landscape")!
var noPhotoSelected:[UIImage]! = [
    noPhoto_Square,noPhoto_Square,noPhoto_Square,noPhoto_Square,
    noPhoto_Rect,noPhoto_Rect,noPhoto_Rect,noPhoto_Rect
]
let FrameImgs_Rect_SL:[UIImage]! = [#imageLiteral(resourceName: "Rectangle_Natural_Slimline.png"),#imageLiteral(resourceName: "Rectangle_Black_Slimline.png"),#imageLiteral(resourceName: "Rectangle_White_Slimline.png"),#imageLiteral(resourceName: "Rectangle_Walnut Brown_Slimline.png"),#imageLiteral(resourceName: "Rectangle_Gray Wash_Slimline.png")] // 5-Color Frames
let FrameImgs_Square_SL:[UIImage]! = [#imageLiteral(resourceName: "Square_Natural_Slimline.png"),#imageLiteral(resourceName: "Square_Black_Slimline.png"),#imageLiteral(resourceName: "Square_White_Slimline.png"),#imageLiteral(resourceName: "Square_Walnut Brown_Slimline.png"),#imageLiteral(resourceName: "Square_Gray Wash_Slimline.png")] // 5-Color Frames
let FrameImgs_SL:[UIImage]! = FrameImgs_Rect_SL + FrameImgs_Square_SL
let FrameImgs_Rect_ST:[UIImage]! = [#imageLiteral(resourceName: "Frame_Rect_Natural"),#imageLiteral(resourceName: "Frame_Rect_Black"),#imageLiteral(resourceName: "Frame_Rect_White"),#imageLiteral(resourceName: "Frame_Rect_Brown"),#imageLiteral(resourceName: "Frame_Rect_Gray")] // 5-Color Frames
let FrameImgs_Square_ST:[UIImage]! = [#imageLiteral(resourceName: "Frame_Square_Natural"),#imageLiteral(resourceName: "Frame_Square_Black"),#imageLiteral(resourceName: "Frame_Square_White"),#imageLiteral(resourceName: "Frame_Square_Brown"),#imageLiteral(resourceName: "Frame_Square_Gray")] // 5-Color Frames
let FrameImgs_ST:[UIImage]! = FrameImgs_Rect_ST + FrameImgs_Square_ST

// MARK: - ******************************
// MARK: GLOBAL ENUM CONSTANTS
// MARK: ****************************** -
enum orderProgressFilters:Int {
    case new,paid,processing,shipped,issue,delivered,unpaid,declined,refunded,partiallyRefunded,cancelled,failed,mismatch,all
    
    static let count: Int = {
        var max: Int = 0
        while let _ = orderProgressFilters(rawValue: max) { max += 1 }
        return max
    }()
}

enum frameStlyeFilters:Int { case slimline,standard
    static let count: Int = {
        var max: Int = 0
        while let _ = frameStlyeFilters(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum frameColorFilters:Int { case black,walnut,graywash,natural,white
    static let count: Int = {
        var max: Int = 0
        while let _ = frameColorFilters(rawValue: max) { max += 1 }
        return max
    }()
}

enum frameFormatFilters:Int {
    case square
    case rectangular
    
    static let count: Int = {
        var max: Int = 0
        while let _ = frameFormatFilters(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum shippingMethodType:Int { case standard,priority
    static let count: Int = {
        var max: Int = 0
        while let _ = shippingMethodType(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_Format:Int { case square,rectangle,all
    static let count: Int = {
        var max: Int = 0
        while let _ = Frame_Format(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_Orientation:Int { case portrait,landscape,all
    static let count: Int = {
        var max: Int = 0
        while let _ = Frame_Orientation(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_Color:Int { case natural,black,white,walnut,graywash
    static let count: Int = {
        var max: Int = 0
        while let _ = Frame_Color(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_ColorCode:Int { case na,bl,wh,br,gy
    static let count: Int = {
        var max: Int = 0
        while let _ = Frame_ColorCode(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_Size_Square:Int { case square_4x4_SL,square_4x4_ST,square_5x5,square_8x8
    static let count: Int = {
        var max:Int = 0
        while let _ = Frame_Size_Square(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_Size_Rect:Int { case rect_4x6_SL,rect_4x6_ST,rect_5x7,rect_8x10
    static let count: Int = {
        var max: Int = 0
        while let _ = Frame_Size_Rect(rawValue: max) { max += 1 }
        return max
    }()
}

// MARK: -
//MARK: Moltin
enum Frame_Size_All:Int { case square_4x4_SL,square_4x4_ST,square_5x5,square_8x8,rect_4x6_SL,rect_4x6_ST,rect_5x7,rect_8x10
    static let count: Int = {
        var max: Int = 0
        while let _ = Frame_Size_All(rawValue: max) { max += 1 }
        return max
    }()
}


// MARK: - ******************************
// MARK: GLOBAL CLASSES
// MARK: ****************************** -
class Item:Loopable {
    let Version:String = "1.01"
    let name:String = "Item"

    var photoFormat:Int!
    var size:Int!
    var color:Int!
    var format:Int!
    var quantity:Int!
    var price:Double!
    var amount:Double!
    var scale:CGFloat!
    var photo:UIImage!
    var frame:UIImage!
    var SKU:String!
    var photoInfo:Photo!
    var style:Int!
    var matteColor:Int!
    var material:Int!

    init(
        photoFormat:Int? = 0,
        size:Int? = 0,
        quantity:Int? = 0,
        color:Int? = 0,
        format:Int? = 0,
        scale:CGFloat? = 0,
        price:Double? = 0.00,
        amount:Double? = 0.00,
        photo:UIImage? = UIImage(),
        frame:UIImage? = UIImage(),
        SKU:String? = "",
        photoInfo:Photo? = nil,
        style:Int? = 0,
        matteColor:Int? = 0,
        material:Int? = 0
    ){
        self.photoFormat = photoFormat
        self.quantity = quantity
        self.size = size
        self.color = color
        self.format = format
        self.scale = scale
        self.price = price
        self.amount = amount
        self.photo = photo
        self.frame = frame
        self.SKU = SKU
        self.photoInfo = photoInfo
        self.style = style
        self.matteColor = matteColor
        self.material = material
    }
}

class TempItem:Loopable {
    let Version:String = "1.01"
    let name:String = "Temp Item"

    var photoFormat:Int!
    var size:Int!
    var color:Int!
    var format:Int!
    var quantity:Int!
    var price:Double!
    var amount:Double!
    var scale:CGFloat!
    var photo:UIImage!
    var frame:UIImage!
    var SKU:String!
    var photoInfo:Photo!
    var style:Int!
    var matteColor:Int!
    var material:Int!

    init(
        photoFormat:Int? = 0,
        size:Int? = 0,
        quantity:Int? = 0,
        color:Int? = 0,
        format:Int? = 0,
        scale:CGFloat? = 0,
        price:Double? = 0.00,
        amount:Double? = 0.00,
        photo:UIImage? = UIImage(),
        frame:UIImage? = UIImage(),
        SKU:String? = "",
        photoInfo:Photo? = nil,
        style:Int? = 0,
        matteColor:Int? = 0,
        material:Int? = 0
    ){
        self.photoFormat = photoFormat
        self.quantity = quantity
        self.size = size
        self.color = color
        self.format = format
        self.scale = scale
        self.price = price
        self.amount = amount
        self.photo = photo
        self.frame = frame
        self.SKU = SKU
        self.photoInfo = photoInfo
        self.style = style
        self.matteColor = matteColor
        self.material = material
    }
}

// MARK: -
class Order {
    let Version:String = "1.01"
    let name:String = "Order"

    var number:String = ""
    var filename:String = ""
    var filepath:String = ""
    
    init (number:String?="",filename:String?="",filepath:String?=""){
        self.number = number!
        self.filename = filename!
        self.filepath = filepath!
    }
}


// MARK: - ******************************
// MARK: GLOBAL STRUCTS
// MARK: ****************************** -
struct dbActions {
    struct PHP {
        struct order {
            static let addItem:String = "orderItem.ADD"
            static let add:String = "order.ADD"
            static let update:String = "order.EDIT"
            static let delete:String = "order.DELETE"
            static let exists:String = "order.EXISTS"
        }
        struct customer {
            static let add:String = "customer.ADD"
            static let update:String = "customer.EDIT"
            static let delete:String = "customer.DELETE"
            static let exists:String = "customer.EXISTS"
        }
        struct address {
            static let add:String = "address.ADD"
            static let update:String = "address.EDIT"
            static let delete:String = "address.DELETE"
            static let exists:String = "address.EXISTS"
        }
        struct products {
            static let add:String = "products.ADD"
            static let update:String = "products.EDIT"
            static let delete:String = "products.DELETE"
            static let exists:String = "products.EXISTS"
        }
        struct frameShapes {
            static let add:String = "frameShape.ADD"
            static let update:String = "frameShape.EDIT"
            static let delete:String = "frameShape.DELETE"
            static let exists:String = "frameShape.EXISTS"
        }
        struct matteColors {
            static let add:String = "matteColors.ADD"
            static let update:String = "matteColors.EDIT"
            static let delete:String = "matteColors.DELETE"
            static let exists:String = "matteColors.EXISTS"
        }
        struct photoSize {
            static let add:String = "photoSize.ADD"
            static let update:String = "photoSize.EDIT"
            static let delete:String = "photoSize.DELETE"
            static let exists:String = "photoSize.EXISTS"
        }
        struct frameSize {
            static let add:String = "frameSize.ADD"
            static let update:String = "frameSize.EDIT"
            static let delete:String = "frameSize.DELETE"
            static let exists:String = "frameSize.EXISTS"
        }
        struct frameStyle {
            static let add:String = "frameStyle.ADD"
            static let update:String = "frameStyle.EDIT"
            static let delete:String = "frameStyle.DELETE"
            static let exists:String = "frameStyle.EXISTS"
        }
        struct frameColors {
            static let add:String = "frameColors.ADD"
            static let update:String = "frameColors.EDIT"
            static let delete:String = "frameColors.DELETE"
            static let exists:String = "frameColors.EXISTS"
        }
        static let list:String = "LIST"
        static let add:String = "ADD"
        static let edit:String = "EDIT"
        static let delete:String = "DELETE"
        static let search:String = "SEARCH"
        static let exists:String = "EXISTS"
    }
    struct SEND {
        static let verb:String = "Sending"
        static let noun:String = "Send"
    }
    struct RESEND {
        static let verb:String = "Re-Sending"
        static let noun:String = "Re-Send"
    }
    struct UPDATE {
        static let verb:String = "Updating"
        static let noun:String = "Update"
    }
    struct DELETE {
        static let verb:String = "Deleting"
        static let noun:String = "Delete"
    }
    struct INSERT {
        static let verb:String = "Adding"
        static let noun:String = "Add"
    }
    struct LIST {
        static let verb:String = "Getting"
        static let noun:String = "Get"
    }
    struct SEARCH {
        static let verb:String = "Searching"
        static let noun:String = "Search"
    }
    struct VALIDATE {
        static let verb:String = "Validating"
        static let noun:String = "Validate"
    }
    struct COMPLETING {
        static let verb:String = "Completing"
        static let noun:String = "Complete"
    }
}

struct orderStatusImages {
    static let new:UIImage = #imageLiteral(resourceName: "new")
    static let paid:UIImage = #imageLiteral(resourceName: "new")
    static let processing:UIImage = #imageLiteral(resourceName: "Status_Packaging")
    static let dispatched:UIImage = #imageLiteral(resourceName: "dispatched")
    static let shipped:UIImage = #imageLiteral(resourceName: "dispatched")
    static let delivered:UIImage = #imageLiteral(resourceName: "delivered")
    static let issue:UIImage = #imageLiteral(resourceName: "admin_Issues")
    static let unpaid:UIImage = #imageLiteral(resourceName: "unpaid")
    static let declined:UIImage = #imageLiteral(resourceName: "declined")
    static let refunded:UIImage = #imageLiteral(resourceName: "refunded")
    static let partiallyRefunded:UIImage = #imageLiteral(resourceName: "refunded")
    static let cancelled:UIImage = #imageLiteral(resourceName: "Cancelled")
    static let failed:UIImage = #imageLiteral(resourceName: "failed")
    static let mismatch:UIImage = #imageLiteral(resourceName: "Status_Issue")
    static let test:UIImage = #imageLiteral(resourceName: "Status_Test")
    static let all:UIImage = #imageLiteral(resourceName: "All")
    
    static let arr:[UIImage] = [new,paid,processing,shipped,issue,delivered,unpaid,declined,refunded,partiallyRefunded,cancelled,failed,mismatch,test,all]
    static let count:Int = orderStatusImages.arr.count
}

// MARK: -
struct orderStatus {
    static let new:String = "New"
    static let paid:String = "Paid"
    static let processing:String = "Processing"
    static let dispatched:String = "Dispatched"
    static let shipped:String = "Shipped"
    static let delivered:String = "Delivered"
    static let issue:String = "Issue"
    static let unpaid:String = "Unpaid"
    static let declined:String = "Declined"
    static let refunded:String = "Refunded"
    static let partiallyRefunded:String = "Partially Refunded"
    static let cancelled:String = "Cancelled"
    static let failed:String = "Failed"
    static let mismatch:String = "Mismatch"
    static let test:String = "Test"
    static let all:String = "All"
    
    static let arr:[String] = [new,paid,processing,shipped,issue,delivered,unpaid,declined,refunded,partiallyRefunded,cancelled,failed,mismatch,test,all]
    static let count:Int = orderStatus.arr.count
}

// MARK: -
struct orderProgress {
    static let new:String = "New"
    static let paid:String = "Paid"
    static let processing:String = "Processing"
    static let dispatched:String = "Dispatched"
    static let shipped:String = "Shipped"
    static let issue:String = "Issue"
    static let delivered:String = "Delivered"
    static let unpaid:String = "Unpaid"
    static let declined:String = "Declined"
    static let refunded:String = "Refunded"
    static let partiallyRefunded:String = "Partially Refunded"
    static let cancelled:String = "Cancelled"
    static let failed:String = "Failed"
    static let mismatch:String = "Mismatch"
    static let test:String = "Test"
    static let all:String = "All"

    static let arr:[String] = [new,paid,processing,shipped,issue,delivered,unpaid,declined,refunded,partiallyRefunded,cancelled,failed,mismatch,test,all]
    static let count:Int = orderProgress.arr.count
}

// MARK: -
struct orderProgressColors {
    static let new = #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
    static let paid = #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
    static let processing = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    static let dispatched = #colorLiteral(red: 0.1024172083, green: 0.6504989266, blue: 0.5533954501, alpha: 1)
    static let shipped = #colorLiteral(red: 0.1024172083, green: 0.6504989266, blue: 0.5533954501, alpha: 1)
    static let issue = #colorLiteral(red: 0.9987408519, green: 0.1733306944, blue: 0.3358413577, alpha: 1)
    static let delivered = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    static let unpaid = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    static let declined = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    static let refunded = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
    static let partiallyRefunded = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    static let cancelled = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    static let failed = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    static let mismatch = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    static let test = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    static let all = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    
    static let arr:[UIColor] = [new,paid,processing,shipped,issue,delivered,unpaid,declined,refunded,partiallyRefunded,cancelled,failed,mismatch,test,all]
    static let count:Int = orderProgressColors.arr.count
}

// MARK: -
// MARK: -
struct issueErrors {
    static let none:String = "None"
    // Delivery
    static let undelivered:String = "Undelivered"
    static let moved:String = "Moved from Address"
    static let refused:String = "Refused Delivery"
    static let returned:String = "Returned Delivery"
    static let undeliverable:String = "Undeliverable Address"
    static let invalid:String = "Invalid Address"
    static let wrong:String = "Wrong Address"
    static let postage:String = "Insufficient Postage"
    static let damaged:String = "Damaged"
    // Fulfillment
    static let photoNotFound:String = "Photo Not Found"
    static let photoInferior:String = "Photo Poor Quality"
    // Other
    static let other:String = "Other"
    
    static let arr:[String] = [
        issueErrors.none,
        issueErrors.undelivered,issueErrors.moved,issueErrors.refused,issueErrors.returned,issueErrors.undeliverable,
        issueErrors.invalid,issueErrors.wrong,issueErrors.postage,issueErrors.damaged,
        issueErrors.photoNotFound,issueErrors.photoInferior,
        issueErrors.other
    ]
}

// MARK: -
struct Amount {
    var totalWithoutTax:Double! = 0.00
    var totalTax:Double! = 0.00
    var totalWithTax:Double! = 0.00
}


// MARK: -
struct photoPixelSizes {
    struct min {
        static let _4x4:CGSize = CGSize(width:360, height:360)
        static let _4x6:CGSize = CGSize(width:540, height:360)
        static let _5x5:CGSize = CGSize(width:450, height:450)
        static let _5x7:CGSize = CGSize(width:630, height:450)
        static let _8x8:CGSize = CGSize(width:720, height:720)
        static let _8x10:CGSize = CGSize(width:900, height:720)
    }

    struct max {
        static let square:CGSize = CGSize(width:1080, height:1080)
        static let rect:CGSize = CGSize(width:1080, height:864)
    }
}

// MARK: -
struct framePrevImgs {
    struct BLACK {
        static let _4x4SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3247.jpg"),#imageLiteral(resourceName: "6A4A3246.jpg"),#imageLiteral(resourceName: "6A4A3248.jpg")]
        static let _4x4ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3285.jpg"),#imageLiteral(resourceName: "6A4A3288.jpg"),#imageLiteral(resourceName: "6A4A3289.jpg")]
        static let _4x6SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3265.jpg"),#imageLiteral(resourceName: "6A4A3264.jpg"),#imageLiteral(resourceName: "6A4A3262.jpg")]
        static let _4x6ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3330.jpg"),#imageLiteral(resourceName: "6A4A3327.jpg"),#imageLiteral(resourceName: "6A4A3328.jpg")]
        static let _5x5ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3340.jpg"),#imageLiteral(resourceName: "6A4A3343.jpg"),#imageLiteral(resourceName: "6A4A3339.jpg")]
        static let _5x7ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3369.jpg"),#imageLiteral(resourceName: "6A4A3373.jpg"),#imageLiteral(resourceName: "6A4A3371.jpg")]
        static let _8x8ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3378.jpg"),#imageLiteral(resourceName: "6A4A3374.jpg"),#imageLiteral(resourceName: "6A4A3375.jpg")]
        static let _8x10ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3435.jpg"),#imageLiteral(resourceName: "6A4A3434.jpg"),#imageLiteral(resourceName: "6A4A3431.jpg")]
    }
    struct GRAYWASH {
        static let _4x4SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3241.jpg"),#imageLiteral(resourceName: "6A4A3240.jpg"),#imageLiteral(resourceName: "6A4A3238.jpg")]
        static let _4x4ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3279.jpg"),#imageLiteral(resourceName: "6A4A3284.jpg"),#imageLiteral(resourceName: "6A4A3282.jpg")]
        static let _4x6SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3259.jpg"),#imageLiteral(resourceName: "6A4A3260.jpg"),#imageLiteral(resourceName: "6A4A3261.jpg")]
        static let _4x6ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3325.jpg"),#imageLiteral(resourceName: "6A4A3326.jpg"),#imageLiteral(resourceName: "6A4A3323.jpg")]
        static let _5x5ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3279.jpg"),#imageLiteral(resourceName: "6A4A3284.jpg"),#imageLiteral(resourceName: "6A4A3282.jpg")]
        static let _5x7ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3354.jpg"),#imageLiteral(resourceName: "6A4A3356.jpg"),#imageLiteral(resourceName: "6A4A3357.jpg")]
        static let _8x8ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3382.jpg"),#imageLiteral(resourceName: "6A4A3381.jpg"),#imageLiteral(resourceName: "6A4A3380.jpg")]
        static let _8x10ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3414.jpg"),#imageLiteral(resourceName: "6A4A3415.jpg"),#imageLiteral(resourceName: "6A4A3412.jpg")]
    }
    struct NATURAL {
        static let _4x4SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3233.jpg"),#imageLiteral(resourceName: "6A4A3235.jpg"),#imageLiteral(resourceName: "6A4A3234.jpg")]
        static let _4x4ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3278.jpg"),#imageLiteral(resourceName: "6A4A3276.jpg"),#imageLiteral(resourceName: "6A4A3275.jpg")]
        static let _4x6SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3256.jpg"),#imageLiteral(resourceName: "6A4A3257.jpg"),#imageLiteral(resourceName: "6A4A3254.jpg")]
        static let _4x6ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3310.jpg"),#imageLiteral(resourceName: "6A4A3313.jpg"),#imageLiteral(resourceName: "6A4A3314.jpg")]
        static let _5x5ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3336.jpg"),#imageLiteral(resourceName: "6A4A3337.jpg"),#imageLiteral(resourceName: "6A4A3338.jpg")]
        static let _5x7ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3350.jpg"),#imageLiteral(resourceName: "6A4A3351.jpg"),#imageLiteral(resourceName: "6A4A3348.jpg")]
        static let _8x8ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3391.jpg"),#imageLiteral(resourceName: "6A4A3392.jpg"),#imageLiteral(resourceName: "6A4A3389.jpg")]
        static let _8x10ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3420.jpg"),#imageLiteral(resourceName: "6A4A3422.jpg"),#imageLiteral(resourceName: "6A4A3423.jpg")]
    }
    struct WALNUT {
        static let _4x4SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3219.jpg"),#imageLiteral(resourceName: "6A4A3223.jpg"),#imageLiteral(resourceName: "6A4A3237.jpg")]
        static let _4x4ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3271.jpg"),#imageLiteral(resourceName: "6A4A3270.jpg"),#imageLiteral(resourceName: "6A4A3273.jpg")]
        static let _4x6SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3250.jpg"),#imageLiteral(resourceName: "6A4A3252.jpg"),#imageLiteral(resourceName: "6A4A3249.jpg")]
        static let _4x6ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3309.jpg"),#imageLiteral(resourceName: "6A4A3304.jpg"),#imageLiteral(resourceName: "6A4A3306.jpg")]
        static let _5x5ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3332.jpg"),#imageLiteral(resourceName: "6A4A3335.jpg"),#imageLiteral(resourceName: "6A4A3334.jpg")]
        static let _5x7ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3358.jpg"),#imageLiteral(resourceName: "6A4A3360.jpg"),#imageLiteral(resourceName: "6A4A3362.jpg")]
        static let _8x8ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3397.jpg"),#imageLiteral(resourceName: "6A4A3401.jpg"),#imageLiteral(resourceName: "6A4A3398.jpg")]
        static let _8x10ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3402.jpg"),#imageLiteral(resourceName: "6A4A3407.jpg"),#imageLiteral(resourceName: "6A4A3405.jpg")]
    }
    struct WHITE {
        static let _4x4SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3244.jpg"),#imageLiteral(resourceName: "6A4A3242.jpg"),#imageLiteral(resourceName: "6A4A3243.jpg")]
        static let _4x4ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3293.jpg"),#imageLiteral(resourceName: "6A4A3290.jpg"),#imageLiteral(resourceName: "6A4A3294.jpg")]
        static let _4x6SL:[UIImage] = [#imageLiteral(resourceName: "6A4A3269.jpg"),#imageLiteral(resourceName: "6A4A3268.jpg"),#imageLiteral(resourceName: "6A4A3267.jpg")]
        static let _4x6ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3318.jpg"),#imageLiteral(resourceName: "6A4A3319.jpg"),#imageLiteral(resourceName: "6A4A3322.jpg")]
        static let _5x5ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3347.jpg"),#imageLiteral(resourceName: "6A4A3344.jpg"),#imageLiteral(resourceName: "6A4A3345.jpg")]
        static let _5x7ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3368.jpg"),#imageLiteral(resourceName: "6A4A3366.jpg"),#imageLiteral(resourceName: "6A4A3364.jpg")]
        static let _8x8ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3384.jpg"),#imageLiteral(resourceName: "6A4A3385.jpg"),#imageLiteral(resourceName: "6A4A3387.jpg")]
        static let _8x10ST:[UIImage] = [#imageLiteral(resourceName: "6A4A3427.jpg"),#imageLiteral(resourceName: "6A4A3425.jpg"),#imageLiteral(resourceName: "6A4A3429.jpg")]
    }
}

// MARK: -
struct shippingCompanyCodes {
    static let USPS = "USPS"

    static let arr:[String] = [USPS]
    static let count:Int = shippingMethodNames.arr.count
}

// MARK: -
struct shippingCompanyNames {
    static let USPS = "US Postal Service"

    static let arr:[String] = [USPS]
    static let count:Int = shippingMethodNames.arr.count
}

// MARK: -
struct shippingMethodNames {
    static let standard = "USPS Standard Priority"
    static let priority = "USPS Standard Expedited"

    static let arr:[String] = [standard,priority]
    static let count:Int = shippingMethodNames.arr.count
}

// MARK: -
struct frameColorCodes {
    static let natural = "na"
    static let black = "bk"
    static let white = "wh"
    static let walnut = "br"
    static let graywash = "gy"

    static let arr:[String] = [natural,black,white,walnut,graywash]
    static let count:Int = frameColorCodes.arr.count
}

// MARK: -
struct frameColors {
    static let natural = "Natural"
    static let black = "Black"
    static let white = "White"
    static let walnut = "Walnut"
    static let graywash = "Gray Wash"

    static let arr:[String] = [natural,black,white,walnut,graywash]
    static let count:Int = frameColors.arr.count
}

// MARK: -
struct frameFormats {
    static let square = "Square"
    static let rectangular = "Rectangular"

    static let arr:[String] = [square,rectangular]
    static let count:Int = frameFormats.arr.count
}

struct frameFormatCodes {
    static let square = "SQ"
    static let rectangular = "R"
    
    static let arr:[String] = [square,rectangular]
    static let count:Int = frameFormatCodes.arr.count
}

struct frameStyles {
    static let slimline = "Slimline"
    static let standard = "Standard"
    
    static let arr:[String] = [slimline,standard]
    static let count:Int = frameStyles.arr.count
}

struct frameStyleCodes {
    static let slimline = "SL"
    static let standard = "ST"
    
    static let arr:[String] = [slimline,standard]
    static let count:Int = frameFormats.arr.count
}

// MARK: -
typealias photoSizes = photoTemplateSizes
struct photoTemplateSizes {
    static let photoNone = ""
    static let photo4x4 = "4x4"
    static let photo4x6 = "4x6"
    static let photo5x5 = "5x5"
    static let photo5x7 = "5x7"
    static let photo8x8 = "8x8"
    static let photo8x10 = "8x10"

    static let arr:[String] = [photoNone,photo4x4,photo4x6,photo5x5,photo5x7,photo8x8,photo8x10]
    static let count:Int = photoTemplateSizes.arr.count
}

let photoSizeDict = [
    "4x4" : "4\"x4\"",
    "4x6" : "4\"x6\"",
    "5x5" : "5\"x5\"",
    "5x7" : "5\"x7\"",
    "8x8" : "8\"x8\"",
    "8x10" : "8\"x10\""
]



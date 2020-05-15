//
//  CASAlertView.swift
//  CASAlertView Example
//
//  Created by Viktor Radchenko on 6/5/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//  https://github.com/vikmeup/SCLAlertView-Swift

import Foundation
import UIKit

public struct fileTypes {
    struct fileTypesStruct {
        var abbrev:String
        var suffix:String
        var imageName:String
        
        init(
            abbrev:String = "",
            suffix:String = "",
            imageName:String = ""
        ){
            self.abbrev = abbrev
            self.suffix = suffix
            self.imageName = imageName
        }
    }
    
    static let aac = fileTypesStruct.init(abbrev: "aac", suffix: "aac", imageName: "doc_aac")
    static let aif = fileTypesStruct.init(abbrev: "aif", suffix: "aif", imageName: "doc_aiff")
    static let aiff = fileTypesStruct.init(abbrev: "aiff", suffix: "aiff", imageName: "doc_aiff")
    static let app = fileTypesStruct.init(abbrev: "app", suffix: "app", imageName: "doc_app")
    static let audio = fileTypesStruct.init(abbrev: "audio", suffix: "", imageName: "doc_audio")
    static let blank = fileTypesStruct.init(abbrev: "blank", suffix: "", imageName: "doc_blank")
    static let bmp = fileTypesStruct.init(abbrev: "bmp", suffix: "bmp", imageName: "doc_bmp")
    static let chart = fileTypesStruct.init(abbrev: "chart", suffix: "", imageName: "doc_chart")
    static let cloud = fileTypesStruct.init(abbrev: "cloud", suffix: "", imageName: "doc_cloud")
    static let css = fileTypesStruct.init(abbrev: "css", suffix: "css", imageName: "doc_css")
    static let csv = fileTypesStruct.init(abbrev: "csv", suffix: "csv", imageName: "doc_csv")
    static let dmg = fileTypesStruct.init(abbrev: "dmg", suffix: "dmg", imageName: "doc_dmg")
    static let doc = fileTypesStruct.init(abbrev: "doc", suffix: "doc", imageName: "doc_doc")
    static let edit = fileTypesStruct.init(abbrev: "edit", suffix: "", imageName: "doc_edit")
    static let fave = fileTypesStruct.init(abbrev: "fave", suffix: "", imageName: "doc_fave")
    static let font = fileTypesStruct.init(abbrev: "font", suffix: "otd", imageName: "doc_font")
    static let generic = fileTypesStruct.init(abbrev: "generic", suffix: "", imageName: "doc_generic")
    static let gif = fileTypesStruct.init(abbrev: "gif", suffix: "gif", imageName: "doc_gif")
    static let graph = fileTypesStruct.init(abbrev: "graph", suffix: "", imageName: "doc_graph")
    static let html = fileTypesStruct.init(abbrev: "html", suffix: "html", imageName: "doc_html")
    static let jpg = fileTypesStruct.init(abbrev: "jpg", suffix: "jpg", imageName: "doc_jpg")
    static let jpeg = fileTypesStruct.init(abbrev: "jpeg", suffix: "jpeg", imageName: "jpeg")
    static let key = fileTypesStruct.init(abbrev: "key", suffix: "key", imageName: "doc_key")
    static let locked = fileTypesStruct.init(abbrev: "locked", suffix: "", imageName: "doc_locked")
    static let m4v = fileTypesStruct.init(abbrev: "m4v", suffix: "m4v", imageName: "doc_m4v")
    static let markup = fileTypesStruct.init(abbrev: "markup", suffix: "", imageName: "doc_markup")
    static let minus = fileTypesStruct.init(abbrev: "minus", suffix: "", imageName: "doc_minus")
    static let mov = fileTypesStruct.init(abbrev: "mov", suffix: "mov", imageName: "doc_mov")
    static let mp3 = fileTypesStruct.init(abbrev: "mp3", suffix: "mp3", imageName: "doc_mp3")
    static let mp4 = fileTypesStruct.init(abbrev: "mp4", suffix: "mp4", imageName: "doc_mp4")
    static let music = fileTypesStruct.init(abbrev: "music", suffix: "", imageName: "doc_music")
    static let pdf = fileTypesStruct.init(abbrev: "pdf", suffix: "pdf", imageName: "doc_pdf")
    static let photo = fileTypesStruct.init(abbrev: "photo", suffix: "", imageName: "doc_photo")
    static let php = fileTypesStruct.init(abbrev: "php", suffix: "php", imageName: "doc_php")
    static let plus = fileTypesStruct.init(abbrev: "plus", suffix: "", imageName: "doc_plus")
    static let png = fileTypesStruct.init(abbrev: "png", suffix: "png", imageName: "doc_png")
    static let psd = fileTypesStruct.init(abbrev: "psd", suffix: "psd", imageName: "doc_psd")
    static let rtf = fileTypesStruct.init(abbrev: "rtf", suffix: "rtf", imageName: "doc_rtf")
    static let search = fileTypesStruct.init(abbrev: "search", suffix: "", imageName: "doc_search")
    static let spreadsheet = fileTypesStruct.init(abbrev: "spreadsheet", suffix: "", imageName: "doc_spreadsheet")
    static let sql = fileTypesStruct.init(abbrev: "sql", suffix: "sql", imageName: "doc_sql")
    static let tif = fileTypesStruct.init(abbrev: "tif", suffix: "tif", imageName: "doc_tiff")
    static let tiff = fileTypesStruct.init(abbrev: "tiff", suffix: "tiff", imageName: "doc_tiff")
    static let tsv = fileTypesStruct.init(abbrev: "tsv", suffix: "tsv", imageName: "doc_tsv")
    static let txt = fileTypesStruct.init(abbrev: "txt", suffix: "txt", imageName: "doc_txt")
    static let unlocked = fileTypesStruct.init(abbrev: "unlocked", suffix: "", imageName: "doc_unlocked")
    static let wav = fileTypesStruct.init(abbrev: "wav", suffix: "wav", imageName: "doc_wav")
    static let zip = fileTypesStruct.init(abbrev: "zip", suffix: "zip", imageName: "doc_zip")
    static let video = fileTypesStruct.init(abbrev: "video", suffix: "", imageName: "doc_video")

    let arr = [
        aac,aif,aiff,app,audio,blank,bmp,chart,cloud,css,csv,dmg,doc,edit,fave,font,generic,
        gif,graph,html,jpg,jpeg,key,locked,m4v,markup,minus,mov,mp3,mp4,music,pdf,photo,php,
        plus,png,psd,rtf,search,spreadsheet,sql,tif,tiff,tsv,txt,unlocked,wav,zip,video
    ]
}

extension CASAlertView {
    var subViewsWidth: CGFloat {
        return appearance.kWindowWidth - 2 * appearance.margin.horizontal
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


// Alert Styles
public enum CASAlertViewStyle {
    case success,error,notice,warning,info,edit,wait,notAvail,iap,confirm,construction,serverError
    
    public var defaultColorInt: UInt {
        switch self {
            case .success: return 0x22B573
            case .error: return 0xC1272D
            case .notice: return 0x727375
            case .warning: return 0xFFD110
            case .info: return 0x2866BF
            case .edit: return 0xA429FF
            case .wait: return 0xD62DA5
            case .notAvail: return #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1).convertToUInt()
            case .iap: return #colorLiteral(red: 1, green: 0.4929101467, blue: 0.4729757905, alpha: 1).convertToUInt()
            case .confirm: return #colorLiteral(red: 0.8363168836, green: 0.1580680609, blue: 0.2192102373, alpha: 1).convertToUInt()
            case .construction: return #colorLiteral(red: 1, green: 0.5843122602, blue: 0.00580324512, alpha: 1).convertToUInt()
            case .serverError: return #colorLiteral(red: 0.9992914796, green: 0.2296673656, blue: 0.1848383844, alpha: 1).convertToUInt()
        }
    }
}

// Animation Styles
public enum SCLAnimationStyle {
    case noAnimation, topToBottom, bottomToTop, leftToRight, rightToLeft
}

// Action Types
public enum SCLActionType {
    case none, selector, closure
}

// Button Layout
public enum SCLAlertButtonLayout {
    case horizontal, vertical
}

// Button sub-class
open class CASButton: UIButton {
    var actionType = SCLActionType.none
    var target:AnyObject!
    var selector:Selector!
    var action:(()->Void)!
    var customBackgroundColor:UIColor?
    var customTextColor:UIColor?
    var initialTitle:String!
    var showTimeout:ShowTimeoutConfiguration?
    
    public struct ShowTimeoutConfiguration {
        let prefix: String
        let suffix: String
        
        public init(prefix: String = "", suffix: String = "") {
            self.prefix = prefix
            self.suffix = suffix
        }
    }
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame:CGRect) {
        super.init(frame:frame)
    }
}

// Allow alerts to be closed/renamed in a chainable manner
// Example: CASAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
open class CASAlertViewResponder {
    let alertview: CASAlertView
    
    // Initialisation and Title/Subtitle/Close functions
    public init(alertview: CASAlertView) {
        self.alertview = alertview
    }
    
    open func setTitle(title: String) {
        self.alertview.labelTitle.text = title
    }
    
    open func setSubTitle(subTitle: String?) {
        self.alertview.viewText.text = subTitle != nil ? subTitle : ""
    }
    
    open func close() {
        self.alertview.hideView()
    }
    
    open func setDismissBlock(_ dismissBlock: @escaping DismissBlock) {
        self.alertview.dismissBlock = dismissBlock
    }
}

let kCircleHeightBackground: CGFloat = 62.0
let uniqueTag: Int = Int(arc4random() % UInt32(Int32.max))
let uniqueAccessibilityIdentifier: String = "SCLAlertView"

public typealias DismissBlock = () -> Void

// The Main Class
@objc(CASAlertView) open class CASAlertView: UIViewController {
    var Version: String { return "2.05" }
    
    public struct CASAppearance {
        let kDefaultShadowOpacity: CGFloat
        let kCircleTopPosition: CGFloat
        let kCircleBackgroundTopPosition: CGFloat
        let kCircleHeight: CGFloat
        let kCircleIconHeight: CGFloat
        let kTitleHeight:CGFloat
        let kTitleMinimumScaleFactor: CGFloat
        let kWindowWidth: CGFloat
        var kWindowHeight: CGFloat
        var kTextHeight: CGFloat
        let kTextFieldHeight: CGFloat
        let kTextViewdHeight: CGFloat
        let kButtonHeight: CGFloat
        let circleBackgroundColor: UIColor
        let contentViewColor: UIColor
        let contentViewBorderColor: UIColor
        let titleColor: UIColor
        let subTitleColor: UIColor

        // KM Added
        var kTitleTop:CGFloat
        var blurEffect: UIBlurEffect.Style

        // Margins
        let margin: Margin
        public struct Margin {
            //vertical
            
            /// The spacing between title's top and window's top.
            public var titleTop: CGFloat
            /// The spacing between textView/customView's bottom and first button's top.
            public var textViewBottom: CGFloat
            /// The spacing between buttons.
            public var buttonSpacing: CGFloat
            /// The spacing between textField.
            public var textFieldSpacing: CGFloat
            /// The last button's bottom margin against alertView's bottom
            public var bottom: CGFloat
            
            //Horizontal
            /// The subView's horizontal margin.
            public var horizontal: CGFloat = 12
            
            public init(titleTop: CGFloat = 30,
                        textViewBottom: CGFloat = 12,
                        buttonSpacing: CGFloat = 10,
                        textFieldSpacing: CGFloat = 15,
                        bottom: CGFloat = 14,
                        horizontal: CGFloat = 12) {
                self.titleTop = titleTop
                self.textViewBottom = textViewBottom
                self.buttonSpacing = buttonSpacing
                self.textFieldSpacing = textFieldSpacing
                self.bottom = bottom
                self.horizontal = horizontal
            }
        }
        
        // Fonts
        let kTitleFont: UIFont
        let kTextFont: UIFont
        let kButtonFont: UIFont
        
        // UI Options
        var disableTapGesture: Bool
        var showCloseButton: Bool
        var showCircularIcon: Bool
        var shouldAutoDismiss: Bool // Set this false to 'Disable' Auto hideView when SCLButton is tapped
        var contentViewCornerRadius : CGFloat
        var fieldCornerRadius : CGFloat
        var buttonCornerRadius : CGFloat
        var dynamicAnimatorActive : Bool
        var buttonsLayout: SCLAlertButtonLayout

        // Actions
        var hideWhenBackgroundViewIsTapped: Bool
        
        public init(
            kDefaultShadowOpacity: CGFloat = 0.7,
            kCircleTopPosition: CGFloat = 0.0,
            kCircleBackgroundTopPosition: CGFloat = 6.0,
            kCircleHeight: CGFloat = 56.0,
            kCircleIconHeight: CGFloat = 36.0,
            kTitleHeight:CGFloat = 25.0,
            kWindowWidth: CGFloat = 240.0,
            kWindowHeight: CGFloat = 178.0,
            kTextHeight: CGFloat = 90.0,
            kTextFieldHeight: CGFloat = 30.0,
            kTextViewdHeight: CGFloat = 80.0,
            kButtonHeight: CGFloat = 35.0,
            kTitleFont: UIFont = UIFont.systemFont(ofSize: 20),
            kTitleMinimumScaleFactor: CGFloat = 1.0,
            kTextFont: UIFont = UIFont.systemFont(ofSize: 14),
            kButtonFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
            showCloseButton: Bool = true,
            showCircularIcon: Bool = true,
            shouldAutoDismiss: Bool = true,
            contentViewCornerRadius: CGFloat = 5.0,
            fieldCornerRadius: CGFloat = 3.0,
            buttonCornerRadius: CGFloat = 3.0,
            hideWhenBackgroundViewIsTapped: Bool = false,
            circleBackgroundColor: UIColor = UIColor.white,
            contentViewColor: UIColor = UIColorFromRGB(0xFFFFFF),
            contentViewBorderColor: UIColor = UIColorFromRGB(0xCCCCCC),
            titleColor: UIColor = UIColorFromRGB(0x4D4D4D),
            subTitleColor: UIColor = UIColorFromRGB(0x4D4D4D),
            margin: Margin = Margin(),
            dynamicAnimatorActive: Bool = false,
            disableTapGesture: Bool = false,
            buttonsLayout: SCLAlertButtonLayout = .vertical,
            kTitleTop: CGFloat = 30.0,
            blurEffect: UIBlurEffect.Style = .dark
        ) {
            self.blurEffect = blurEffect
            self.kTitleTop = kTitleTop
            self.kDefaultShadowOpacity = kDefaultShadowOpacity
            self.kCircleTopPosition = kCircleTopPosition
            self.kCircleBackgroundTopPosition = kCircleBackgroundTopPosition
            self.kCircleHeight = kCircleHeight
            self.kCircleIconHeight = kCircleIconHeight
            self.kTitleHeight = kTitleHeight
            self.kWindowWidth = kWindowWidth
            self.kWindowHeight = kWindowHeight
            self.kTextHeight = kTextHeight
            self.kTextFieldHeight = kTextFieldHeight
            self.kTextViewdHeight = kTextViewdHeight
            self.kButtonHeight = kButtonHeight
			self.circleBackgroundColor = circleBackgroundColor
            self.contentViewColor = contentViewColor
            self.contentViewBorderColor = contentViewBorderColor
            self.titleColor = titleColor
            self.subTitleColor = subTitleColor
            self.margin = margin
            self.kTitleFont = kTitleFont
            self.kTitleMinimumScaleFactor = kTitleMinimumScaleFactor
            self.kTextFont = kTextFont
            self.kButtonFont = kButtonFont
            self.disableTapGesture = disableTapGesture
            self.showCloseButton = showCloseButton
            self.showCircularIcon = showCircularIcon
            self.shouldAutoDismiss = shouldAutoDismiss
            self.contentViewCornerRadius = contentViewCornerRadius
            self.fieldCornerRadius = fieldCornerRadius
            self.buttonCornerRadius = buttonCornerRadius
            self.hideWhenBackgroundViewIsTapped = hideWhenBackgroundViewIsTapped
            self.dynamicAnimatorActive = dynamicAnimatorActive
            self.buttonsLayout = buttonsLayout
            self.kTitleTop = kTitleTop
            self.blurEffect = blurEffect
        }
        
        mutating func setkWindowHeight(_ kWindowHeight:CGFloat) {
            self.kWindowHeight = kWindowHeight
        }
        
        mutating func setkTextHeight(_ kTextHeight:CGFloat) {
            self.kTextHeight = kTextHeight
        }
    }
    
    public struct SCLTimeoutConfiguration {
        
        public typealias ActionType = () -> Void
        
        var value: TimeInterval
        let action: ActionType
        
        mutating func increaseValue(by: Double) {
            self.value = value + by
        }
        
        public init(timeoutValue: TimeInterval, timeoutAction: @escaping ActionType) {
            self.value = timeoutValue
            self.action = timeoutAction
        }
        
    }

    var appearance: CASAppearance!
    
    // UI Colour
    var viewColor = UIColor()
    
    // UI Options
    open var iconTintColor: UIColor?
    open var customSubview : UIView?
    
    // Members declaration
    var baseView = UIView.init()
    var labelTitle = UILabel.init()
    var viewText = UITextView.init()
    var contentView = UIView.init()
    var circleBG:UIView = UIView(frame:CGRect(x:0, y:0, width:kCircleHeightBackground, height:kCircleHeightBackground))
    var circleView = UIView.init()
    var circleIconView:UIView?
    var timeout: SCLTimeoutConfiguration?
    var showTimeoutTimer: Timer?
    var timeoutTimer: Timer?
    var dismissBlock :DismissBlock?
    fileprivate var inputs = [UITextField]()
    fileprivate var input = [UITextView]()
    internal var buttons = [CASButton]()
    fileprivate var selfReference: CASAlertView?
    
    public init(appearance: CASAppearance) {
        self.appearance = appearance
        super.init(nibName:nil, bundle:nil)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    required public init() {
        appearance = CASAppearance()
        super.init(nibName:nil, bundle:nil)
        setup()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        if appearance == nil {
            appearance = CASAppearance()
        }
        
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    fileprivate func setup() {
        // Set up main view
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:appearance.kDefaultShadowOpacity)
        view.addSubview(baseView)
        // Base View
        baseView.frame = view.frame
        baseView.addSubview(contentView)
        // Content View
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(labelTitle)
        contentView.addSubview(viewText)
        // Circle View
        circleBG.backgroundColor = appearance.circleBackgroundColor
        circleBG.layer.cornerRadius = circleBG.frame.size.height / 2
        baseView.addSubview(circleBG)
        circleBG.addSubview(circleView)
        let x = (kCircleHeightBackground - appearance.kCircleHeight) / 2
        circleView.frame = CGRect(x:x, y:x+appearance.kCircleTopPosition, width:appearance.kCircleHeight, height:appearance.kCircleHeight)
        circleView.layer.cornerRadius = circleView.frame.size.height / 2
        // Title
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.font = appearance.kTitleFont
        if(appearance.kTitleMinimumScaleFactor < 1){
            labelTitle.minimumScaleFactor = appearance.kTitleMinimumScaleFactor
            labelTitle.adjustsFontSizeToFitWidth = true
        }
        labelTitle.frame = CGRect(x:appearance.margin.horizontal, y:appearance.margin.titleTop, width: subViewsWidth, height:appearance.kTitleHeight)
        // View text
        viewText.isEditable = false
        viewText.textAlignment = .center
        viewText.textContainerInset = UIEdgeInsets.zero
        viewText.textContainer.lineFragmentPadding = 0;
        viewText.font = self.appearance.kTextFont
        // Colours
        contentView.backgroundColor = appearance.contentViewColor
        viewText.backgroundColor = appearance.contentViewColor
        labelTitle.textColor = appearance.titleColor
        viewText.textColor = appearance.subTitleColor
        contentView.layer.borderColor = appearance.contentViewBorderColor.cgColor
        //Gesture Recognizer for tapping outside the textinput
        if appearance.disableTapGesture == false {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CASAlertView.tapped(_:)))
            tapGesture.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let rv:UIWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        let sz = rv.frame.size
        
        // Set background frame
        view.frame.size = sz
        
        let defaultTopOffset: CGFloat = 32
        
        // get actual height of title text
        var titleActualHeight: CGFloat = 0
        if let title = labelTitle.text {
            titleActualHeight = title.heightWithConstrainedWidth(width: subViewsWidth, font: labelTitle.font) + 10
            // get the larger height for the title text
            titleActualHeight = (titleActualHeight > appearance.kTitleHeight ? titleActualHeight : appearance.kTitleHeight)
        }
        
        // computing the right size to use for the textView
        let maxHeight = sz.height - 100 // max overall height
        var consumedHeight = CGFloat(0)
        consumedHeight += (titleActualHeight > 0 ? appearance.margin.titleTop + titleActualHeight : defaultTopOffset)
        consumedHeight += appearance.margin.bottom
        
        let buttonMargin = appearance.margin.buttonSpacing
        let textFieldMargin = appearance.margin.textFieldSpacing
        if appearance.buttonsLayout == .vertical {
            consumedHeight += appearance.kButtonHeight * CGFloat(buttons.count)
            consumedHeight += buttonMargin * (CGFloat(buttons.count) - 1)
        } else {
            consumedHeight += appearance.kButtonHeight
        }
        consumedHeight += (appearance.kTextFieldHeight + textFieldMargin) * CGFloat(inputs.count)
        consumedHeight += appearance.kTextViewdHeight * CGFloat(input.count)
        let maxViewTextHeight = maxHeight - consumedHeight
        let viewTextWidth = subViewsWidth
        var viewTextHeight = appearance.kTextHeight
        
        // Check if there is a custom subview and add it over the textview
        if let customSubview = customSubview {
            viewTextHeight = min(customSubview.frame.height, maxViewTextHeight)
            viewText.text = ""
            viewText.addSubview(customSubview)
        } else if viewText.text.isEmpty {
            viewTextHeight = 0
        } else {
            // computing the right size to use for the textView
            let suggestedViewTextSize = viewText.sizeThatFits(CGSize(width: viewTextWidth, height: CGFloat.greatestFiniteMagnitude))
            viewTextHeight = min(suggestedViewTextSize.height, maxViewTextHeight)
            
            // scroll management
            if (suggestedViewTextSize.height > maxViewTextHeight) {
                viewText.isScrollEnabled = true
            } else {
                viewText.isScrollEnabled = false
            }
        }
        
        var windowHeight = consumedHeight + viewTextHeight
        windowHeight += viewText.text.isEmpty ? 0 : appearance.margin.textViewBottom // only viewText.text is not empty should have margin.
        
        // Set frames
        var x = (sz.width - appearance.kWindowWidth) / 2
        var y = (sz.height - windowHeight - (appearance.kCircleHeight / 8)) / 2
        contentView.frame = CGRect(x:x, y:y, width:appearance.kWindowWidth, height:windowHeight)
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        y -= kCircleHeightBackground * 0.6
        x = (sz.width - kCircleHeightBackground) / 2
        circleBG.frame = CGRect(x:x, y:y+appearance.kCircleBackgroundTopPosition, width:kCircleHeightBackground, height:kCircleHeightBackground)
        
        //adjust Title frame based on circularIcon show/hide flag
        //        let titleOffset : CGFloat = appearance.showCircularIcon ? 0.0 : -12.0
        let titleOffset: CGFloat = 0
        labelTitle.frame = labelTitle.frame.offsetBy(dx: 0, dy: titleOffset)
        
        // Subtitle
        y = titleActualHeight > 0 ? appearance.margin.titleTop + titleActualHeight + titleOffset : defaultTopOffset
        viewText.frame = CGRect(x:appearance.margin.horizontal, y:y, width: viewTextWidth, height:viewTextHeight)
        // Text fields
        y += viewTextHeight
        y += viewText.text.isEmpty ? 0 : appearance.margin.textViewBottom // only viewText.text is not empty should have margin.
        
        for txt in inputs {
            txt.frame = CGRect(x:appearance.margin.horizontal, y:y, width:subViewsWidth, height:appearance.kTextFieldHeight)
            txt.layer.cornerRadius = appearance.fieldCornerRadius
            y += appearance.kTextFieldHeight + textFieldMargin
        }
        for txt in input {
            txt.frame = CGRect(x:appearance.margin.horizontal, y:y, width:subViewsWidth, height:appearance.kTextViewdHeight - appearance.margin.textViewBottom)
            //txt.layer.cornerRadius = fieldCornerRadius
            y += appearance.kTextViewdHeight
        }
        // Buttons
        var buttonX = appearance.margin.horizontal
        switch appearance.buttonsLayout {
        case .vertical:
            for btn in buttons {
                btn.frame = CGRect(x:buttonX, y:y, width:subViewsWidth, height:appearance.kButtonHeight)
                btn.layer.cornerRadius = appearance.buttonCornerRadius
                y += appearance.kButtonHeight + buttonMargin
            }
        case .horizontal:
            let numberOfButton = CGFloat(buttons.count)
            let buttonsSpace = numberOfButton >= 1 ? CGFloat(10) * (numberOfButton - 1) : 0
            let widthEachButton = (subViewsWidth - buttonsSpace) / numberOfButton
            for btn in buttons {
                btn.frame = CGRect(x:buttonX, y:y, width: widthEachButton, height:appearance.kButtonHeight)
                btn.layer.cornerRadius = appearance.buttonCornerRadius
                buttonX += widthEachButton
                buttonX += buttonsSpace
            }
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(CASAlertView.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CASAlertView.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: Notification.Name("CAS_Alert_WillDisappear"),object: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override open func touchesEnded(_ touches:Set<UITouch>, with event:UIEvent?) {
        if event?.touches(for: view)?.count > 0 {
            view.endEditing(true)
        }
    }

    @discardableResult open func addTextField(
        placeholder title:String?=nil,
        text:String?=nil,
        keyboard:UIKeyboardType? = .alphabet,
        isSecure:Bool?=false,
        setFocus:Bool?=false
    )->UITextField {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kTextFieldHeight)
        // Add text field
        let txt = UITextField()
        txt.borderStyle = UITextField.BorderStyle.roundedRect
        txt.font = appearance.kTextFont
        txt.autocapitalizationType = UITextAutocapitalizationType.words
        txt.clearButtonMode = UITextField.ViewMode.whileEditing
        
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        
        if title != nil {
            txt.placeholder = title!
        }
        
        if text != nil {
            txt.text = text!
        }
        
        if setFocus!.isTrue {
            sharedFunc.THREAD().doAfter(delay: 0.1, perform: {
                txt.becomeFirstResponder()
            })
        }

        contentView.addSubview(txt)
        inputs.append(txt)
        return txt
    }
    
    open func addTextView()->UITextView {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kTextViewdHeight)
        // Add text view
        let txt = UITextView()
        // No placeholder with UITextView but you can use KMPlaceholderTextView library
        txt.font = appearance.kTextFont
        //txt.autocapitalizationType = UITextAutocapitalizationType.Words
        //txt.clearButtonMode = UITextFieldViewMode.WhileEditing
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        contentView.addSubview(txt)
        input.append(txt)
        return txt
    }

    @discardableResult
    open func addButton(title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showTimeout:CASButton.ShowTimeoutConfiguration? = nil, action:@escaping ()->Void)->CASButton {
        let btn = addButton(title: title, backgroundColor: backgroundColor, textColor: textColor, showTimeout: showTimeout)
        btn.actionType = SCLActionType.closure
        btn.action = action
        btn.addTarget(self, action:#selector(CASAlertView.buttonTapped(_:)), for:.touchUpInside)
        btn.addTarget(self, action:#selector(CASAlertView.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
        btn.addTarget(self, action:#selector(CASAlertView.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    }
    
    @discardableResult
    open func addButton(title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showTimeout:CASButton.ShowTimeoutConfiguration? = nil, target:AnyObject, selector:Selector)->CASButton {
        let btn = addButton(title: title, backgroundColor: backgroundColor, textColor: textColor, showTimeout: showTimeout)
            btn.actionType = SCLActionType.selector
            btn.target = target
            btn.selector = selector
            btn.addTarget(self, action:#selector(CASAlertView.buttonTapped(_:)), for:.touchUpInside)
            btn.addTarget(self, action:#selector(CASAlertView.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
            btn.addTarget(self, action:#selector(CASAlertView.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    }
    
    @discardableResult
    fileprivate func addButton(title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showTimeout:CASButton.ShowTimeoutConfiguration? = nil)->CASButton {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kButtonHeight)
        
        // Add button
        let btn = CASButton()
        btn.layer.masksToBounds = true
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = appearance.kButtonFont
        btn.customBackgroundColor = backgroundColor
        btn.customTextColor = textColor
        btn.initialTitle = title
        btn.showTimeout = showTimeout
        contentView.addSubview(btn)
        buttons.append(btn)
        return btn
    }

    @objc func buttonTapped(_ btn:CASButton) {
        if btn.actionType == SCLActionType.closure {
            btn.action()
        } else if btn.actionType == SCLActionType.selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to:btn.target, for:nil)
        } else {
            print("Unknow action type for button")
        }
        
        if(self.view.alpha != 0.0 && appearance.shouldAutoDismiss){ hideView() }
    }

    @objc func buttonTapDown(_ btn:CASButton) {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        let pressBrightnessFactor = 0.85
        btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = brightness * CGFloat(pressBrightnessFactor)
        btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    @objc func buttonRelease(_ btn:CASButton) {
        btn.backgroundColor = btn.customBackgroundColor ?? viewColor
    }

    var tmpContentViewFrameOrigin: CGPoint?
    var tmpCircleViewFrameOrigin: CGPoint?
    var keyboardHasBeenShown:Bool = false
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardHasBeenShown = true
        
        guard let userInfo = (notification as NSNotification).userInfo else {return}
        guard let endKeyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY else {return}
        
        if tmpContentViewFrameOrigin == nil {
            tmpContentViewFrameOrigin = self.contentView.frame.origin
        }
        
        if tmpCircleViewFrameOrigin == nil {
            tmpCircleViewFrameOrigin = self.circleBG.frame.origin
        }
        
        var newContentViewFrameY = self.contentView.frame.maxY - endKeyBoardFrame
        if newContentViewFrameY < 0 {
            newContentViewFrameY = 0
        }
        
        let newBallViewFrameY = self.circleBG.frame.origin.y - newContentViewFrameY
        self.contentView.frame.origin.y -= newContentViewFrameY
        self.circleBG.frame.origin.y = newBallViewFrameY
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if(keyboardHasBeenShown){//This could happen on the simulator (keyboard will be hidden)
            if(self.tmpContentViewFrameOrigin != nil){
                self.contentView.frame.origin.y = self.tmpContentViewFrameOrigin!.y
                self.tmpContentViewFrameOrigin = nil
            }
            if(self.tmpCircleViewFrameOrigin != nil){
                self.circleBG.frame.origin.y = self.tmpCircleViewFrameOrigin!.y
                self.tmpCircleViewFrameOrigin = nil
            }
            
            keyboardHasBeenShown = false
        }
    }
    
    //Dismiss keyboard when tapped outside textfield & close SCLAlertView when hideWhenBackgroundViewIsTapped
    @objc func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        if let tappedView = gestureRecognizer.view , tappedView.hitTest(gestureRecognizer.location(in: tappedView), with: nil) == baseView && appearance.hideWhenBackgroundViewIsTapped {
            
            hideView()
        }
    }
    
    // showCustom(view, title, subTitle, UIColor, UIImage)
    @discardableResult open func showCustom(
        title: String,
        subTitle: String,
        color: UIColor,
        icon: UIImage?=nil,
        closeButtonTitle: String?=nil,
        timeout:SCLTimeoutConfiguration?=nil,
        colorStyle: UInt?=CASAlertViewStyle.success.defaultColorInt,
        colorTextButton: UInt?=0xFFFFFF,
        animationStyle: SCLAnimationStyle? = .topToBottom
    ) -> CASAlertViewResponder {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var colorAsUInt32 : UInt32 = 0
        colorAsUInt32 += UInt32(red * 255.0) << 16
        colorAsUInt32 += UInt32(green * 255.0) << 8
        colorAsUInt32 += UInt32(blue * 255.0)
        
        let colorAsUInt = UInt(colorAsUInt32)
        
        return showTitle(title: title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .success, colorStyle: colorAsUInt, colorTextButton: colorTextButton, circleIconImage: icon, animationStyle: animationStyle!)
    }
    
    // showSuccess(view, title, subTitle)
    @discardableResult
    open func showSuccess(_ title: String, subTitle: String, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt=CASAlertViewStyle.success.defaultColorInt, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .success, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
    // showError(view, title, subTitle)
    @discardableResult
    open func showError(_ title: String, subTitle: String, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt=CASAlertViewStyle.error.defaultColorInt, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .error, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
    // showNotice(view, title, subTitle)
    @discardableResult
    open func showNotice(_ title: String, subTitle: String, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt=CASAlertViewStyle.notice.defaultColorInt, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .notice, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
    // showWarning(view, title, subTitle)
    @discardableResult
    open func showWarning(_ title: String, subTitle: String, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt=CASAlertViewStyle.warning.defaultColorInt, colorTextButton: UInt=0x000000, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .warning, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }

    // showInfo(view, title, subTitle)
    @discardableResult
    open func showInfo(_ title: String, subTitle: String, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt=CASAlertViewStyle.info.defaultColorInt, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .info, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
    // showWait(view, title, subTitle)
    @discardableResult
    open func showWait(_ title: String, subTitle: String, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt?=CASAlertViewStyle.wait.defaultColorInt, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .wait, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }

    // showEdit(view, title, subTitle)
    @discardableResult
    open func showEdit(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=CASAlertViewStyle.edit.defaultColorInt, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .edit, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
    // showTitle(view, title, subTitle, style)
    @discardableResult
    open func showTitle(_ title: String, subTitle: String, style: CASAlertViewStyle, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UInt?=0x000000, colorTextButton: UInt=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> CASAlertViewResponder {
        return showTitle(title:title, subTitle: subTitle, timeout:timeout, completeText:closeButtonTitle, style: style, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
    // showTitle(view, title, subTitle, timeout, style)
    @discardableResult public func showTitle(
        title: String,
        subTitle: String,
        timeout: SCLTimeoutConfiguration?,
        completeText:String?,
        style: CASAlertViewStyle,
        colorStyle: UInt?=0x000000,
        colorTextButton: UInt?=0xFFFFFF,
        circleIconImage: UIImage? = nil,
        animationStyle: SCLAnimationStyle = .topToBottom
    ) -> CASAlertViewResponder {
        selfReference = self
        view.alpha = 0
        view.tag = uniqueTag
        view.accessibilityIdentifier = uniqueAccessibilityIdentifier
        let rv:UIWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
            rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds

        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: appearance.blurEffect)
        
        // Alert color/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        let colorInt = colorStyle ?? style.defaultColorInt
        viewColor = UIColorFromRGB(colorInt)

        // Icon style
        switch style {
            case .success: iconImage = checkCircleIconImage(circleIconImage, defaultImage: CASAlertViewStyleKit.imageOfCheckmark)
            case .error: iconImage = checkCircleIconImage(circleIconImage, defaultImage: CASAlertViewStyleKit.imageOfCross)
            case .notice: iconImage = checkCircleIconImage(circleIconImage, defaultImage:CASAlertViewStyleKit.imageOfNotice)
            case .warning: iconImage = checkCircleIconImage(circleIconImage, defaultImage:CASAlertViewStyleKit.imageOfWarning)
            case .info: iconImage = checkCircleIconImage(circleIconImage, defaultImage:CASAlertViewStyleKit.imageOfInfo)
            case .edit: iconImage = checkCircleIconImage(circleIconImage, defaultImage:CASAlertViewStyleKit.imageOfEdit)
            case .wait: iconImage = #imageLiteral(resourceName: "CAS_Wait").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            // CAS Custom styles
            case .notAvail: iconImage = #imageLiteral(resourceName: "CAS_NotAvailable").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            case .iap: iconImage = #imageLiteral(resourceName: "CAS_IAP").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            case .confirm: iconImage = #imageLiteral(resourceName: "CAS_Confirm").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            case .construction: iconImage = #imageLiteral(resourceName: "CAS_Construction").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            case .serverError: iconImage = #imageLiteral(resourceName: "CAS_Server").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
        }
        
        // Title
        if title.isNotEmpty {
            self.labelTitle.text = title
            let actualHeight = title.heightWithConstrainedWidth(width: subViewsWidth, font: self.labelTitle.font)
            self.labelTitle.frame = CGRect(x:appearance.margin.horizontal, y:appearance.margin.titleTop, width: subViewsWidth, height:actualHeight)
//            self.labelTitle.adjustsFontSizeToFitWidth = true
//            self.labelTitle.minimumScaleFactor = 0.33
        }
        
        // Subtitle
        if subTitle.isNotEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedString.Key.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: subViewsWidth, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < appearance.kTextHeight {
                appearance.kWindowHeight -= (appearance.kTextHeight - ht)
                appearance.setkTextHeight(ht)
            }
        }
        
        // Done button
        if appearance.showCloseButton {
            _ = addButton(
                title: completeText ?? "Done".localizedCAS(),
                target: self,
                selector: #selector(CASAlertView.hideView)
            )
        }
        
        //hidden/show circular view based on the ui option
        circleView.isHidden = !appearance.showCircularIcon
        circleBG.isHidden = !appearance.showCircularIcon
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        
        // Spinner / icon
        if style == .wait {
            var indicator = UIActivityIndicatorView.init() //KM: 2020_02_04 - Deprecation fix for .whiteLarge
            if #available(iOS 13.0, *) {
                indicator = UIActivityIndicatorView(style: .large)
            } else {
                indicator = UIActivityIndicatorView(style: .whiteLarge)
            }

            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            if let iconTintColor = iconTintColor {
                circleIconView = UIImageView(image: iconImage!.withRenderingMode(.alwaysTemplate))
                circleIconView?.tintColor = iconTintColor
            }
            else {
                circleIconView = UIImageView(image: iconImage!)
            }
        }
        circleView.addSubview(circleIconView!)
        let x = (appearance.kCircleHeight - appearance.kCircleIconHeight) / 2
        circleIconView!.frame = CGRect( x: x, y: x, width: appearance.kCircleIconHeight, height: appearance.kCircleIconHeight)
        circleIconView?.layer.masksToBounds = true
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        
        for txt in input {
            txt.layer.borderColor = viewColor.cgColor
        }
        
        for btn in buttons {
            if let customBackgroundColor = btn.customBackgroundColor {
                // Custom BackgroundColor set
                btn.backgroundColor = customBackgroundColor
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.backgroundColor = viewColor
            }
            
            if let customTextColor = btn.customTextColor {
                // Custom TextColor set
                btn.setTitleColor(customTextColor, for: .normal)
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.setTitleColor(UIColorFromRGB(colorTextButton ?? 0xFFFFFF), for: .normal)
            }
        }
        
        // Adding timeout
        if let timeout = timeout {
            var indicator = UIActivityIndicatorView.init()
                if #available(iOS 13.0, *) {
                    indicator = UIActivityIndicatorView(style: .large)
                }else{
                    indicator = UIActivityIndicatorView(style: .whiteLarge)
                }

                indicator.backgroundColor = .clear
                indicator.isOpaque = false
                indicator.color = iconTintColor
                indicator.startAnimating()
            circleIconView?.addSubview(indicator)

            self.timeout = timeout
            timeoutTimer?.invalidate()
            timeoutTimer = Timer.scheduledTimer(timeInterval: timeout.value, target: self, selector: #selector(CASAlertView.hideViewTimeout), userInfo: nil, repeats: false)
            showTimeoutTimer?.invalidate()
            showTimeoutTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CASAlertView.updateShowTimeout), userInfo: nil, repeats: true)
        }
        
        // Animate in the alert view
        self.showAnimation(animationStyle)
       
        // Chainable objects
        return CASAlertViewResponder(alertview: self)
    }
    
    // Show animation in the alert view
    fileprivate func showAnimation(_ animationStyle: SCLAnimationStyle = .topToBottom, animationStartOffset: CGFloat = -400.0, boundingAnimationOffset: CGFloat = 15.0, animationDuration: TimeInterval = 0.2) {
        
        let rv:UIWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        var animationStartOrigin = self.baseView.frame.origin
        var animationCenter : CGPoint = rv.center
        
        switch animationStyle {
            
        case .noAnimation:
            self.view.alpha = 1.0
            return;
            
        case .topToBottom:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y + animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y + boundingAnimationOffset)
            
        case .bottomToTop:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y - animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y - boundingAnimationOffset)
            
        case .leftToRight:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x + animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x + boundingAnimationOffset, y: animationCenter.y)
            
        case .rightToLeft:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x - animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x - boundingAnimationOffset, y: animationCenter.y)
        }
        
        self.baseView.frame.origin = animationStartOrigin
        
        if self.appearance.dynamicAnimatorActive {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.alpha = 1.0
            })
            self.animate(item: self.baseView, center: rv.center)
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.alpha = 1.0
                self.baseView.center = animationCenter
            }, completion: { finished in
                UIView.animate(withDuration: animationDuration, animations: {
                    self.view.alpha = 1.0
                    self.baseView.center = rv.center
                })
            })
        }
    }
    
    // DynamicAnimator function
    var animator : UIDynamicAnimator?
    var snapBehavior : UISnapBehavior?

    fileprivate func animate(item : UIView , center: CGPoint) {
        if let snapBehavior = self.snapBehavior {
            self.animator?.removeBehavior(snapBehavior)
        }
        
        self.animator = UIDynamicAnimator.init(referenceView: self.view)
        let tempSnapBehavior  =  UISnapBehavior.init(item: item, snapTo: center)
        self.animator?.addBehavior(tempSnapBehavior)
        self.snapBehavior? = tempSnapBehavior
    }

    @objc open func updateShowTimeout() {
        guard let timeout = self.timeout else {
            return
        }
        
        self.timeout?.value = timeout.value.advanced(by: -1)
        
        for btn in buttons {
            guard let showTimeout = btn.showTimeout else {
                continue
            }
            
            let timeoutStr: String = showTimeout.prefix + String(Int(timeout.value)) + showTimeout.suffix
            let txt = String(btn.initialTitle) + " " + timeoutStr
            btn.setTitle(txt, for: .normal)
            
        }
        
    }

    // Close CASAlertView
    @objc open func hideView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { finished in
            
            // Stop timeoutTimer so alertView does not attempt to hide itself and fire it's dimiss block a second time when close button is tapped
            self.timeoutTimer?.invalidate()
            
            // Stop showTimeoutTimer
            self.showTimeoutTimer?.invalidate()
            
            if let dismissBlock = self.dismissBlock {
                // Call completion handler when the alert is dismissed
                dismissBlock()
            }
            
            // This is necessary for SCLAlertView to be de-initialized, preventing a strong reference cycle with the viewcontroller calling SCLAlertView.
            for button in self.buttons {
                button.action = nil
                button.target = nil
                button.selector = nil
            }
            
            self.view.removeFromSuperview()
            self.selfReference = nil
        })
    }
    
    @objc open func hideViewTimeout() {
        self.timeout?.action()
        self.hideView()
    }

    func checkCircleIconImage(_ circleIconImage: UIImage?, defaultImage: UIImage) -> UIImage {
        if let image = circleIconImage {
            return image
        } else {
            return defaultImage
        }
    }
    
    //Return true if a CASAlertView is already being shown, false otherwise
    open func isShowing() -> Bool {
        if let subviews = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first)?.subviews {
            for view in subviews {
                if view.tag == uniqueTag && view.accessibilityIdentifier == uniqueAccessibilityIdentifier {
                    return true
                }
            }
        }
        return false
    }
}

// Helper function to convert from RGB to UIColor
public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// ------------------------------------
// Icon drawing
// Code generated by PaintCode
// ------------------------------------

class CASAlertViewStyleKit : NSObject {
    // Cache
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var checkmarkTargets: [AnyObject]?
        static var imageOfCross: UIImage?
        static var crossTargets: [AnyObject]?
        static var imageOfNotice: UIImage?
        static var noticeTargets: [AnyObject]?
        static var imageOfWarning: UIImage?
        static var warningTargets: [AnyObject]?
        static var imageOfInfo: UIImage?
        static var infoTargets: [AnyObject]?
        static var imageOfEdit: UIImage?
        static var editTargets: [AnyObject]?
        static var imageOfQuestion: UIImage?
        static var questionTargets: [AnyObject]?
    }
    
    // Drawing Methods
    class func drawCheckmark() {
        // Checkmark Shape Drawing
        let checkmarkShapePath = UIBezierPath()
        checkmarkShapePath.move(to: CGPoint(x: 73.25, y: 14.05))
        checkmarkShapePath.addCurve(to: CGPoint(x: 64.51, y: 13.86), controlPoint1: CGPoint(x: 70.98, y: 11.44), controlPoint2: CGPoint(x: 66.78, y: 11.26))
        checkmarkShapePath.addLine(to: CGPoint(x: 27.46, y: 52))
        checkmarkShapePath.addLine(to: CGPoint(x: 15.75, y: 39.54))
        checkmarkShapePath.addCurve(to: CGPoint(x: 6.84, y: 39.54), controlPoint1: CGPoint(x: 13.48, y: 36.93), controlPoint2: CGPoint(x: 9.28, y: 36.93))
        checkmarkShapePath.addCurve(to: CGPoint(x: 6.84, y: 49.02), controlPoint1: CGPoint(x: 4.39, y: 42.14), controlPoint2: CGPoint(x: 4.39, y: 46.42))
        checkmarkShapePath.addLine(to: CGPoint(x: 22.91, y: 66.14))
        checkmarkShapePath.addCurve(to: CGPoint(x: 27.28, y: 68), controlPoint1: CGPoint(x: 24.14, y: 67.44), controlPoint2: CGPoint(x: 25.71, y: 68))
        checkmarkShapePath.addCurve(to: CGPoint(x: 31.65, y: 66.14), controlPoint1: CGPoint(x: 28.86, y: 68), controlPoint2: CGPoint(x: 30.43, y: 67.26))
        checkmarkShapePath.addLine(to: CGPoint(x: 73.08, y: 23.35))
        checkmarkShapePath.addCurve(to: CGPoint(x: 73.25, y: 14.05), controlPoint1: CGPoint(x: 75.52, y: 20.75), controlPoint2: CGPoint(x: 75.7, y: 16.65))
        checkmarkShapePath.close()
        checkmarkShapePath.miterLimit = 4;
        
        UIColor.white.setFill()
        checkmarkShapePath.fill()
    }
    
    class func drawCross() {
        // Cross Shape Drawing
        let crossShapePath = UIBezierPath()
        crossShapePath.move(to: CGPoint(x: 10, y: 70))
        crossShapePath.addLine(to: CGPoint(x: 70, y: 10))
        crossShapePath.move(to: CGPoint(x: 10, y: 10))
        crossShapePath.addLine(to: CGPoint(x: 70, y: 70))
        crossShapePath.lineCapStyle = CGLineCap.round;
        crossShapePath.lineJoinStyle = CGLineJoin.round;
        UIColor.white.setStroke()
        crossShapePath.lineWidth = 14
        crossShapePath.stroke()
    }
    
    class func drawNotice() {
        // Notice Shape Drawing
        let noticeShapePath = UIBezierPath()
        noticeShapePath.move(to: CGPoint(x: 72, y: 48.54))
        noticeShapePath.addLine(to: CGPoint(x: 72, y: 39.9))
        noticeShapePath.addCurve(to: CGPoint(x: 66.38, y: 34.01), controlPoint1: CGPoint(x: 72, y: 36.76), controlPoint2: CGPoint(x: 69.48, y: 34.01))
        noticeShapePath.addCurve(to: CGPoint(x: 61.53, y: 35.97), controlPoint1: CGPoint(x: 64.82, y: 34.01), controlPoint2: CGPoint(x: 62.69, y: 34.8))
        noticeShapePath.addCurve(to: CGPoint(x: 60.36, y: 35.78), controlPoint1: CGPoint(x: 61.33, y: 35.97), controlPoint2: CGPoint(x: 62.3, y: 35.78))
        noticeShapePath.addLine(to: CGPoint(x: 60.36, y: 33.22))
        noticeShapePath.addCurve(to: CGPoint(x: 54.16, y: 26.16), controlPoint1: CGPoint(x: 60.36, y: 29.3), controlPoint2: CGPoint(x: 57.65, y: 26.16))
        noticeShapePath.addCurve(to: CGPoint(x: 48.73, y: 29.89), controlPoint1: CGPoint(x: 51.64, y: 26.16), controlPoint2: CGPoint(x: 50.67, y: 27.73))
        noticeShapePath.addLine(to: CGPoint(x: 48.73, y: 28.71))
        noticeShapePath.addCurve(to: CGPoint(x: 43.49, y: 21.64), controlPoint1: CGPoint(x: 48.73, y: 24.78), controlPoint2: CGPoint(x: 46.98, y: 21.64))
        noticeShapePath.addCurve(to: CGPoint(x: 39.03, y: 25.37), controlPoint1: CGPoint(x: 40.97, y: 21.64), controlPoint2: CGPoint(x: 39.03, y: 23.01))
        noticeShapePath.addLine(to: CGPoint(x: 39.03, y: 9.07))
        noticeShapePath.addCurve(to: CGPoint(x: 32.24, y: 2), controlPoint1: CGPoint(x: 39.03, y: 5.14), controlPoint2: CGPoint(x: 35.73, y: 2))
        noticeShapePath.addCurve(to: CGPoint(x: 25.45, y: 9.07), controlPoint1: CGPoint(x: 28.56, y: 2), controlPoint2: CGPoint(x: 25.45, y: 5.14))
        noticeShapePath.addLine(to: CGPoint(x: 25.45, y: 41.47))
        noticeShapePath.addCurve(to: CGPoint(x: 24.29, y: 43.44), controlPoint1: CGPoint(x: 25.45, y: 42.45), controlPoint2: CGPoint(x: 24.68, y: 43.04))
        noticeShapePath.addCurve(to: CGPoint(x: 9.55, y: 43.04), controlPoint1: CGPoint(x: 16.73, y: 40.88), controlPoint2: CGPoint(x: 11.88, y: 40.69))
        noticeShapePath.addCurve(to: CGPoint(x: 8, y: 46.58), controlPoint1: CGPoint(x: 8.58, y: 43.83), controlPoint2: CGPoint(x: 8, y: 45.2))
        noticeShapePath.addCurve(to: CGPoint(x: 14.4, y: 55.81), controlPoint1: CGPoint(x: 8.19, y: 50.31), controlPoint2: CGPoint(x: 12.07, y: 53.84))
        noticeShapePath.addLine(to: CGPoint(x: 27.2, y: 69.56))
        noticeShapePath.addCurve(to: CGPoint(x: 42.91, y: 77.8), controlPoint1: CGPoint(x: 30.5, y: 74.47), controlPoint2: CGPoint(x: 35.73, y: 77.21))
        noticeShapePath.addCurve(to: CGPoint(x: 43.88, y: 77.8), controlPoint1: CGPoint(x: 43.3, y: 77.8), controlPoint2: CGPoint(x: 43.68, y: 77.8))
        noticeShapePath.addCurve(to: CGPoint(x: 47.18, y: 78), controlPoint1: CGPoint(x: 45.04, y: 77.8), controlPoint2: CGPoint(x: 46.01, y: 78))
        noticeShapePath.addLine(to: CGPoint(x: 48.34, y: 78))
        noticeShapePath.addLine(to: CGPoint(x: 48.34, y: 78))
        noticeShapePath.addCurve(to: CGPoint(x: 71.61, y: 52.08), controlPoint1: CGPoint(x: 56.48, y: 78), controlPoint2: CGPoint(x: 69.87, y: 75.05))
        noticeShapePath.addCurve(to: CGPoint(x: 72, y: 48.54), controlPoint1: CGPoint(x: 71.81, y: 51.29), controlPoint2: CGPoint(x: 72, y: 49.72))
        noticeShapePath.close()
        noticeShapePath.miterLimit = 4;
        
        UIColor.white.setFill()
        noticeShapePath.fill()
    }
    
    class func drawWarning() {
        // Color Declarations
        let greyColor = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1.000)
        
        // Warning Group
        // Warning Circle Drawing
        let warningCirclePath = UIBezierPath()
        warningCirclePath.move(to: CGPoint(x: 40.94, y: 63.39))
        warningCirclePath.addCurve(to: CGPoint(x: 36.03, y: 65.55), controlPoint1: CGPoint(x: 39.06, y: 63.39), controlPoint2: CGPoint(x: 37.36, y: 64.18))
        warningCirclePath.addCurve(to: CGPoint(x: 34.14, y: 70.45), controlPoint1: CGPoint(x: 34.9, y: 66.92), controlPoint2: CGPoint(x: 34.14, y: 68.49))
        warningCirclePath.addCurve(to: CGPoint(x: 36.22, y: 75.54), controlPoint1: CGPoint(x: 34.14, y: 72.41), controlPoint2: CGPoint(x: 34.9, y: 74.17))
        warningCirclePath.addCurve(to: CGPoint(x: 40.94, y: 77.5), controlPoint1: CGPoint(x: 37.54, y: 76.91), controlPoint2: CGPoint(x: 39.06, y: 77.5))
        warningCirclePath.addCurve(to: CGPoint(x: 45.86, y: 75.35), controlPoint1: CGPoint(x: 42.83, y: 77.5), controlPoint2: CGPoint(x: 44.53, y: 76.72))
        warningCirclePath.addCurve(to: CGPoint(x: 47.93, y: 70.45), controlPoint1: CGPoint(x: 47.18, y: 74.17), controlPoint2: CGPoint(x: 47.93, y: 72.41))
        warningCirclePath.addCurve(to: CGPoint(x: 45.86, y: 65.35), controlPoint1: CGPoint(x: 47.93, y: 68.49), controlPoint2: CGPoint(x: 47.18, y: 66.72))
        warningCirclePath.addCurve(to: CGPoint(x: 40.94, y: 63.39), controlPoint1: CGPoint(x: 44.53, y: 64.18), controlPoint2: CGPoint(x: 42.83, y: 63.39))
        warningCirclePath.close()
        warningCirclePath.miterLimit = 4;
        
        greyColor.setFill()
        warningCirclePath.fill()
        
        
        // Warning Shape Drawing
        let warningShapePath = UIBezierPath()
        warningShapePath.move(to: CGPoint(x: 46.23, y: 4.26))
        warningShapePath.addCurve(to: CGPoint(x: 40.94, y: 2.5), controlPoint1: CGPoint(x: 44.91, y: 3.09), controlPoint2: CGPoint(x: 43.02, y: 2.5))
        warningShapePath.addCurve(to: CGPoint(x: 34.71, y: 4.26), controlPoint1: CGPoint(x: 38.68, y: 2.5), controlPoint2: CGPoint(x: 36.03, y: 3.09))
        warningShapePath.addCurve(to: CGPoint(x: 31.5, y: 8.77), controlPoint1: CGPoint(x: 33.01, y: 5.44), controlPoint2: CGPoint(x: 31.5, y: 7.01))
        warningShapePath.addLine(to: CGPoint(x: 31.5, y: 19.36))
        warningShapePath.addLine(to: CGPoint(x: 34.71, y: 54.44))
        warningShapePath.addCurve(to: CGPoint(x: 40.38, y: 58.16), controlPoint1: CGPoint(x: 34.9, y: 56.2), controlPoint2: CGPoint(x: 36.41, y: 58.16))
        warningShapePath.addCurve(to: CGPoint(x: 45.67, y: 54.44), controlPoint1: CGPoint(x: 44.34, y: 58.16), controlPoint2: CGPoint(x: 45.67, y: 56.01))
        warningShapePath.addLine(to: CGPoint(x: 48.5, y: 19.36))
        warningShapePath.addLine(to: CGPoint(x: 48.5, y: 8.77))
        warningShapePath.addCurve(to: CGPoint(x: 46.23, y: 4.26), controlPoint1: CGPoint(x: 48.5, y: 7.01), controlPoint2: CGPoint(x: 47.74, y: 5.44))
        warningShapePath.close()
        warningShapePath.miterLimit = 4;
        
        greyColor.setFill()
        warningShapePath.fill()
    }
    
    class func drawInfo() {
        // Color Declarations
        let color0 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        // Info Shape Drawing
        let infoShapePath = UIBezierPath()
        infoShapePath.move(to: CGPoint(x: 45.66, y: 15.96))
        infoShapePath.addCurve(to: CGPoint(x: 45.66, y: 5.22), controlPoint1: CGPoint(x: 48.78, y: 12.99), controlPoint2: CGPoint(x: 48.78, y: 8.19))
        infoShapePath.addCurve(to: CGPoint(x: 34.34, y: 5.22), controlPoint1: CGPoint(x: 42.53, y: 2.26), controlPoint2: CGPoint(x: 37.47, y: 2.26))
        infoShapePath.addCurve(to: CGPoint(x: 34.34, y: 15.96), controlPoint1: CGPoint(x: 31.22, y: 8.19), controlPoint2: CGPoint(x: 31.22, y: 12.99))
        infoShapePath.addCurve(to: CGPoint(x: 45.66, y: 15.96), controlPoint1: CGPoint(x: 37.47, y: 18.92), controlPoint2: CGPoint(x: 42.53, y: 18.92))
        infoShapePath.close()
        infoShapePath.move(to: CGPoint(x: 48, y: 69.41))
        infoShapePath.addCurve(to: CGPoint(x: 40, y: 77), controlPoint1: CGPoint(x: 48, y: 73.58), controlPoint2: CGPoint(x: 44.4, y: 77))
        infoShapePath.addLine(to: CGPoint(x: 40, y: 77))
        infoShapePath.addCurve(to: CGPoint(x: 32, y: 69.41), controlPoint1: CGPoint(x: 35.6, y: 77), controlPoint2: CGPoint(x: 32, y: 73.58))
        infoShapePath.addLine(to: CGPoint(x: 32, y: 35.26))
        infoShapePath.addCurve(to: CGPoint(x: 40, y: 27.67), controlPoint1: CGPoint(x: 32, y: 31.08), controlPoint2: CGPoint(x: 35.6, y: 27.67))
        infoShapePath.addLine(to: CGPoint(x: 40, y: 27.67))
        infoShapePath.addCurve(to: CGPoint(x: 48, y: 35.26), controlPoint1: CGPoint(x: 44.4, y: 27.67), controlPoint2: CGPoint(x: 48, y: 31.08))
        infoShapePath.addLine(to: CGPoint(x: 48, y: 69.41))
        infoShapePath.close()
        color0.setFill()
        infoShapePath.fill()
    }
    
    class func drawEdit() {
        // Color Declarations
        let color = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        
        // Edit shape Drawing
        let editPathPath = UIBezierPath()
        editPathPath.move(to: CGPoint(x: 71, y: 2.7))
        editPathPath.addCurve(to: CGPoint(x: 71.9, y: 15.2), controlPoint1: CGPoint(x: 74.7, y: 5.9), controlPoint2: CGPoint(x: 75.1, y: 11.6))
        editPathPath.addLine(to: CGPoint(x: 64.5, y: 23.7))
        editPathPath.addLine(to: CGPoint(x: 49.9, y: 11.1))
        editPathPath.addLine(to: CGPoint(x: 57.3, y: 2.6))
        editPathPath.addCurve(to: CGPoint(x: 69.7, y: 1.7), controlPoint1: CGPoint(x: 60.4, y: -1.1), controlPoint2: CGPoint(x: 66.1, y: -1.5))
        editPathPath.addLine(to: CGPoint(x: 71, y: 2.7))
        editPathPath.addLine(to: CGPoint(x: 71, y: 2.7))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 47.8, y: 13.5))
        editPathPath.addLine(to: CGPoint(x: 13.4, y: 53.1))
        editPathPath.addLine(to: CGPoint(x: 15.7, y: 55.1))
        editPathPath.addLine(to: CGPoint(x: 50.1, y: 15.5))
        editPathPath.addLine(to: CGPoint(x: 47.8, y: 13.5))
        editPathPath.addLine(to: CGPoint(x: 47.8, y: 13.5))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 17.7, y: 56.7))
        editPathPath.addLine(to: CGPoint(x: 23.8, y: 62.2))
        editPathPath.addLine(to: CGPoint(x: 58.2, y: 22.6))
        editPathPath.addLine(to: CGPoint(x: 52, y: 17.1))
        editPathPath.addLine(to: CGPoint(x: 17.7, y: 56.7))
        editPathPath.addLine(to: CGPoint(x: 17.7, y: 56.7))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 25.8, y: 63.8))
        editPathPath.addLine(to: CGPoint(x: 60.1, y: 24.2))
        editPathPath.addLine(to: CGPoint(x: 62.3, y: 26.1))
        editPathPath.addLine(to: CGPoint(x: 28.1, y: 65.7))
        editPathPath.addLine(to: CGPoint(x: 25.8, y: 63.8))
        editPathPath.addLine(to: CGPoint(x: 25.8, y: 63.8))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 25.9, y: 68.1))
        editPathPath.addLine(to: CGPoint(x: 4.2, y: 79.5))
        editPathPath.addLine(to: CGPoint(x: 11.3, y: 55.5))
        editPathPath.addLine(to: CGPoint(x: 25.9, y: 68.1))
        editPathPath.close()
        editPathPath.miterLimit = 4;
        editPathPath.usesEvenOddFillRule = true;
        color.setFill()
        editPathPath.fill()
    }
    
    class func drawQuestion() {
        // Color Declarations
        let color = UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
        // Questionmark Shape Drawing
        let questionShapePath = UIBezierPath()
        questionShapePath.move(to: CGPoint(x: CGFloat(33.75), y: CGFloat(54.1)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(44.15), y: CGFloat(54.1)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(44.15), y: CGFloat(47.5)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(51.85), y: CGFloat(37.2)), controlPoint1: CGPoint(x: CGFloat(44.15), y: CGFloat(42.9)), controlPoint2: CGPoint(x: CGFloat(46.75), y: CGFloat(41.2)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(61.95), y: CGFloat(19.9)), controlPoint1: CGPoint(x: CGFloat(59.05), y: CGFloat(31.6)), controlPoint2: CGPoint(x: CGFloat(61.95), y: CGFloat(28.5)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(41.45), y: CGFloat(2.8)), controlPoint1: CGPoint(x: CGFloat(61.95), y: CGFloat(7.6)), controlPoint2: CGPoint(x: CGFloat(52.85), y: CGFloat(2.8)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(25.05), y: CGFloat(5.8)), controlPoint1: CGPoint(x: CGFloat(34.75), y: CGFloat(2.8)), controlPoint2: CGPoint(x: CGFloat(29.65), y: CGFloat(3.8)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(25.05), y: CGFloat(14.4)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(38.15), y: CGFloat(12.3)), controlPoint1: CGPoint(x: CGFloat(29.15), y: CGFloat(13.2)), controlPoint2: CGPoint(x: CGFloat(32.35), y: CGFloat(12.3)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(49.65), y: CGFloat(20.8)), controlPoint1: CGPoint(x: CGFloat(45.65), y: CGFloat(12.3)), controlPoint2: CGPoint(x: CGFloat(49.65), y: CGFloat(14.4)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(43.65), y: CGFloat(31.7)), controlPoint1: CGPoint(x: CGFloat(49.65), y: CGFloat(26)), controlPoint2: CGPoint(x: CGFloat(47.95), y: CGFloat(28.4)))
        questionShapePath.addCurve(to: CGPoint(x: CGFloat(33.75), y: CGFloat(46.6)), controlPoint1: CGPoint(x: CGFloat(37.15), y: CGFloat(36.9)), controlPoint2: CGPoint(x: CGFloat(33.75), y: CGFloat(39.7)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(33.75), y: CGFloat(54.1)))
        questionShapePath.close()
        questionShapePath.move(to: CGPoint(x: CGFloat(33.15), y: CGFloat(75.4)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(45.35), y: CGFloat(75.4)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(45.35), y: CGFloat(63.7)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(33.15), y: CGFloat(63.7)))
        questionShapePath.addLine(to: CGPoint(x: CGFloat(33.15), y: CGFloat(75.4)))
        questionShapePath.close()
        color.setFill()
        questionShapePath.fill()
    }
    
    // Generated Images
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawCheckmark()
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawCross()
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    class var imageOfNotice: UIImage {
        if (Cache.imageOfNotice != nil) {
            return Cache.imageOfNotice!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawNotice()
        Cache.imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfNotice!
    }
    
    class var imageOfWarning: UIImage {
        if (Cache.imageOfWarning != nil) {
            return Cache.imageOfWarning!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawWarning()
        Cache.imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfWarning!
    }
    
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawInfo()
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
    
    class var imageOfEdit: UIImage {
        if (Cache.imageOfEdit != nil) {
            return Cache.imageOfEdit!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawEdit()
        Cache.imageOfEdit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfEdit!
    }
    
    class var imageOfQuestion: UIImage {
        if (Cache.imageOfQuestion != nil) {
            return Cache.imageOfQuestion!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        CASAlertViewStyleKit.drawQuestion()
        Cache.imageOfQuestion = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfQuestion!
    }
}




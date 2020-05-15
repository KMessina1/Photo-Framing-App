/*--------------------------------------------------------------------------------------------------------------------------
   File: ClassExtensions.swift
 Author: Kevin Messina
Created: August 6, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** CAS CUSTOM CLASS SUBCLASSES ***
@objc(Controls) class Controls:NSObject {
    var Version: String { return "2.00" }
}


// MARK: -
/// - returns: Button with configurable content
@IBDesignable class CAS_Button:UIButton {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    /* Required for IB to force redraw at designtime */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit(){
        cornerRadius = 0
        borderColor = .clear
        borderWidth = 0
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth  = borderWidth
        }
    }

    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

/// - returns: UILabel with configurable content
@IBDesignable class CAS_RotatingLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

@IBDesignable class CAS_Label:UILabel {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    /* Required for IB to force redraw at designtime */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        cornerRadius = 0
        borderColor = .clear
        borderWidth = 0
        top = 0
        left = 0
        bottom = 0
        right = 0
        rotationAngle = 0
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth  = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle:CGFloat = 0.0 {
        didSet {
            let radians = CGFloat(sharedFunc.DRAW().degreesToRadians(degrees: Double(rotationAngle)))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    /* Edge insets */
    @IBInspectable var top: CGFloat = 0
    @IBInspectable var left: CGFloat = 0
    @IBInspectable var bottom: CGFloat = 0
    @IBInspectable var right: CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: top,left: left,bottom: bottom,right: right)))
    }
}

/// - returns: UILabel with configurable content
@IBDesignable class CAS_LabelEdgeInset:UILabel {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    /* Required for IB to force redraw at designtime */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit(){
    }
    
    var edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.edgeInsets))
    }
}

/// - returns: UILabel with configurable content
//@IBDesignable final class CAS_Label:UILabel {
//    var _vertAlign:UIControlContentVerticalAlignment! = .Center
//    
//    @IBInspectable var vertAlign:Int = 0 {
//        didSet {
//            switch vertAlign { // 0=center, 1=Top, 2=Bottom, 3=Fill
//                case UIControlContentVerticalAlignment.Center.rawValue:
//                    self._vertAlign = .Center
//                case UIControlContentVerticalAlignment.Top.rawValue:
//                    self._vertAlign = .Top
//                case UIControlContentVerticalAlignment.Bottom.rawValue:
//                    self._vertAlign = .Bottom
//                case UIControlContentVerticalAlignment.Fill.rawValue:
//                    self._vertAlign = .Fill
//                default:
//                    self._vertAlign = .Center
//            }
//            setNeedsDisplay()
//        }
//    }
//    
//    @IBInspectable var cornerRadius:CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//        }
//    }
//    
//    @IBInspectable var borderColor:UIColor = .clear {
//        didSet {
//            layer.masksToBounds = true
//            layer.borderColor = borderColor.CGColor
//        }
//    }
//    
//    @IBInspectable var borderWidth:CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable var rotationAngle:Double = 0 {
//        didSet {
//            let radians:CGFloat! = sharedFunc.DRAW().degreesToRadians(degrees: rotationAngle)
//            
//            self.transform = CGAffineTransformMakeRotation(radians)
//        }
//    }
//    
//    @IBInspectable var edgeInsets:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    override func drawTextInRect(var rect: CGRect) {
//        if let stringText = self.text {
//            let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineBreakMode = self.lineBreakMode;
//            let options:NSStringDrawingOptions = [.UsesLineFragmentOrigin, .TruncatesLastVisibleLine, .UsesFontLeading]
//            let labelStringSize:CGSize = (stringText as NSString).boundingRectWithSize(CGSize(CGRectGetWidth(self.frame), CGFloat.max),
//                options: options,
//                attributes: [NSFontAttributeName:self.font,NSParagraphStyleAttributeName: paragraphStyle],
//                context: nil).size
//
//            if self._vertAlign == .Top {
//                self.edgeInsets = UIEdgeInsetsMake(self.edgeInsets.top,self.edgeInsets.left,self.edgeInsets.bottom,self.edgeInsets.right)
//            } else if self._vertAlign == .Bottom {
//                self.edgeInsets = UIEdgeInsetsMake(self.frame.size.height,self.edgeInsets.left,edgeInsets.bottom,self.edgeInsets.right)
//            } else if self._vertAlign == .Center {
//                self.edgeInsets = UIEdgeInsetsMake(labelStringSize.height,self.edgeInsets.left,self.edgeInsets.bottom,self.edgeInsets.right)
//            }
//            
//            rect = CGRect(0, 0, rect.width, labelStringSize.height)
//            super.drawTextInRect(UIEdgeInsetsInsetRect(rect, self.edgeInsets))
//
//            return
//        }
//        
//        super.drawTextInRect(rect)
//    }
//    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//    }
//}

/// - returns: UISwitch with pre-configured content
@IBDesignable class CAS_Switch:UISwitch {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    /* Required for IB to force redraw at designtime */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit(){
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = #colorLiteral(red: 0.9987408519, green: 0.1733306944, blue: 0.3358413577, alpha: 1)
        onTintColor = #colorLiteral(red: 0.2994727492, green: 0.8526373506, blue: 0.3907377124, alpha: 1)
        tintColor = .clear
    }
}

/// - returns: TextField with configurable content
@IBDesignable class CAS_TextField:UITextField {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    /* Required for IB to force redraw at designtime */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        cornerRadius = 0
        borderColor = .clear
        borderWidth = 0
        insetX = 0
        insetY = 0
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth  = borderWidth
        }
    }
        
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0

    // Displayed text position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }

    // Placeholder text position
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    // Editing Text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }

/* This is included here as a reminder that it can be overridden if needed
    // Clear button position
    override func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX - 5 , insetY)
    }
*/
}

/// - returns: View with configurable content
@IBDesignable class CAS_Table:UITableView {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit(){
        cornerRadius = 0
        borderColor = .clear
        borderWidth = 0
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth  = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

/// - returns: View with configurable content
@IBDesignable class CAS_View:UIView {
    /* Required to force redraw at runtime */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    /* Required for IB to force redraw at designtime */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit(){
        cornerRadius = 0
        borderColor = .clear
        borderWidth = 0
        rotationAngle = 0
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth  = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle:CGFloat = 0.0 {
        didSet {
            let radians = CGFloat(sharedFunc.DRAW().degreesToRadians(degrees: Double(rotationAngle)))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}

/// - returns: UIWebView without first responder set.
// Deprecated iOS 12
//class CAS_WebView:UIWebView {
//    /* Required to force redraw at runtime */
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        commonInit()
//    }
//
//    /* Required for IB to force redraw at designtime */
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    func commonInit(){
//    }
//
//    override var canBecomeFirstResponder : Bool {
//        return false
//    }
//}

// MARK: - CENTER COLLECTION CELLS IN COLLECTION VIEW -
/// - returns: a custom UICollectionViewCell that self-centers while scrolling. In IB, set the Class to this for Flow Layout object.
class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var centered:CGPoint = CGPoint.init()
        
        defer {
            let notifyName = Notification.Name("centeredCollectionViewTriggered")
            NotificationCenter.default.post(name: notifyName, object: nil, userInfo: ["x":centered.x,"y":centered.y])
        }

        if let cv = self.collectionView {
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds)  {
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                        continue
                    }
                    
                    if let candAttrs = candidateAttributes {
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttrs.center.x - proposedContentOffsetCenterX
                        
                        if fabsf(Float(a)) < fabsf(Float(b)) {
                            candidateAttributes = attributes
                        }
                    }else{ // == First time in the loop == //
                        candidateAttributes = attributes
                        continue;
                    }
                }
                
                centered = CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
                
                return centered
            }
            
        }
        
        // Fallback
        centered = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return centered
    }
}

@IBDesignable class GlowingButton:UIButton {
    @IBInspectable var animDuration:CGFloat = 3
    @IBInspectable var cornerRadius:CGFloat = 5
    @IBInspectable var maxGlowSize:CGFloat = 10
    @IBInspectable var minGlowSize:CGFloat = 0
    @IBInspectable var glowColor:UIColor = nil ?? UIColor.red
    @IBInspectable var animateAllways:Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentScaleFactor = UIScreen.main.scale
        self.layer.masksToBounds = false
        
        if(self.animateAllways){
            self.setupButtonForContinueAnimation()
            self.startAnimation()
        }else{
            self.setupButton()
        }
    }
    
    func setupButton() {
        self.layer.cornerRadius = cornerRadius
        // If error on the next line, check that the corner radius isn't more than 1/2 button height.
        self.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        self.layer.shadowRadius = 0
        self.layer.shadowColor = self.glowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1
    }
    
    func setupButtonForContinueAnimation() {
        self.setupButton()
        self.layer.shadowRadius = maxGlowSize
    }
    
    func startAnimation() {
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = minGlowSize
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(animDuration/2)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")
    }
}

@IBDesignable class PaddingLabel:UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension PaddingLabel {
    @IBInspectable var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

//@IBDesignable class PaddingLabel: UILabel {
//    @IBInspectable var topInset: CGFloat = 5.0
//    @IBInspectable var bottomInset: CGFloat = 5.0
//    @IBInspectable var leftInset: CGFloat = 7.0
//    @IBInspectable var rightInset: CGFloat = 7.0
//
//    override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }
//
//    override var intrinsicContentSize: CGSize {
//        var intrinsicSuperViewContentSize = super.intrinsicContentSize
//        intrinsicSuperViewContentSize.height += topInset + bottomInset
//        intrinsicSuperViewContentSize.width += leftInset + rightInset
//        return intrinsicSuperViewContentSize
//    }
//}


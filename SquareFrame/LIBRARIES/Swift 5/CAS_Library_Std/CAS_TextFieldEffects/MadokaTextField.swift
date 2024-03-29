//
//  MadokaTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 05/02/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//  https://github.com/mihaelamiches/TextFieldEffects



/**
 A MadokaTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the edges of the control.
 */
@IBDesignable open class MadokaTextField: TextFieldEffects {
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The color of the border.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    var borderThickness: CGFloat = 1
    var placeholderInsets = CGPoint(x: 6, y: 6)
    var textFieldInsets = CGPoint(x: 6, y: 6)
    fileprivate let borderLayer = CAShapeLayer()
    var backgroundLayerColor: UIColor?
    
    // MARK: - TextFieldsEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    override open func animateViewsForTextEntry() {
        borderLayer.strokeEnd = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            let translate = CGAffineTransform(translationX: -self.placeholderInsets.x, y: self.placeholderLabel.bounds.height + (self.placeholderInsets.y * 2))
            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            self.placeholderLabel.transform = translate.concatenating(scale)
        }) { _ in
            self.animationCompletionHandler?(.textEntry)
        }
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            borderLayer.strokeEnd = percentageForBottomBorder()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLabel.transform = CGAffineTransform.identity
            }) { _ in
                self.animationCompletionHandler?(.textDisplay)
            }
        }
    }
    
    // MARK: - Private
    
    fileprivate func updateBorder() {
        let rect = rectForBorder(bounds)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.origin.x + borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.origin.y + borderThickness))
        path.addLine(to: CGPoint(x: rect.origin.x + borderThickness, y: rect.origin.y + borderThickness))
        path.close()
        borderLayer.path = path.cgPath
        borderLayer.lineCap = CAShapeLayerLineCap.square
        borderLayer.lineWidth = borderThickness
        borderLayer.fillColor = nil
        borderLayer.strokeColor = borderColor?.cgColor
        borderLayer.strokeEnd = percentageForBottomBorder()
    }
    
    fileprivate func percentageForBottomBorder() -> CGFloat {
        let borderRect = rectForBorder(bounds)
        let sumOfSides = (borderRect.width * 2) + (borderRect.height * 2)
        return (borderRect.width * 100 / sumOfSides) / 100
    }
    
    fileprivate func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    fileprivate func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    fileprivate func rectForBorder(_ bounds: CGRect) -> CGRect {
        let newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        
        return newRect
    }
    
    fileprivate func layoutPlaceholderInTextRect() {
        placeholderLabel.transform = CGAffineTransform.identity
        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height - placeholderLabel.bounds.height - placeholderInsets.y,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        return newBounds.insetBy(dx: textFieldInsets.x, dy: 0)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        
        return newBounds.insetBy(dx: textFieldInsets.x, dy: 0)
    }
    
}

/*--------------------------------------------------------------------------------------------------------------------------
   File: ClassExtensions.swift
 Author: Kevin Messina
Created: August 6, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 16, 2016
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit

private let _wordSize = __WORDSIZE

// MARK: - *** CLASS EXTENSIONS ***
extension UIAlertController {
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}

@objc(Extensions) class Extensions:NSObject {
    var Version:String! { return "2.09" }
}

// MARK: - *** Make classes and structs iterable through to be printable to console ***
protocol Loopable {
    var allProperties: [String: Any] { get }
}

extension Loopable {
    var allProperties: [String: Any] {
        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }
        return result
    }

    func allPropertiesPrintToConsole() -> Void {
        if isSimDevice.isFalse { return }

        let repeats:Int = 50
        var padding:Int = 0
        var charCount:Int = 0

        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }

        for item in result {
            let keyCount = String(describing: item.0).count
            if keyCount > padding { padding = keyCount }
            charCount += String(describing: item.0).length
            charCount += String(describing: item.1).length
        }
        
        print ("\n\("-".repeatNumTimes(repeats))")
        print ("*** Dump of Struct ***")
        print ("keys Count: \( result.count )")
        print ("character Count: \( charCount )")
        print ("\("-".repeatNumTimes(repeats))")
        for item in result {
            var val = String(describing: item.1)
            if val.isEmpty { val = "{␢ empty}" }
            var key = String(describing: item.0)
            key = " ".repeatNumTimes(padding - key.count) + key
            
            print ("\(key) = \(val)")
        }
        print ("\("-".repeatNumTimes(repeats))\n")
    }
}

public extension UIAlertController {
    func isValidEmail(_ email: String) -> Bool {
        return email.count > 0 && NSPredicate(format: "self matches %@","[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}").evaluate(with: email)
    }

    func isValidNumberOnly(_ input: String) -> Bool {
        let isValid = sharedFunc.STRINGS().containsValidCharacters(text: input, charSet: kCharSet.VALID.numbersOnly )
        
        return (input.isNotEmpty && isValid)
    }

    func isValidCurrency(_ input: String) -> Bool {
        let isValid = sharedFunc.STRINGS().containsValidCharacters(text: input, charSet: kCharSet.VALID.numeric )

        return (input.isNotEmpty && isValid)
    }
    
    func isValidDate(_ input:String) -> Bool {
        let isCorrectLength = (input.count == 10)
        let has2Slashes = ((input.components(separatedBy: "/").count - 1) == 2)
        let has2Dashes = ((input.components(separatedBy: "-").count - 1) == 2)
        let isDateCharsOnly = sharedFunc.STRINGS().containsValidCharacters(text: input, charSet: kCharSet.VALID.dateOnly)

        let hasSeparators = (has2Slashes || has2Dashes)
        
        return isCorrectLength && hasSeparators && isDateCharsOnly
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 1 && password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
    }

    @objc func textDidChangeInLoginAlert() {
        if let email = textFields?[0].text,
           let password = textFields?[1].text,
           let action = actions.last {
      
            action.isEnabled = isValidEmail(email) && isValidPassword(password)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Login".localizedCAS() :"--", forKey: "title")
        }
    }

    @objc func textDidChangeInAlert_TrackingAndPostage() {
        if let postageAmt = textFields?[0].text,
           let trackingNum = textFields?[1].text,
           let shipDate = textFields?[2].text,
           let action = actions.last {

            let isDateValid = isValidDate(shipDate)
            let isPostageValid = isValidCurrency(postageAmt)
            
            action.isEnabled = (isDateValid && isPostageValid && postageAmt.isNotEmpty && trackingNum.isNotEmpty && shipDate.isNotEmpty)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Continue".localizedCAS() :"--", forKey: "title")
        }
    }
    
    @objc func textDidChangeInPasscodeAlert() {
        if let passcode = textFields?[0].text,
           let action = actions.last {

            action.isEnabled = isValidPassword(passcode)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Login".localizedCAS() :"--", forKey: "title")
        }
    }

    @objc func textDidChangeInEmailAlert() {
        if let input = textFields?[0].text,
           let action = actions.last {

            action.isEnabled = isValidEmail(input)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Login".localizedCAS() :"--", forKey: "title")
        }
    }

    @objc func textDidChangeInTextField() {
        if let input = textFields?[0].text,
           let action = actions.first {
            
            action.isEnabled = (input.length >= 4)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Search".localizedCAS() :"--", forKey: "title")
        }
    }
    
    @objc func textDidChangeInEmailAlert_Save() {
        if let input = textFields?[0].text,
           let action = actions.last {

            action.isEnabled = isValidEmail(input)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Save".localizedCAS() :"--", forKey: "title")
        }
    }

    @objc func textDidChangeInSingleDateAlert() {
        if let date = textFields?[0].text,
           let action = actions.last {
            
            action.isEnabled = isValidDate(date)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            action.setValue(action.isEnabled ?"Continue".localizedCAS() :"--", forKey: "title")
        }
    }
    
    @objc func textDidChangeInDateAlert() {
        if let fromDate = textFields?[0].text,
           let toDate = textFields?[1].text,
           let action = actions.first {

            action.isEnabled = isValidDate(fromDate) && isValidDate(toDate)
            action.setValue(action.isEnabled ?APPTHEME.alert_ButtonEnabled :APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
        }
    }
}

public extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

public extension Array {
    /// - ex: {arrayName}.forEach(doThis: { item in print("Stack: \(item)") })
    /// - ex: {arrayName}.forEach(doThis: { _ in self.item += "\n" })
    /// - ex: {arrayName}.forEach(doThis: { item in self.{arrayName}.append item })
    /// - returns: A construct to iterate an array and perform an enclosed function.
    func forEach(_ doThis: (_ element:Element) -> Void) {
        for e in self {
            doThis(e)
        }
    }
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension Array where Element:Hashable {
    var unique:[Element] {
        return Array(Set(self))
    }
}

extension Array where Element == Int {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
    }
}

extension Array where Element: FloatingPoint {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

extension Bool {
    init(_ number: Int) {
        self.init(truncating: number as NSNumber)
    }
    
    var isTrue:Bool { return (self == true) }
    var isFalse:Bool { return (self == false) }
    var toString:String { return (self == true) ?"True" :"False" }
    var toStringInt:String { return (self == true) ?"1" :"0" }
    var intValue: Int { return (self == true) ?1 :0 }
    var numberValue:NSNumber { return NSNumber.init(booleanLiteral: self) }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        if self.presentedViewController == nil {
            return self
        }

        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.windows.filter {$0.isKeyWindow}.first?.rootViewController?.topMostViewController()
    }
}

/// - returns: Bundle Versions
extension Bundle {
    var ver:String { return infoDictionary?["CFBundleShortVersionString"] as? String ?? "0" }
    var build:String { return infoDictionary?["CFBundleVersion"] as? String ?? "0" }
    var fullVer:String { return "\(ver).\(build)" }
    var displayName:String { return infoDictionary?["CFBundleDisplayName"] as? String ?? "" }
    var indentifier:String? { return infoDictionary?["CFBundleIdentifier"] as? String ?? "" }
    
    var appIcon:UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String:Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last
        else {
            return UIImage.init()
        }

        return UIImage(named: lastIcon)
    }
}

/// - returns: conversions to Double numbers
extension Double {
    // Conversion
// MARK: ├─➤ Length
    /// - returns: meter to centimeter conversion
    var convert_m_cm: Double { return self / 100.0 }
    /// - returns: meter to millimeter conversion
    var convert_m_mm: Double { return self / 1_000.0 }
    /// - returns: meter to feet conversion
    var convert_m_ft: Double { return self * 3.2808399 }
    /// - returns: feet to meter conversion
    var convert_ft_m: Double { return self * 0.3048 }
    /// - returns: feet to miles conversion
    var convert_ft_miles: Double { return self / 5_280 }
    /// - returns: miles to feet conversion
    var convert_miles_ft: Double { return self * 5_280 }
    /// - returns: kilometer to miles conversion
    var convert_km_miles: Double { return self * 0.62137119 }
    /// - returns: miles to kilometer conversion
    var convert_miles_km: Double { return self * 1.609344 }
    /// - returns: feet to kilometer conversion
    var convert_ft_km: Double { return self * 0.0003048 }
    /// - returns: kilometer to feet conversion
    var convert_km_ft: Double { return self * 3_280.8399 }
    /// - returns: kilometer to meter conversion
    var convert_km_m: Double { return self * 1_000.0 }
    /// - returns: miles to kilometer conversion
    var convert_m_km: Double { return self / 1_000.0 }
    /// - returns: inches to feet conversion
    var convert_inch_ft: Double { return self / 12 }
    /// - returns: feet to inch conversion
    var convert_ft_inch: Double { return self * 12 }
    /// - returns: yards to feet conversion
    var convert_yards_ft: Double { return self * 3 }
    /// - returns: feet to yards conversion
    var convert_ft_yards: Double { return self / 3 }
    /// - returns: yards to inches conversion
    var convert_yards_inch: Double { return self * 36 }
    /// - returns: inches to yards conversion
    var convert_inch_yards: Double { return self / 36 }
    /// - returns: inches to meters conversion
    var convert_inch_m: Double { return self * 0.0254 }
    /// - returns: inches to centimeters conversion
    var convert_inch_cm: Double { return self * 2.54 }
    /// - returns: inches to millimeters conversion
    var convert_inch_mm: Double { return self * 25.4 }
    /// - returns: meters to inches conversion
    var convert_m_inch: Double { return self * 39.370079 }
    /// - returns: centimeteres to inches conversion
    var convert_cm_inch: Double { return self * 0.39370079 }
    /// - returns: millimeters to inches conversion
    var convert_mm_inch: Double { return self * 0.039370079 }
// MARK: ├─➤ Weight
    /// - returns: lbs. to ounces conversion
    var convert_lbs_oz: Double { return self * 16 }
    /// - returns: ounces to lbs. conversion
    var convert_oz_lbs: Double { return self / 16 }
    /// - returns: ounces to kilograms conversion
    var convert_oz_kg: Double { return self * 0.03 }
    /// - returns: kilograms to ounces conversion
    var convert_kg_oz: Double { return self * 35.27 }
    /// - returns: lbs. to kilograms conversion
    var convert_lbs_kg: Double { return self * 0.45359237 }
    /// - returns: kilograms to lbs. conversion
    var convert_kg_lbs: Double { return self * 2.2046226 }
// MARK: ├─➤ Rounding
    /// - returns: rounded to nearest tens position
    var roundTo_Tens:Double { return Double(10 * Int(self.rounded() / 10.0)) }
    /// - returns: rounded to nearest hundreds position
    var roundTo_Hundreds:Double { return Double(100 * Int(self.rounded() / 100.0)) }
    /// - returns: rounded to nearest thousands position
    var roundTo_Thousands:Double { return Double(1000 * Int(self.rounded() / 1000.0)) }
    /// - returns: rounded to nearest ten-thousands position
    var roundTo_TenThousands:Double { return Double(10000 * Int(self.rounded() / 10000.0)) }
    /// - returns: rounded to nearest hundred-thousands position
    var roundTo_HundredThousands:Double { return Double(100000 * Int(self.rounded() / 100000.0)) }
    /// - returns: rounded to nearest millions position
    var roundTo_Millions:Double { return Double(1000000 * Int(self.rounded() / 1000000.0)) }

    /// - returns: rounded to number of decimal places
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: -
public extension FloatingPoint {
    var degreesToRadians:Self {
        return ((self * .pi) / 180)
    }
    
    var radiansToDegrees:Self {
        return ((self * 180) / .pi)
    }
}

// MARK: -
public extension NSAttributedString {
    func heightNeededToFitText(
        txt:String,
        maxWidth:CGFloat? = UIScreen.main.bounds.size.width,
        maxHeight:CGFloat? = CGFloat.greatestFiniteMagnitude,
        attribs:[NSAttributedString.Key:Any]
    ) -> CGFloat {
        
        let text = NSString(string: txt)
        
        let rect:CGRect = text.boundingRect(with: CGSize(width:maxWidth!, height: CGFloat.greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin,
                                      attributes: attribs,
                                         context: nil)
        
        let estHeight:CGFloat = rect.size.height
        let maxHt:CGFloat = maxHeight!
        
        return (estHeight > maxHt) ?maxHt :estHeight
    }
}

// MARK: -
public extension UIBarButtonItem {
    static let btnAdd = UIBarButtonItem(title: "Add".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnDone = UIBarButtonItem(title: "Done".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnDelete = UIBarButtonItem(title: "Delete".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnEdit = UIBarButtonItem(title: "Edit".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnSave = UIBarButtonItem(title: "Save".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnUpdate = UIBarButtonItem(title: "Update".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnView = UIBarButtonItem(title: "View".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnPrint = UIBarButtonItem(title: "Print".localizedCAS(), style: .plain, target: nil, action: nil)
    static let btnPrintToSize = UIBarButtonItem(title: "PrintToSize".localizedCAS(), style: .plain, target: nil, action: nil)

    static let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    static let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
}

// MARK: -
public extension UIImage {
    enum imgOrientationStruct { case square,landscape,portrait }
    
    var orientation:imgOrientationStruct {
        if self.isSquare {
            return .square
        }else if self.isPortrait {
            return .portrait
        }else{
            return .landscape
        }
    }
    
    func recolor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                var image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() { () -> Void in
                image = image
            }
        }.resume()
    }

    func downloadedFrom(link: String) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}

// MARK: -
public extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data) else {
                    
                return
            }
            
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }

        downloadedFrom(url: url, contentMode: mode)
    }
}

// MARK: -
public extension Int {
    var degreesToRadians: Double {
        return Double(self) * .pi / 180
    }
    
    var radiansToDegrees: Double {
        return Double(self) * 180 / .pi
    }
    
    var numDigits:Int {
        return String(self).count
    }
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}


// MARK: -
public extension UInt {
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

// MARK: -
public extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}

// MARK: -
public extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.calendar = NSCalendar.current
            dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = kDateFormat.SQL
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)

        dateFormatter.timeZone = TimeZone.current
        
        if dt != nil {
            return dateFormatter.string(from: dt!)
        }else{
            return ""
        }
    }

    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
           let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
           let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            
            return self.addingTimeInterval(targetOffset - localOffeset)
        }
        
        return nil
    }
    
    func differenceToCurrentTimeZone() -> Date {
        let UTC = TimeZone.init(abbreviation: "GMT")
        let currentTimeZone = TimeZone.current
        let delta = TimeInterval(UTC!.secondsFromGMT() - currentTimeZone.secondsFromGMT())
        let differenceDate = addingTimeInterval(delta)
    
        return differenceDate
    }
    
    static func <(a: Date, b: Date) -> Bool{
        return a.compare(b) == ComparisonResult.orderedAscending
    }
    
    static func ==(a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedSame
    }

    var yearNum:Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return Int(formatter.string(from: self as Date))!
    }

    var monthNum:Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return Int(formatter.string(from: self as Date))!
    }
    
    var dayNum:Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Int(formatter.string(from: self as Date))!
    }
    
    var calendar: Calendar {
        return Calendar(identifier: Calendar.Identifier.gregorian)
    }
    
    func after(value: Int, calendarUnit:DateComponents) -> Date{
        return calendar.date(byAdding: calendarUnit, to: self)!
    }

    func minus(date: Date) -> DateComponents{
        return calendar.dateComponents([.minute], from: self, to: date)
    }
    
    func equalsTo(date: Date) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedSame
    }

    func greaterThan(date: Date) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedDescending
    }

    func greaterThanOrEqualTo(date: Date) -> Bool {
        let greaterThan = self.compare(date as Date) == ComparisonResult.orderedDescending
        let equaltTo = self.compare(date as Date) == ComparisonResult.orderedSame
        
        return (greaterThan.isTrue || equaltTo.isTrue)
    }
    
    func lessThan(date: Date) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedAscending
    }

    func lessThanOrEqualTo(date: Date) -> Bool {
        let lessThan = self.compare(date as Date) == ComparisonResult.orderedAscending
        let equaltTo = self.compare(date as Date) == ComparisonResult.orderedSame
        
        return (lessThan.isTrue || equaltTo.isTrue)
    }
    

    static func parse(dateString: String, format:String? = "yyyy-MM-dd HH:mm:ss") -> Date{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.date(from: dateString)!
    }

    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"

        let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"

        return  dateFormatter.string(from: date!)
    }
    
    func toString(format:String? = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }

    func MonthNum(format:String? = "MM") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    func monthAbbrev(format:String? = "MMM") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    func monthName(format:String? = "MMMM") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }

    func DayNum(format:String? = "dd", addSuffix:Bool? = false) -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        
        var date = formatter.string(from: self as Date)
        if addSuffix! {
            date = date.replacingOccurrences(of: "0", with: "")
            switch Int(date)! {
            case 1,21,31: date = "\(date)st"
            case 2,22: date = "\(date)nd"
            case 3,23: date = "\(date)rd"
            default: date = "\(date)th"
            }
        }
        
        return date
    }
    
    func DayName(format:String? = "EEEE") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    func DayAbbrev(format:String? = "EEE") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    func year() -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
        return formatter.string(from: self as Date)
    }

    func time(format:String? = "HH:mm:ss") -> String{
        let formatter = DateFormatter()
            formatter.dateFormat = format!
        return formatter.string(from: self as Date)
    }

    func toShortTimeString() -> String {
        //Get Short Time String
        let formatter = DateFormatter()
            formatter.timeStyle = .short
        return formatter.string(from: self as Date)
    }
}


// MARK: -
public extension ByteCountFormatter {
    func formatWith(units: ByteCountFormatter.Units, style: ByteCountFormatter.CountStyle) -> ByteCountFormatter {
        let byteCountFormatter = ByteCountFormatter()
            byteCountFormatter.allowedUnits = units
            byteCountFormatter.countStyle = style
        
        return byteCountFormatter
    }
}


// MARK: -
public extension DateFormatter {
    func formatAs(_ format:kDateFormat) -> DateFormatter {
        return customFormat("\(format)")
    }
    
    func customFormat(_ format:String) -> DateFormatter {
        let formatter:DateFormatter! = DateFormatter()
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.dateStyle = .none
            formatter.dateFormat = format
        
        return formatter
    }
    
    var SQL:DateFormatter { return customFormat(kDateFormat.SQL) }
    
    var dMMMyyyyEEE:DateFormatter { return customFormat(kDateFormat.d_MMM_yyyy_EEE) }
    var dMMMyyyyEEEhmma:DateFormatter { return customFormat(kDateFormat.d_MMM_yyyy_EEEE_hmm_a) }
    var dMMMyyyyEEE_at_hmma:DateFormatter { return customFormat(kDateFormat.MMM_d_yyyy_EEE_at_hmm_a) }
    var dMMMyyyyEEEE:DateFormatter { return customFormat(kDateFormat.d_MMM_yyyy_EEEE) }
    var dMMMyyyyEEEE_at_hmma:DateFormatter { return customFormat(kDateFormat.d_MMM_yyyy_EEEE_at_hmm_a) }
    var dMMMyyyyEEEEhmma:DateFormatter { return customFormat(kDateFormat.d_MMM_yyyy_EEEE_hmm_a) }
    var dMMMyyyy:DateFormatter { return customFormat(kDateFormat.d_MMM_YYYY) }
    var ddMMMYYYY:DateFormatter { return customFormat(kDateFormat.dd_MMM_YYYY) }
    var MMMdyyyy:DateFormatter { return customFormat(kDateFormat.MMM_d_yyyy) }
    var MMMdyyyyEEE:DateFormatter { return customFormat(kDateFormat.MMM_d_yyyy_EEE) }
    var MMddYYYY:DateFormatter { return customFormat(kDateFormat.MMddyyyy) }
    var MMMdyyyyEEEE_at_hmma:DateFormatter { return customFormat(kDateFormat.MMM_d_yyyy_EEE_at_hmm_a) }
    var yyyyMMdd:DateFormatter { return customFormat(kDateFormat.yyyyMMdd) }
    
    var hmma:DateFormatter { return customFormat(kTimeFormat.hmm_a) }
    var hmm:DateFormatter { return customFormat(kTimeFormat.hmm) }
    var hmmss:DateFormatter { return customFormat(kTimeFormat.hmmss) }
    var mss:DateFormatter { return customFormat(kTimeFormat.mss) }
    var mssSS:DateFormatter { return customFormat(kTimeFormat.mssSS) }
    var mssS:DateFormatter { return customFormat(kTimeFormat.mssS) }
}

// MARK: -
public extension Decimal {
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}

// MARK: -
/// print( arrayOfDictionaries.toJSONString() )
//extension Collection where Iterator.Element == [String:AnyObject] {
extension Collection where Iterator.Element == [String:Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
//        if let arr = self as? [[String:AnyObject]],
        if let arr = self as? [[String:Any]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

// MARK: -
public extension LocalizedError where Self: CustomStringConvertible {
    var errorDescription: String? {
        return description
    }
}

// MARK: -
public extension NumberFormatter {
    /// - returns: Number Formatter configured for Percent, 3 numeric places.
    ///
    /// ie: let frmt_Percent = sharedFunc.FORMATTER().Percent
    ///
    class func percent (numPlaces:Int) -> NumberFormatter{
        let formatter:NumberFormatter! = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .percent
            formatter.maximumSignificantDigits = 3
            formatter.negativePrefix = "("
            formatter.negativeSuffix = ")"
            formatter.maximumFractionDigits = numPlaces
        
        return formatter
    }
    
    /// - returns: Number Formatter configured for Decimal, comma formatted, 2 decimal places.
    ///
    /// ie: let frmt_Decimal = sharedFunc.FORMATTER().Decimal
    ///
    class func noFormatting() -> NumberFormatter {
        let formatter:NumberFormatter! = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .none
            formatter.maximumFractionDigits = 0
        
        return formatter
    }
    
    /// - returns: Number Formatter configured for Decimal, comma formatted, 2 decimal places.
    ///
    /// ie: let frmt_Decimal = sharedFunc.FORMATTER().Decimal
    ///
    class func decimal(numPlaces:Int,prefix:String?="-",negPrefix:String?="-",negSuffix:String?="") -> NumberFormatter {
        let formatter:NumberFormatter! = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = Locale.current.groupingSeparator ?? ","
            formatter.maximumFractionDigits = numPlaces
            formatter.negativePrefix = negPrefix!
            formatter.negativeSuffix = negSuffix!
        
        return formatter
    }

    /// - returns: Number Formatter configured for Decimal, comma formatted, 2 decimal places.
    ///
    /// ie: let frmt_Decimal = sharedFunc.FORMATTER().Decimal
    ///
    class func number() -> NumberFormatter {
        let formatter:NumberFormatter! = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = Locale.current.groupingSeparator ?? ","
            formatter.maximumFractionDigits = 0
        
        return formatter
    }
    
    /// - returns: Number Formatter configured for Currency, comma formatted, 2 decimal places.
    ///
    /// ie: let amount = NumberFormatter.currency().string(from: NSNumber(value: (Double(quantity) * price)))
    ///
    class func currency(showSymbol:Bool? = true, Localize:Bool? = true, CountryCode:String? = "") -> NumberFormatter {
        let formatter:NumberFormatter! = NumberFormatter()
        
        if Localize!.isFalse && CountryCode!.isNotEmpty { // Localize = false, CountryCode sent as param
            let ISO_CountryCode = Jurisdictions().returnISO_LocaleForCountryCode(code: CountryCode!)
            if ISO_CountryCode.isNotEmpty {
                formatter.locale = Locale.init(identifier: ISO_CountryCode)
            }
        }else{
            let ISO_CountryCode = Jurisdictions().returnISO_LocaleForCountryCode(code: "US")
            if ISO_CountryCode.isNotEmpty {
                formatter.locale = Locale.init(identifier: ISO_CountryCode)
            }
        }
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.negativePrefix = "("
        formatter.negativeSuffix = ")"
        formatter.currencySymbol = showSymbol! ?formatter.locale.currencySymbol : ""
        
//        if isSim {
//            print("\n----------- Format Currency -----------")
//            print("param Country:\(CountryCode!.uppercased())")
//            print("locale Country:\(formatter.locale.identifier), Currency: \(formatter.currencyCode ?? ""), Symbol: \(formatter.currencySymbol ?? "")")
//        }
        
        return formatter
    }

    class func currencyForCode(code:String, showSymbol:Bool? = true) -> NumberFormatter {
        let formatter:NumberFormatter! = NumberFormatter()
            let identifier = NSLocale.identifierFromCurrencyCode(code: code) ?? ""
            formatter.locale = Locale.init(identifier: identifier)
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.negativePrefix = "("
            formatter.negativeSuffix = ")"
            formatter.currencySymbol = showSymbol! ?formatter.locale.currencySymbol : ""
        
        return formatter
    }

    /// - returns: Number Formatter with custom format, defaults negative #'s to include ().
    ///
    /// ie: let frmt_Custom = sharedFunc.FORMATTER().Custom("±#,###.#"
    ///
    class func custom (format:String) -> NumberFormatter {
        let formatter:NumberFormatter! = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .none
            formatter.negativePrefix = "("
            formatter.negativeSuffix = ")"
            formatter.positiveFormat = format
        
        return formatter
    }
}


// MARK: -
extension NSLocale {
    static func currencySymbolFromCode(code: String) -> String? {
        let localeIdentifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : code])
        let locale = NSLocale(localeIdentifier: localeIdentifier)
        return locale.object(forKey: NSLocale.Key.currencySymbol) as? String
    }
    
    static func identifierFromCurrencyCode(code: String) -> String? {
        return NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : code])
    }
}

// MARK: -
public extension NSMutableAttributedString {
    /// - parameter textToFind: Text to look for.
    /// - parameter linkURL: Tappable link.
    /// - parameter font: Font to use.
    /// - parameter activateLink: This is used to add a URL to plain text when it is not a URL. ex: "AppStore" is displayed, URL is https:\\www....
    /// - returns: Adds an underlined text link.
    func setAsLink(textToFind:String, linkURL:String, font:UIFont, activateLink:Bool!) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.font, value: font, range: foundRange)
            if activateLink.isTrue {
                self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            }
        }
    }
}

// MARK: -
public extension NSRange {
    func stringRangeForText(string: String) -> Range<String.Index> {
        let start = string.index(string.startIndex, offsetBy: self.location)
        let end = string.index(string.endIndex, offsetBy: self.location)
        
        return start..<end
    }
}

// MARK: -
extension String: Error {}/*Enables you to throw a string*/

extension String: LocalizedError {/*Adds error.localizedDescription to Error instances*/
    public var errorDescription: String? { return self }
}

public extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }

    func toBool() -> Bool? {
        switch self.uppercased() {
        case "TRUE", "YES", "1":
            return true
        case "FALSE", "NO", "0":
            return false
        default:
            return nil
        }
    }

    func changDateFormat(fromFormat:String,toFormat:String) -> String{
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFormat

        let date = dateFormatter.date(from: self)
            dateFormatter.dateFormat = toFormat

        return  dateFormatter.string(from: date!)
    }
    

// MARK: ├─➤ Conversion to UTF 16
    init?(utf16chars:[UInt16]) {
        let data = NSData(bytes: utf16chars, length: utf16chars.count * MemoryLayout<UInt16>.size)
        if let ns = NSString(data: data as Data, encoding: String.Encoding.utf16LittleEndian.rawValue) {
            self = ns as String
        } else {
            return nil
        }
    }
    
// MARK: ├─➤ Conversion to Date
    @discardableResult func convertToDate(format:String? = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter:DateFormatter = DateFormatter.init()
            formatter.dateFormat = format!
        
        let newDate = formatter.date(from: self)
        
        return (newDate != nil) ?newDate! :Date()
    }
    
// MARK: ├─➤ Conversion to Numbers
    var removeNumberFormatting:String {
        return String(self.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789.")) != nil })
    }
    
    var replaceCommas:String {
        return self.replacingOccurrences(of: ",", with: "<comma>")
    }
    
    var replaceReturns:String {
        return self.replacingOccurrences(of: cr, with: "<cr>")
    }
    
    var replaceTabs:String {
        return self.replacingOccurrences(of: tab, with: "<tab>")
    }
    
    var replaceLineFeeds:String {
        return self.replacingOccurrences(of: newLine, with: "<lf>")
    }
    
    var removeCommas:String {
        return self.replacingOccurrences(of: ",", with: " ")
    }
    
    var removeReturns:String {
        return self.replacingOccurrences(of: cr, with: " ")
    }
    
    var removeTabs:String {
        return self.replacingOccurrences(of: tab, with: "    ")
    }
    
    var removeLineFeeds:String {
        return self.replacingOccurrences(of: newLine, with: " ")
    }
    
    var boolValue:Bool {
        return NSString(string: self).boolValue
    }

    var intValue:Int {
        return NSString(string: self).integerValue
    }
    
    var int32Value:Int32 {
        return NSString(string: self).intValue
    }
    
    var doubleValue:Double {
        return NSString(string: self).doubleValue
    }

    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
            formatter.numberStyle = .currencyAccounting
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }

    func decimalInputFormatting(decimalPlaces:Int) -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
            formatter.numberStyle = .currencyAccounting
            formatter.currencySymbol = ""
            formatter.maximumFractionDigits = decimalPlaces
            formatter.minimumFractionDigits = decimalPlaces

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        let enumerator:Decimal = pow(10, decimalPlaces)
        
        number = NSNumber(value: (double / enumerator.doubleValue ))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }

// MARK: ├─➤ Information on String
    /// Returns words in string.
    var returnWordCount:(Int) {
        var wordCount:Int = 0
        let scanner:Scanner = Scanner(string: self)
        
        // Look for spaces, tabs and newlines
        if #available(iOS 13.0, *) {
            while (scanner.scanUpToCharacters(from: CharacterSet.whitespacesAndNewlines) != nil) {
                wordCount += 1
            }
        } else {
            let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
            let components = self.components(separatedBy: chararacterSet)
            let words = components.filter { !$0.isEmpty }

            wordCount = words.count
        }
        
        return Int(wordCount)
    }
    
    func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.firstIndex(of: char) {
            return self.distance(from: self.startIndex, to: idx)
        }
        
        return nil
    }

    /// - parameters: (Int) position
    /// - returns: Character for position.
    subscript(position: Int) -> Character {
        return self[index(startIndex, offsetBy: position)]
    }
    
    /// - parameters: (Range) range
    /// - returns: String for positions in range. MUST use the ..< logic within brackets. Cannot use ...
    ///
    /// ie: let temp = text[0..<2] range from 0 to 1
    /// ie: let temp = text[3..<3] range from 3 to 5
    /// ie: let temp = text[0..<text.endIndex] range from 0 to last character in string
    subscript(range: Range<Int>) -> String {
        if self.isEmpty {
            return ""
        }
        
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(start, offsetBy: range.upperBound - range.lowerBound)

        return String(self[start..<end])
    }
    
    var isValidEmail:Bool {
        /* Must contain required characters or not valid */
        let hasAtSign:Bool! = self.contains("@")
        let hasPeriod:Bool! = self.contains(".")
        let hasSpace:Bool! = self.contains(" ")
        let isEmpty:Bool = self.isEmpty
        
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            let isValid:Bool = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
            
            guard (hasAtSign && hasPeriod && !hasSpace && !isEmpty && isValid) else {
                if isSimDevice.isFalse { sharedFunc.AUDIO().vibratePhone() }
                return false
            }
        } catch {
            return false
        }
        
        return true
    }
    
    /// true if self contains characters.
    var isNotEmpty:Bool {
        return !isEmpty
    }
  
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(to: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: to)
        let end = self.endIndex
        
        return String(self[start..<end])
    }
    
    func substring(from: Int) -> String {
        let start = self.index(self.endIndex, offsetBy: -from)
        let end = self.endIndex

        return String(self[start..<end])
    }

    var length: Int {
        return self.count
    }
    
// MARK: ├─➤ Encryption of String
    func encodeWithXorByte(key:UInt8) -> String {
        return String(bytes: self.utf8.map{$0 ^ key}, encoding: String.Encoding.utf8) ?? ""
    }

// MARK: ├─➤ Localization of String
    func localized(default defaultValue:String? = "") -> String {
        if gAppLanguageCode.isEmpty || gAppLanguage.isEmpty {
            Languages().setCurrentDeviceLanguage()
        }

        var bundlePath = Bundle.main.path(forResource: gAppLanguageCode, ofType: "lproj") ?? ""
        if bundlePath.isEmpty {
            Languages().setCurrentDeviceLanguage()
            bundlePath = Bundle.main.path(forResource: gAppLanguageCode, ofType: "lproj") ?? ""
            
            if bundlePath.isEmpty {
                if isSim.isTrue { print("localization error, bundle not found.") }
                sharedFunc.ALERT().show(title: "error",style:.error,msg: "localization error, bundle not found.")
                return "n/a"
            }
        }
        
        var bundle = Bundle(path: bundlePath)
        if bundle == nil {
            Languages().setCurrentDeviceLanguage()
            bundlePath = Bundle.main.path(forResource: gAppLanguageCode, ofType: "lproj") ?? ""
            bundle = Bundle(path: bundlePath)
            
            if (bundlePath.isEmpty || (bundle == nil)) {
                if isSim.isTrue { print("localization error, bundle not found.") }
                sharedFunc.ALERT().show(title: "error",style:.error,msg: "localization error, bundle not found.")
                return "n/a"
            }
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: defaultValue!, comment: "")
    }

    func localizedCAS(default defaultValue:String? = "") -> String {
        if gAppLanguageCode.isEmpty || gAppLanguage.isEmpty {
            Languages().setCurrentDeviceLanguage()
        }

        var bundlePath = Bundle.main.path(forResource: gAppLanguageCode, ofType: "lproj") ?? ""
        if bundlePath.isEmpty {
            Languages().setCurrentDeviceLanguage()
            bundlePath = Bundle.main.path(forResource: gAppLanguageCode, ofType: "lproj") ?? ""
            
            if bundlePath.isEmpty {
                if isSim.isTrue { print("localization error, bundle not found.") }
                sharedFunc.ALERT().show(title: "error",style:.error,msg: "localization error, bundle not found.")
                return "n/a"
            }
        }
        
        var bundle = Bundle(path: bundlePath)
        if bundle == nil {
            Languages().setCurrentDeviceLanguage()
            bundlePath = Bundle.main.path(forResource: gAppLanguageCode, ofType: "lproj") ?? ""
            bundle = Bundle(path: bundlePath)
            
            if (bundlePath.isEmpty || (bundle == nil)) {
                if isSim.isTrue { print("localization error, bundle not found.") }
                sharedFunc.ALERT().show(title: "error",style:.error,msg: "localization error, bundle not found.")
                return "n/a"
            }
        }
        
        return NSLocalizedString(self, tableName:"CAS_Library", bundle:bundle!, value: defaultValue!, comment:"")
    }
    
// MARK: ├─➤ Formatting of String
    /// - returns: String with repeated characters
    func repeatNumTimes(_ numTimes:Int) -> String {
        var text:String = ""
        
        repeat { text += "\(self)" } while text.length <= numTimes
        
        return text
    }
    
    /// - returns: Trimmed string with no leading or trailing whitespace.
    var trimSpaces:String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// - returns: Trimmed string with no leading or trailing whitespace.
    var trimSpacesAndNewlines:String {
        var text = self
            text = text.trimSpaces
            text = text.replacingOccurrences(of: "\r", with: "")
            text = text.replacingOccurrences(of: "\n", with: "")
        
        if text.contains("\n") {
            print ("text: \(text)")
        }
        return text
    }
    
    /// - returns: Trimmed string with no leading or trailing whitespace.
    var removeSpaces:String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    /// - returns: Trimmed string with '' replaced with '.
    var trimDoubleApostrophes:String {
        var text = self
            text = text.replacingOccurrences(of: "\"", with: "\u{22}")
            text = text.replacingOccurrences(of: "''", with: "'")
            text = text.replacingOccurrences(of: "¬Ω", with: "½")
            text = text.trimSpaces
        return text
    }
    
    /// - returns: Trimmed string with ' replaced with ''.
    var trimReplaceApostrophes:String {
        var text = self
            text = text.replacingOccurrences(of: "\u{22}", with: "\"")
            text = text.replacingOccurrences(of: "'", with: "''")
            text = text.replacingOccurrences(of: "¬Ω", with: "½")
            text = text.trimSpaces
        return text
    }

    var replaceCharsForHTML:String {
        var text = self
            text = text.replacingOccurrences(of: " ", with: "%20")
            text = text.replacingOccurrences(of: "#", with: "%23")
            text = text.replacingOccurrences(of: "@", with: "%40")
        return text
    }

// MARK: ├─➤ FILE PATH components of String
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }  
    }  

    var lastPathComponentWithoutExtension: String {
        get {
            return (self as NSString).lastPathComponent.stringByDeletingPathExtension
        }  
    }  
    
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }  
    }  

    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }  
    }  

    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }  
    }  

    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }  
    }  
  
    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
         
        return nsSt.appendingPathComponent(path)  
    }  
  
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
         
        return nsSt.appendingPathExtension(ext)  
    }  
}

// MARK: -
public extension UIButton {
    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x:0.0,y: 0.0,width: 1.0,height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setBackgroundColor(color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color), for: state)
    }
}

// MARK: -
public extension UIDevice {
    /// - returns: String for Model Name.
    ///
    /// ie: let Model:String = UIDevice.current.modelName
    ///
    var modelName:String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""
        
         for child in mirror.children where child.value as? Int8 != 0 {
             identifier.append(String(UnicodeScalar(UInt8(child.value as! Int8))))
         }
        
        return DeviceList().deviceInfo[identifier] ?? identifier
    }
    
    /// - returns: String for Screen Size.
    ///
    /// ie: let ScreenAspect:String = UIDevice.current.modelScreen().AspectRatio
    ///
    func modelScreen() -> (name:String?,size:Float?,res:[String]?,parallax:[String]?,aspectRatio:String?) {
        let Model:String = UIDevice.current.modelName
        var name:String! = "n/a"
        var size:Float! = 0.0
        var res:[String]! = ["0","0"]
        var parallax:[String]! = ["0","0"]
        var aspectRatio:String! = "n/a"

        for info in DeviceList.screenInfo.all_Devices {
            let device = info["Model"] as? String

            if Model == device {
                name = device
                size = info["Size"] as? Float
                res = (info["Resolution"] as? String)?.components(separatedBy: ",")
                parallax = (info["Parallax"] as? String)?.components(separatedBy: ",")
                aspectRatio = info["AspectRatio"] as? String
                break
            }
        }
        
        return (name,size,res,parallax,aspectRatio)
    }
    
    /// - returns: String for Disk free space.
    ///
    /// ie: let Free:String = UIDevice.current.diskFreeSpace
    ///
    var diskFreeSpace: String {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last ?? "") {
            let freeSize:UInt64 = ((systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.uint64Value)!

            return sharedFunc.STRINGS().returnFormattedBytes(bytes: freeSize, style: .file)
        }
        return "N/A"
    }
    
    /// - returns: String for Disk Total space.
    ///
    /// ie: let Total:String = UIDevice.current.diskTotalSpace
    ///
    var diskTotalSpace: String {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last ?? "") {
            let totalSize:UInt64 = ((systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.uint64Value)!

            return sharedFunc.STRINGS().returnFormattedBytes(bytes: totalSize, style: .file)
        }
        
        return "N/A"
    }
    
    /// - returns: String for Disk Used space.
    ///
    /// ie: let Used:String = UIDevice.current.diskUsedSpace
    ///
    var diskUsedSpace: String {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last ?? "") {
            let totalSize:UInt64 = ((systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.uint64Value)!
            let freeSize:UInt64 = ((systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.uint64Value)!
            let used:UInt64 = (totalSize - freeSize)
            
            return sharedFunc.STRINGS().returnFormattedBytes(bytes: used, style: .file)
        }

        return "N/A"
    }
    
    /// - returns: String for Memory Total space.
    ///
    /// ie: let Total:String = UIDevice.current.memoryTotal
    ///
    var memoryTotal: String {
        let totalSize:UInt64 = ProcessInfo.processInfo.physicalMemory
        
        return sharedFunc.STRINGS().returnFormattedBytes(bytes: totalSize, style: .memory)
    }
    
    /// - returns: String for Memory Used space.
    ///
    /// ie: let Used:String = UIDevice.current.memoryUsed
    ///
    var memoryBytes:UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }

        if isSim {
            let msg = (kerr == KERN_SUCCESS)
                ?"Memory in use (in bytes): \(info.resident_size)"
                :"Error with task_info(): " + (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error")
            print(msg)
        }
        
        return info.resident_size
    }
    
    var memoryUsed:String {
        return sharedFunc.STRINGS().returnFormattedBytes(bytes: memoryBytes, style: .memory)
    }
    
    /// - returns: String for Memory Free space.
    ///
    /// ie: let Free:String = UIDevice.current.memoryFree
    ///
    var memoryFree:String {
        let mem_total:UInt64 = (ProcessInfo.processInfo.physicalMemory as UInt64?)!
        let mem_used:UInt64 = memoryBytes
        let mem_free:UInt64 = mem_total - mem_used

        return sharedFunc.STRINGS().returnFormattedBytes(bytes: mem_free, style: .memory)
    }
        
    /// - returns: Int for Number of processors on UIDevice.
    ///
    /// ie: let NumProcessors:String = UIDevice.current.numProcessors
    ///
    var numProcessors:Int {
        return ProcessInfo.processInfo.activeProcessorCount
    }
    
    /// - returns: OS System Version String.
    ///
    /// ie: let Ver:String = UIDevice.current.OSVersionString
    ///
    var OSVersionString: String {
        let Major = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
        let Minor = ProcessInfo.processInfo.operatingSystemVersion.minorVersion
        let Build = ProcessInfo.processInfo.operatingSystemVersion.patchVersion
        return "\(Major).\(Minor).\(Build)"
    }
}

// MARK: -
public extension UIFont {
    /// - returns: CGSize of label needed to fit string
    func sizeOfString(string: String, constrainedToWidth width: CGFloat) -> CGSize {
        let size:CGSize! = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let newSize:CGSize! = NSString(string: string).boundingRect(with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self],
            context: nil).size
        
        return newSize
    }
}

// MARK: - INT Random Functions
public func arc4random<T: ExpressibleByIntegerLiteral>(_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, MemoryLayout<T>.size)
    return r
}

public extension UInt32 {
    static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

public extension Int32 {
    static func random(lower: Int32 = min, upper: Int32 = max) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

public extension Int64 {
    static func random(lower: Int64 = min, upper: Int64 = max) -> Int64 {
        var rnd:Int64 = 0
        arc4random_buf(&rnd, MemoryLayout.size(ofValue: rnd))

        return rnd % upper
    }
}

public extension UInt64 {
    static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random(UInt64.self)
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random(UInt64.self)
        }
        
        return (r % u) + lower
    }
}

public extension UInt {
    static func random(lower: UInt = min, upper: UInt = max) -> UInt {
        switch (_wordSize) {
            case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
            case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
            default: return lower
        }
    }
}

public extension Int {
    init(bool: Bool) {
        self = bool ? 1 : 0
    }
    
    static func random(lower: Int = min, upper: Int = max) -> Int {
        switch (_wordSize) {
            case 32: return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
            case 64: return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
            default: return lower
        }
    }
}

// MARK: -
public extension UIImage{
    var isSquare:Bool {
        return (self.size.height == self.size.width)
    }
    
    var isPortrait:Bool {
        return (self.size.height > self.size.width)
    }
    
    var isLandscape:Bool {
        return (self.size.height < self.size.width)
    }
    
    enum flipRotationOptions:Int { case flipOnVerticalAxis, flipOnHorizontalAxis }
    
    func rotated(by rotationAngle: Measurement<UnitAngle>, options: [flipRotationOptions]? = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)
            
            let x = (options?.contains(.flipOnVerticalAxis))! ? -1.0 : 1.0
            let y = (options?.contains(.flipOnHorizontalAxis))! ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
    
    func rotatedByDegrees(degrees:CGFloat) -> UIImage {
        /* calculate the size of the rotated view's containing box for our drawing space */
        let t = CGAffineTransform(rotationAngle: degrees.degreesToRadians)
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
            rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        /* Create the bitmap context */
        UIGraphicsBeginImageContext(rotatedSize)
            let bitmap = UIGraphicsGetCurrentContext()
                /* Move the origin to the middle of the image so we will rotate and scale around the center. */
                bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
                /* Rotate the image context */
                bitmap!.rotate(by: degrees.degreesToRadians)
                /* draw the rotated/scaled image into the context */
                bitmap!.scaleBy(x: 1.0, y: -1.0)
                bitmap!.draw(cgImage!, in: CGRect(x: (-size.width / 2),
                                                  y: (-size.height / 2),
                                              width: size.width,
                                             height: size.height))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
        
    func fixImageOrientation() -> UIImage? {
        var flip:Bool = false //used to see if the image is mirrored
        var isRotatedBy90:Bool = false // used to check whether aspect ratio is to be changed or not
        
        var transform = CGAffineTransform.identity
        
        //check current orientation of original image
        switch self.imageOrientation {
            case .down, .downMirrored:
                transform = transform.rotated(by: CGFloat(Double.pi))
            case .left, .leftMirrored:
                transform = transform.rotated(by: CGFloat(Double.pi / 2))
                isRotatedBy90 = true
            case .right, .rightMirrored:
                transform = transform.rotated(by: CGFloat(-(Double.pi / 2)))
                isRotatedBy90 = true
            case .up, .upMirrored:
                break
            @unknown default:()
        }
        
        switch self.imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: self.size.width, y: 0)
                flip = true
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: self.size.height, y: 0)
                flip = true
            default:
                break
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: size))
            rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if (flip) {
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        //check if we have to fix the aspect ratio
        if isRotatedBy90 {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.height,height: size.width))
        } else {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width,height: size.height))
        }
        
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage
    }
    
    func alpha(value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resize(toSize:CGSize, ignoreScale:Bool, save:Bool? = false, fileName:String? = "savedImage") -> UIImage {
        var resizedImage:UIImage
        var rectResize = toSize
        let imgToResize = self
        
        if rectResize.height > 0 {
            let scale:CGFloat = ignoreScale ?1.0 :UIScreen.main.scale
            
            rectResize = CGSize(width: rectResize.width * scale,height: rectResize.height * scale)
            
            UIGraphicsBeginImageContext(rectResize)
                imgToResize.draw(in: CGRect(x:0,y:0,width:rectResize.width,height:rectResize.height))
                resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }else{
            resizedImage = UIImage()
        }
        
        if save! && !fileName!.isEmpty {
            do {
                let fileURL = try! FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false
                    ).appendingPathComponent(fileName!)

                try resizedImage.pngData()?.write(to: fileURL, options: .atomic)
            } catch {
                sharedFunc.ALERT().show(
                    title:"IMAGE_SaveError_Title".localizedCAS(),
                    style:.error,
                    msg:"IMAGE_SaveError_Msg".localizedCAS() + "\(String(describing: fileName))'."
                )
            }
        }
        
        return resizedImage
    }
}


// MARK: -
@IBDesignable class IBLabel:UILabel {
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

extension IBLabel {
    @IBInspectable
    var Inset_L: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var Inset_R: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var Inset_T: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var Inset_B: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

public extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }

    @IBInspectable var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
        
        
    }
    
    func isTruncated() -> Bool {
        if let string = self.text {
            let boundingSize = CGSize(width: self.frame.size.width,height: CGFloat.greatestFiniteMagnitude)
            
            let size:CGSize = (string as NSString).boundingRect(with: boundingSize,
                                                             options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                             attributes: [NSAttributedString.Key.font: self.font!],
                                                             context: nil).size
            
            let newHt = size.height
            let lblHt = self.bounds.size.height
            
            return (newHt > lblHt)
        }
        
        return false
    }
    
    /** - note: Follow the list below to use this properly.
     1. Setup new UILabel for virtual sizing.
     2. Set label text to desired string.
     3. Set label font & desired size.
     4. Call this function which will iterate string, removing 1 characer at a time until it fits.
    */
    /// - returns: Tuple of the string length and truncated string.
    func charsThatWillFit() -> (maxChars:Int,maxString:String,truncatedChars:Int,truncatedString:String) {
        if var string = self.text {
            /* Does string fit in label? */
            if isTruncated().isFalse {
                /* Return all full string info */
                return (string.length,string,string.length,string)
            }else{
                /* Repeatedly shorten string 1 character at a time until it fits */
                repeat {
                    string.remove(at: string.index(before: string.endIndex))
                    self.text = string
                } while isTruncated() && string.length > 0
            
                /* Return the string info that fits and also a truncated/formatted version with truncation elipse */
                let truncatedLength = string.length - 3
                if truncatedLength > 0 {
                    return (string.length,string,string.length - 3,"\(string[0..<truncatedLength])...")
                }else{
                    return (string.length,string,0,"")
                }
            }
        }
        
        /* Default - return failed formatting, as if label text had never been set. */
        return (0,"",0,"")
    }
}

// MARK: -
extension UISearchBar{
    var textField : UITextField{
        return self.value(forKey: "_searchField") as! UITextField
    }
}

// MARK: -
public extension UISegmentedControl {
    func setFontSize(fontSize:CGFloat,fontName:String?="HelveticaNeue",textColor:UIColor? = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)) {
        let normalTextAttributes: [AnyHashable: Any] = [
            NSAttributedString.Key.foregroundColor as NSObject: self.tintColor!,
            NSAttributedString.Key.font as NSObject: UIFont(name:fontName!,size:fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight:UIFont.Weight.regular)
        ]

        let boldTextAttributes: [AnyHashable: Any] = [
            NSAttributedString.Key.foregroundColor as NSObject : textColor!,
            NSAttributedString.Key.font as NSObject: UIFont(name:fontName!,size:fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight:UIFont.Weight.medium)
        ]

        self.setTitleTextAttributes(normalTextAttributes as? [NSAttributedString.Key : Any], for: .normal)
        self.setTitleTextAttributes(normalTextAttributes as? [NSAttributedString.Key : Any], for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes as? [NSAttributedString.Key : Any], for: .selected)
    }
}


// MARK: -
public extension UITableView {
    func registerCellClass(cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

// MARK: - UITextField
public extension UITextField {
    func setLeftPaddingPoints(amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// MARK: - UIView
public extension UIView {
    class func loadNib<T: UIView>(viewType: T.Type) -> T {
        let className = String.className(viewType as AnyClass)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    /// Round corner and color stroke border of a UIView class object.
    ///
    /// ie: sharedFunc.DRAW().roundCorner(view: vw, radius: 10.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 2.0)
    ///
    /// ie: sharedFunc.DRAW().roundCorner(view: lbl, radius: 10.0) replaces STROKE BORDER
    ///
    /// - parameter view: (UIView) View to round corner and optionally stroke border.
    /// - parameter radius: (CGFloat) Radius of corners.
    /// - parameter color: [Optional] (UIColor) Border color.
    /// - parameter width: [Optional] (Float) Border width.
    /// - returns: (UIView) View with corners rounded and optionally borders stroked in color.
    func roundCorners(radius:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius  = radius
    }
    
    /// Color stroke border of a UIView class object.
    ///
    /// - parameter view: (UIView) View to round corner and optionally stroke border.
    /// - parameter color: (UIColor) Border color.
    /// - parameter width: (Float) Border width.
    /// - returns: (UIView) View with stroke added.
    func border(color:UIColor,width:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    func removeBorder() {
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
    }
}

// MARK: - UIVIEWCONTROLLER
extension UIViewController {
    func sizeClass() -> (w:UIUserInterfaceSizeClass, h:UIUserInterfaceSizeClass) {
        return (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
    }
}

// MARK: - Saving UIColor to UserDefaults
extension UserDefaults {
    func allKeys() {
        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }

    func allKeysAndValues() {
        print(UserDefaults.standard.dictionaryRepresentation())
    }

    func setColor(value: UIColor?, forKey: String) {
        guard let value = value else {
            set(nil, forKey:  forKey)
            return
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            set(data, forKey: forKey)
        } catch {
            set(nil, forKey:  forKey)
        }
    }
    
    func color(forKey key:String) -> UIColor? {
        do {
            if let data = UserDefaults.standard.data(forKey: key) {
                let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
                return color
            }
        } catch {
            if isSimDevice { simPrint().info("\( error )", function: #function, line: #line)}
        }

        return nil
    }
}

// MARK: -

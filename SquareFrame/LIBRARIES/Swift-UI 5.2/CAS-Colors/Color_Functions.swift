/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    File: Color_Functions.swift
  Author: Kevin Messina
 Created: Jul 22, 2019
Modified: Feb 3, 2020

©2019-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import UIKit
import SwiftUI

struct colorArrayStruct {
    var id:Int!
    var name:String!
    var color:UIColor!

    init(
        id:Int,
        name:String = "",
        color:UIColor
    ) {
        self.id = id
        self.name = name
        self.color = color
    }
}

struct colorStruct {
    var name:String!
    var color:UIColor!
    var hex:String!

    init(
        name:String = "",
        color:UIColor = .white,
        hex:String = ""
    ) {
        self.name = name
        self.color = color
        self.hex = hex
    }
}

@available(iOS 13.0, *) protocol colorLoopable {
    var allProperties: [String: Any] { get }
}

@available(iOS 13.0, *) extension colorLoopable {
    var allProperties: [String: Any] {
        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }
        return result
    }
}

@available(iOS 13.0, *) extension Color {
    func uiColor() -> UIColor {
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

extension UIColor {
    /// Converts a UIColor to SwiftUI Color type
    @available(iOS 13.0, *) var toColor:Color {
        Color(
            red: Double(self.cgColor.components![0]),
            green: Double(self.cgColor.components![1]),
            blue: Double(self.cgColor.components![2])
        )
    }
    
    /// Returns a UIColor from RGBA CSV String
    /// - Parameter CSV: Comma separated R,G,B,A values
    func convertFromRGBA(CSV:String) -> UIColor {
        let arrRGBA = CSV.components(separatedBy: ",")

        if arrRGBA.count == 4 {
            let red:CGFloat = CGFloat(Float(arrRGBA[0])! / 255)
            let green:CGFloat = CGFloat(Float(arrRGBA[1])! / 255)
            let blue:CGFloat = CGFloat(Float(arrRGBA[2])! / 255)
            let alpha:CGFloat = CGFloat(Float(arrRGBA[3])!)

            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }

        return .black
    }

    /// Deprecated, use convertFromRGBA
    func returnUIColorFromRGBA_String(RGBA:AnyObject) -> UIColor {
        if let RGBA_String = RGBA as? String {
            let arrRGBA = RGBA_String.components(separatedBy: ",")

            let red:CGFloat = CGFloat(Float(arrRGBA[0])! / 255)
            let green:CGFloat = CGFloat(Float(arrRGBA[1])! / 255)
            let blue:CGFloat = CGFloat(Float(arrRGBA[2])! / 255)
            let alpha:CGFloat = CGFloat(Float(arrRGBA[3])!)

            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }

        return .black
    }
    
    /// Returns a UIColor from a string common name matching Apple Crayon Color struct(s).
    ///
    /// NOTE: This can be helpful when searching struct based on a string stored in a param or
    /// database field.
    /// - Parameter searchFor: Common name of color, such as lead or licorice
    func fromName(_ searchFor:String) -> UIColor {
        let selectedCrayon:UIColor = UIColor.Apple.dict.object(forKey: searchFor) as? UIColor ?? .black
        
        return selectedCrayon
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }

    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = String(hex[hex.startIndex..<hex.index(hex.startIndex, offsetBy: 1)])
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt64 = 0x0
        scanner.scanHexInt64(&hexInt)
        
        var r:UInt64!, g:UInt64!, b:UInt64!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }

    func convertToUInt() -> UInt {
        var colorAsUInt:UInt = 0
        
        let red = UInt(self.rgbComponents.red * 255.0) << 16
        let green = UInt(self.rgbComponents.green * 255.0) << 8
        let blue = UInt(self.rgbComponents.blue * 255.0)
        
        colorAsUInt += red + green + blue
        
        return colorAsUInt
    }

    typealias RGBComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    typealias HSBComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

    var rgbComponents:RGBComponents {
        var c:RGBComponents = (0,0,0,0)

        if getRed(&c.red, green: &c.green, blue: &c.blue, alpha: &c.alpha) {
            return c
        }

        return (0,0,0,0)
    }

    var cssRGBA:String {
        return String(format: "rgba(%d,%d,%d, %.02f)", Int(rgbComponents.red * 255),
                                                       Int(rgbComponents.green * 255),
                                                       Int(rgbComponents.blue * 255),
                                                       Float(rgbComponents.alpha))
    }

    var hexRGB:String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255),
                                               Int(rgbComponents.green * 255),
                                               Int(rgbComponents.blue * 255))
    }

    var hexRGBA:String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255),
                                                   Int(rgbComponents.green * 255),
                                                   Int(rgbComponents.blue * 255),
                                                   Int(rgbComponents.alpha * 255) )
    }

    var hsbComponents:HSBComponents {
        var c:HSBComponents = (0,0,0,0)

        if getHue(&c.hue, saturation: &c.saturation, brightness: &c.brightness, alpha: &c.alpha) {
            return c
        }

        return (0,0,0,0)
    }
    
    func isLight() -> Bool {
        let components = self.cgColor.components
        let red = ((components?[0])! * 299)
        let green = ((components?[1])! * 587)
        let blue = ((components?[2])! * 114)
        
        let brightness = (red + green + blue) / 1000
        let isLightColor:Bool = (brightness > 0.5)

        return isLightColor
    }
    
    func returnIndexForColorName(grouping:String,name:String) -> Int {
        let query:NSPredicate! = NSPredicate(format: "SELF.Name ==%@", name)
        var arrCrayon:NSArray!

        switch grouping.lowercased() {
        case "crayon": arrCrayon = UIColor.Apple.arr.filtered(using: query) as NSArray?
        case "alert" : arrCrayon = UIColor.Alert.arr.filtered(using: query) as NSArray?
        case "apple" : arrCrayon = UIColor.Apple.arr.filtered(using: query) as NSArray?
        case "controls" : arrCrayon = UIColor.Controls.arr.filtered(using: query) as NSArray?
        case "fdp" : arrCrayon = UIColor.FDP.Greens.arr.filtered(using: query) as NSArray?
        case "tcp" : arrCrayon = UIColor.TCP.arr.filtered(using: query) as NSArray?
        case "tmg" : arrCrayon = UIColor.TMG.arr.filtered(using: query) as NSArray?
        default: ()
        }
        
        if arrCrayon.count > 0 {
            let dictCrayon:NSDictionary = arrCrayon.firstObject as! NSDictionary
            let index = dictCrayon.object(forKey: "Idx") as? Int ?? 0
            return index
        }
        
        return 0
    }
    
    func returnColorForName(grouping:String,name:String) -> UIColor {
        var found:UIColor!
        
        switch grouping.lowercased() {
            case "crayon": found = UIColor.Crayon.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "alert" : found = UIColor.Alert.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "apple" : found = UIColor.Apple.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "controls" : found = UIColor.Controls.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "fdp" : found = FDP.Greens.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "tcp" : found = TCP.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "tmg" : found = TMG.dict.object(forKey: name) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            default: ()
        }
        
        return (found != nil) ?found :.clear
    }
}



/*--------------------------------------------------------------------------------------------------------------------------
   File: Globals.swift
 Author: Kevin Messina
Created: April 12, 2017

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit

/// *** GLOBAL CONSTANT STRUCTS & ENUMS ***
// Standard app integrations
var gBundle:UIStoryboard! = UIStoryboard.init(name: "Main", bundle: nil)
var gSender = SENDER_INFO()
var gAppLanguageCode:String = "en"
var gAppLanguage:String = "English"
var gAppEdition:String! = appInfo().getEdition()
var gAppID:String = appInfo().getEdition()

// Std fonts
struct std_APPFONTS {
    let PDFTitles            = UIFont(name: Font.Avenir.Book.regular, size: 24)
    let PDFInfo              = UIFont(name: Font.Avenir.Light.regular, size: 18)
    let screenTitles         = UIFont(name: Font.Avenir.regular, size: 24)
    let menuTitles           = UIFont(name: Font.Avenir.regular, size: 18)
    let buttonTitles         = UIFont(name: Font.Avenir.regular, size: 14)
    let buttonTitles_Large   = UIFont(name: Font.Avenir.regular, size: 18)
    let barButtonTitles      = UIFont(name: Font.Avenir.regular, size: 14)
    let navBarTitles         = UIFont(name: Font.Avenir.Light.regular, size: 14)
    let text_Reg             = UIFont(name: Font.Avenir.regular, size: 14)
    let text_Light           = UIFont(name: Font.Avenir.Light.regular, size: 14)
    let text_Bold            = UIFont(name: Font.Avenir.Medium.regular, size: 14)
    let text_Thin            = UIFont(name: Font.Avenir.Light.regular, size: 14)
}

// Editing
let tab = "\t"
let newLine = "\n" // aka lf or Line Feed
let cr = "\r" 
let csv = ","

// Devices
let isSim:Bool = ((TARGET_IPHONE_SIMULATOR == 1) && showSimMsgs.isTrue)
let isSimDevice:Bool = (TARGET_IPHONE_SIMULATOR == 1)
let isAdhoc:Bool = sharedFunc.APP().isAdhocMode()
let isPad:Bool = (UIDevice.current.userInterfaceIdiom == .pad)
//let isPad:Bool = DeviceType.IS_IPAD
let isPhone:Bool = (UIDevice.current.userInterfaceIdiom == .phone)
//let isPhone:Bool = DeviceType.IS_IPHONE
let isTV:Bool = DeviceType.IS_TV
let isCar:Bool = DeviceType.IS_CAR_PLAY

var showSimMsgs:Bool = true
var isBetaTest:Bool = false 
var alert_ShowAsAppleStandard:Bool = false
var horizontalClass:UIUserInterfaceSizeClass!
var verticalClass:UIUserInterfaceSizeClass!

// Network
var kSimulateNoInternet:Bool = false // TODO: 🍎APPSTORE: Make False for Production.

// App Rating
public struct appRating {
    let runIncrementerSetting:String = "numberOfRuns"  // UserDefauls dictionary key where we store number of runs
    let minimumRunCount:Int = 5 // Minimum number of runs that we should have until we ask for review
}

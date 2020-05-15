/*--------------------------------------------------------------------------------------------------------------------------
    File: waitHUD.swift
  Author: Kevin Messina
 Created: December 22, 2016
 
 ©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES: Converted to Swift 3.0 on September 16, 2016.
        Uses CocoaPod for https://github.com/rjeprasad/RappleProgressHUD
 --------------------------------------------------------------------------------------------------------------------------*/

import RappleProgressHUD

public let RappleAttribs:[String:AnyObject] = [
    RappleTintColorKey: #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1),
    RappleIndicatorStyleKey: RappleStyleCircle as AnyObject,
    RappleScreenBGColorKey: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.75),
    RappleProgressBGColorKey: #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1),
    RappleProgressBarColorKey: #colorLiteral(red: 0.5601567626, green: 0.5578907132, blue: 0.5808923841, alpha: 1),
    RappleProgressBarFillColorKey: #colorLiteral(red: 0.2994727492, green: 0.8526373506, blue: 0.3907377124, alpha: 1)
]

/// Functions that relate to RappleHUD
@objc(waitHUD) class waitHUD:NSObject {
    var Version:String { return "2.02" }

    /// Displays a Rapple Wait Indicator view with message
    func isShowing() -> Bool { return RappleActivityIndicatorView.isVisible() }

    func show(msg:String? = "WAIT_PLEASE_WAIT".localizedCAS()) -> Void {
        RappleActivityIndicatorView.startAnimatingWithLabel(msg!, attributes: RappleAttribs)
    }
    
    func showNow(msg:String? = "WAIT_PLEASE_WAIT".localizedCAS()) -> Void {
        DispatchQueue.main.async {
            if RappleActivityIndicatorView.isVisible() {
                RappleActivityIndicatorView.stopAnimation()
            }
            RappleActivityIndicatorView.startAnimatingWithLabel(msg!, attributes: RappleAttribs)
        }
    }
    
    func hide() -> Void {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func hideNow() -> Void {
        DispatchQueue.main.async {
            RappleActivityIndicatorView.stopAnimation()
        }
    }
    
    func hideWithMsg(status:RappleCompletion? = .success,msg:String? = "Done".localizedCAS(),showFor seconds:TimeInterval? = 5.0) -> Void {
        RappleActivityIndicatorView.stopAnimation(
            completionIndicator: status!,
            completionLabel: msg!,
            completionTimeout: seconds!
        )
    }
    
    func hideWithMsgNow(status:RappleCompletion? = .success,msg:String? = "Done".localizedCAS(),showFor seconds:TimeInterval? = 5.0) -> Void {
        DispatchQueue.main.async {
            RappleActivityIndicatorView.stopAnimation(
                completionIndicator: status!,
                completionLabel: msg!,
                completionTimeout: seconds!
            )
        }
    }
    
    func updateProgress(progress:CGFloat, msg:String) -> Void {
        RappleActivityIndicatorView.setProgress(progress, textValue: msg)
    }

    func updateProgressNow(progress:CGFloat, msg:String) -> Void {
        DispatchQueue.main.async {
            RappleActivityIndicatorView.setProgress(progress, textValue: msg)
        }
    }

    func update(msg:String) -> Void {
        RappleActivityIndicatorView.startAnimatingWithLabel(msg, attributes: RappleAttribs)
    }

    func updateNow(msg:String) -> Void {
        DispatchQueue.main.async {
            RappleActivityIndicatorView.startAnimatingWithLabel(msg, attributes: RappleAttribs)
        }
    }
}

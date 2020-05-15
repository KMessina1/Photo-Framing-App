/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_Share.swift
 Author: Kevin Messina
Created: June 04, 2017

©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import MessageUI
import Social
import StoreKit

// MARK: - *** GLOBAL CONSTANTS ***

class VC_Share:
    UIViewController,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    SKStoreProductViewControllerDelegate
    {
    
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }
    

// MARK: - *** ACTIONS ***
    @IBAction func done(_ sender:UIButton){
        self.dismiss(animated: true)
    }
    
    @IBAction func clipboardCopy(_ sender:UIButton){
        let msg:String = "\("Share_Copy_Msg1".localized())\n\n\(appInfo.EDITION.appStore.URL!)" +
                         "\("Share_Copy_Msg2".localized())\n\n\(appInfo.EDITION.appStore.ext_URL!)" +
                         "\("Share_Copy_Msg3".localized())"
        
        /* Copy to pasteboard */
        UIPasteboard.general.string = msg

        sharedFunc.ALERT().show(
            title:"SocialMedia_Thanks_Title".localizedCAS(),
            style:.error,
            msg:"SocialMedia_Thanks_Copied".localizedCAS()
        )
    }

    @IBAction func email(_ sender:UIButton){
        if MFMailComposeViewController.canSendMail().isFalse {
            sharedFunc.ALERT().show(
                title:"NotAvailable_Mail_Title".localizedCAS(),
                style:.error,
                msg:"NotAvailable_Mail_Msg".localizedCAS()
            )
            return
        }else if isSim.isTrue {
            sharedFunc.ALERT().showSimulatorMsg()
            return
        }

        let msg:String = "\("Share_Mail_Msg1".localized())<br><br><a href=\"\(appInfo.EDITION.appStore.URL!)\">" +
                         "\("Share_Mail_Msg2".localized())</a><br><br><a href=\"\(appInfo.EDITION.appStore.ext_URL!)\">" +
                         "\("Share_Mail_Msg3".localized())</a>"

        sharedFunc.MAIL().eMailWithAttachment(
            delegate: self,
            viewController: self,
            sendTo: [],
            subject: "Share_Mail_Subject".localized(),
            message: msg
        )
    }
    
    @IBAction func SMS(_ sender:UIButton){
        if MFMessageComposeViewController.canSendText().isFalse {
            sharedFunc.ALERT().show(
                title:"NotAvailable_SMS_Title".localizedCAS(),
                style:.error,
                msg:"NotAvailable_SMS_Msg".localizedCAS()
            )
            return
        }else if isSim.isTrue {
            sharedFunc.ALERT().showSimulatorMsg()
            return
        }
        
        var msg = "Share_SMS_Msg1".localized()
            msg += "\n\n" + "Share_SMS_Msg2".localized()
            msg += "\n\n\(appInfo.EDITION.appStore.URL!)"

        let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = []
            composeVC.body = msg
        
        /* Present the view controller modally. */
        self.present(composeVC, animated: true)
    }
    
    
// MARK: - *** NOTIFICATIONS ***

    
// MARK: - *** MAILCOMPOSER ***
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        sharedFunc.MAIL().uponCompletion(controller: controller, result: result, showMsg:false, error: error as NSError?)

        var title:String = ""
        var msg:String = ""
        
        if let resultCode =  MFMailComposeResult(rawValue: result.rawValue) {  switch resultCode {
            case .sent:
                title = "SocialMedia_Thanks_Title".localizedCAS()
                msg = "SocialMedia_Thanks_Msg".localizedCAS()
            case .cancelled:
                title = "EMAIL_Cancelled_Title".localizedCAS()
                msg = "EMAIL_Cancelled_Msg".localizedCAS()
            case .failed:
                title = "EMAIL_ComposeError_Title".localizedCAS()
                msg = "EMAIL_ComposeError_Msg".localizedCAS()
            case .saved: ()
            @unknown default: ()
            }
        }
        
        if title.isNotEmpty {
            sharedFunc.ALERT().show(title: title,style:.error,msg: msg,delay: 1.0)
        }

        controller.dismiss(animated: true)
    }
    
    
// MARK: - *** MESSAGING ***
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
            case .cancelled,.failed: ()
            case .sent:
                sharedFunc.ALERT().show(
                    title:"SocialMedia_Thanks_Title".localizedCAS(),
                    style:.error,
                    msg:"SocialMedia_Thanks_Msg".localizedCAS(),
                    delay: 1.0
                )
        @unknown default: ()
        }
        
        controller.dismiss(animated: true)
    }
    
    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return false }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        sharedFunc.DRAW().roundCorner(view: vw_Container, radius:10,color: gAppColor, width:3)
        
        btn_Done.setImage(#imageLiteral(resourceName: "Close").recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), for: .normal)
        btn_Email.setImage(#imageLiteral(resourceName: "SocialMedia_Email").recolor(gAppColor), for: .normal)
        btn_SMS.setImage(#imageLiteral(resourceName: "SocialMedia_SMS").recolor(gAppColor), for: .normal)
        btn_Copy.setImage(#imageLiteral(resourceName: "SocialMedia_Copy").recolor(gAppColor), for: .normal)

        lbl_Title.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        lbl_Blurb.textColor = gAppColor
        vw_Header.backgroundColor = gAppColor
        stackShare.tintColor = gAppColor

        /* Set fonts */
        lbl_Title.font = font_Title
        lbl_Blurb.font = font_Text 
        
        /* Localization */
        lbl_Title.text = "Share_Title".localized()
        lbl_Blurb.text = "Share_Blurb".localized()
        
        /* Data */
        appLogo = appLogo.resize(toSize: CGSize(width:154,height:31), ignoreScale: true)
        appLogoData = appLogo.pngData()!

        /* Notifications */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Appearance */
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: blurStyle)
    }
    

// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var btn_Done:UIButton!
    @IBOutlet var btn_Email:UIButton!
    @IBOutlet var btn_SMS:UIButton!
    @IBOutlet var btn_Copy:UIButton!
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var vw_Container:UIView!
    @IBOutlet var lbl_Title:UILabel!
    @IBOutlet var lbl_Blurb:UILabel!
    @IBOutlet weak var stackShare: UIStackView!
    
// MARK: ├─➤ *** DECLARATIONS (Variables)
    var appLogo:UIImage = #imageLiteral(resourceName: "SMS_AppLogo")
    var appLogoData:Data = Data.init()
    
// MARK: - *** DECLARATIONS (Presenting VC Parameters) ***
    var font_Title:UIFont = UIFont.systemFont(ofSize: 24)
    var font_Text:UIFont = UIFont.systemFont(ofSize: 16)
    var blurStyle:UIBlurEffect.Style! = .light
    
// MARK: ├─➤ DECLARATIONS (Cell Reuse Identifiers)
}

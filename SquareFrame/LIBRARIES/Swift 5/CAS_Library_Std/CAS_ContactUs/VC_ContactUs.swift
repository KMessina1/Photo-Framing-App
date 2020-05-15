/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_ContactUs.swift
 Author: Kevin Messina
Created: November 23, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

import MessageUI

// MARK: - *** CLASS DEFINITIONS ***
class VC_ContactUs:
    UIViewController,
    MFMailComposeViewControllerDelegate,
    UIPopoverPresentationControllerDelegate
{
    var Version:String! { return "2.03" }

    
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }
    
    
// MARK: - *** ACTIONS ***
    @IBAction func contactUs(_ sender:UIButton) -> Void {
        let actSheet = sharedFunc.actSheet().setup(vc: self,title: "EMAIL OPTIONS")

// MARK: ├─➤ Customer Support
        var title = (gAppLanguageCode == "en") ?"Customer Support" :"Atención al Cliente"
    
        actSheet.addAction(UIAlertAction(title:title, style:.default, handler:{ action in
            sharedFunc.MAIL().contactUs_Plain(delegate:self,viewController:self)
        }))

// MARK: ├─➤ Technical Support
        title = (gAppLanguageCode == "en") ?"Technical Support" :"Soporte Técnico"
        actSheet.addAction(UIAlertAction(title:title, style:.default, handler:{ action in
            sharedFunc.MAIL().contactUs(delegate:self,viewController:self,titleColor:"DarkCyan",bannerColor:"DarkCyan")
        }))
    
        present(actSheet, animated:true)
    }

    @IBAction func web(_ sender:UIButton) {
        if appInfo.COMPANY.WEBSITE_URLS.company.isNotEmpty {
            if sharedFunc.NETWORK().displayMsgIfNotAvailable() {
                guard let websiteURL = URL(string: appInfo.COMPANY.WEBSITE_URLS.company)
                else{ return }
                
                UIApplication.shared.open(websiteURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                    if isSim { print("Open url '\(websiteURL)': \(success)") }
                })
            }
        }
    }

    @IBAction func close(_ sender:UIButton) {
        self.dismiss(animated: true)
    }
    
    
// MARK: - *** GESTURES ***
    @objc func tap_Email(_ sender:UITapGestureRecognizer){
        contactUs(btn_Mail)
    }

    @objc func tap_Web(_ sender:UITapGestureRecognizer){
        web(btn_Web)
    }
    
    
// MARK: - *** MAILCOMPOSER ***
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        sharedFunc.MAIL().uponCompletion(controller: controller, result: result, error: error)
        self.dismiss(animated: true)
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
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: blurStyle)

        sharedFunc.DRAW().roundCorner(view: vw_ContactUs, radius:10,color: gAppColor, width:3)
        sharedFunc.DRAW().roundCorner(view: btn_Mail, radius: isPad.isTrue ?37 :25, color: gAppColor, width:2)
        sharedFunc.DRAW().roundCorner(view: btn_Web, radius: isPad.isTrue ?37 :25, color: gAppColor, width:2)
        sharedFunc.DRAW().addShadow(view: btn_Mail, offset: 2, radius: 3, opacity: 0.33)
        sharedFunc.DRAW().addShadow(view: btn_Web, offset: 2, radius: 3, opacity: 0.33)

        btn_Mail.setImage(#imageLiteral(resourceName: "Email").recolor(gAppColor), for: .normal)
        btn_Web.setImage(#imageLiteral(resourceName: "WebsiteUnselected").recolor(gAppColor), for: .normal)
        btn_Done.setImage(btn_Done.image(for: .normal)?.recolor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), for: .normal)
        lbl_Title.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        vw_Header.backgroundColor = gAppColor

        /* Gestures */
        lbl_Web.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "tap_Web:", delegate: self, numTaps: 1))
        lbl_Email.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "tap_Email:", delegate: self, numTaps: 1))
    
        /* Localization */
        lbl_Email.text = "ContactUs_Email".localizedCAS()
        lbl_Web.text = "ContactUs_Website".localizedCAS()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        vw_ContactUs.isOpaque = false
        vw_ContactUs.backgroundColor = .clear
        sharedFunc.IMAGE().addBlurEffect(view: vw_ContactUs, style: .extraLight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        /* Appearance */

        /* Set fonts */
        lbl_Title.font = font_Title ?? UIFont.systemFont(ofSize: 24)
        lbl_Email.font = font_Text ?? UIFont.systemFont(ofSize: 16)
        lbl_Web.font = font_Text ?? UIFont.systemFont(ofSize: 16)
        
        lbl_Title.text = "ContactUs".localizedCAS()
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var btn_Done:UIButton!
    @IBOutlet var btn_Mail:UIButton!
    @IBOutlet var btn_Web:UIButton!
    @IBOutlet var vw_Header:UIView!
    @IBOutlet var vw_ContactUs:UIView!
    @IBOutlet var lbl_Email:UILabel!
    @IBOutlet var lbl_Web:UILabel!
    @IBOutlet var lbl_Title:UILabel!

// MARK: - *** DECLARATIONS (Variables) ***
    
// MARK: - *** DECLARATIONS (Presenting VC Parameters) ***
    var font_Title:UIFont!
    var font_Text:UIFont!
    var blurStyle:UIBlurEffect.Style! = .light
    
// MARK: - *** DECLARATIONS (Reusable Cells) ***
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_GiftMessage.swift
  Author: Kevin Messina
 Created: Sep 4, 2016
Modified: Apr 28, 2018

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_GiftMessage:
    UIViewController,
    UIPopoverPresentationControllerDelegate,
    UITextViewDelegate
{
    
    // MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller:UIPresentationController,traitCollection:UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    // MARK: - *** ACTIONS ***
    @IBAction func done(_ sender:UIButton){
        self.txt_Msg.resignFirstResponder()

        order.giftMessage = self.txt_Msg.text!

        NotificationCenter.default.post(name: Notification.Name("notification_updateGiftMsg"), object: self.txt_Msg.text!)

        self.dismiss(animated: true)
    }

    @IBAction func preview(_ sender: UIButton) {
        waitHUD().showNow(msg: "WAIT_PLEASE_WAIT".localizedCAS())

        let filename = appInfo.COMPANY.ORDERS.giftMsg!
        let fileNameAndPath = sharedFunc.FILES().dirDocuments(fileName: filename)
        order.giftMessage = txt_Msg.text

        sharedFunc.THREAD().doNow {
            PDF().setPaperSize(paperSize: PDF.PaperSizeFormat.Letter)
            PDF().createAtFilePath(fileNameAndPath: fileNameAndPath)
            pdf_GiftMessage().create(drawBorder: true, drawCropMarks: false, drawBackground: true, drawLogo: true)
            PDF().finish()
        }

        sharedFunc.THREAD().doAfterDelay(delay: 0.5, perform: {
            if sharedFunc.FILES().exists(filePathAndName: fileNameAndPath).isFalse {
                sharedFunc.ALERT().showFileNotFound(filename: filename)
            }else{
                guard
                    let fileURL = URL(fileURLWithPath: fileNameAndPath) as URL?
                else {
                    sharedFunc.ALERT().showFileNotFound(filename: filename)
                    return
                }

                simPrint().info("PDF PATH: \( fileURL )")
                simPrint().info("PDF FILE: \( filename )")
            
                waitHUD().showNow(msg: "Loading PDF...")
                let childVC = UIStoryboard(name:"PDFViewer",bundle:nil)
                    .instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                childVC.pdfURL = fileURL

                self.present(childVC, animated: false)
            }

            sharedFunc.THREAD().doAfterDelay(delay: 0.5, perform: {
                waitHUD().hide()
            })
        })
    }

    @IBAction func clear(_ sender: UIButton) {
        if txt_Msg.text.isNotEmpty {
            self.txt_Msg.resignFirstResponder()

            let alert = UIAlertController(title: "Clear Info".localizedCAS(),message: "Clear_Msg".localizedCAS(),preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel".localizedCAS(), style: .default) { (action) -> Void in
                self.txt_Msg.becomeFirstResponder()
            })

            alert.addAction(UIAlertAction(title: "Clear".localizedCAS(), style: .default) { (action) -> Void in
                self.txt_Msg.text = ""
                order.giftMessage = ""
                self.btn_Clear.isEnabled = false

                NotificationCenter.default.post(name: Notification.Name("notification_updateGiftMsg"), object: "")

                self.txt_Msg.becomeFirstResponder()
            })

            alert.actions.first?.setValue(APPTHEME.alert_ButtonDisabled, forKey: "titleTextColor")
            alert.actions.last?.setValue(APPTHEME.alert_ButtonEnabled, forKey: "titleTextColor")

            self.present(alert, animated: true)
        }
    }


// MARK: - *** TEXT VIEW METHODS ***
    func textViewDidChange(_ textView: UITextView) {
        somethingChanged = true

        btn_Clear.isEnabled = textView.text.isNotEmpty
    }


// MARK: - *** NOTIFICATIONS ***
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardHt = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
            else {
                return
        }

        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: keyboardHt + 15,right: 0)

        txt_Msg.contentInset = contentInsets
        txt_Msg.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        txt_Msg.contentInset = UIEdgeInsets.zero
        txt_Msg.scrollIndicatorInsets = UIEdgeInsets.zero
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
        txt_Msg.font = UIFont(name: "Optima-Regular", size: 18.0)!
        btn_Preview.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        btn_Preview.backgroundColor = gAppColor
        sharedFunc.DRAW().roundCorner(view: btn_Preview, radius: 5.0)
        btn_Clear.tintColor = gAppColor

        /* Localization */
        lbl_Title.text = "gift_msg".localizedCAS()
        btn_Preview.setTitle("Preview".localizedCAS(), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Appearance */
        txt_Msg.autocorrectionType = .no
        self.view.viewWithTag(123123)?.removeFromSuperview()
        txt_Msg.becomeFirstResponder()
        
        /* Load default information */
        txt_Msg.text = order.giftMessage
        btn_Done.setTitle("Done".localizedCAS(), for: .normal)
        btn_Clear.setTitle("Reset".localizedCAS(), for: .normal)
        btn_Clear.isEnabled = txt_Msg.text.isNotEmpty

        /* Notifications */
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Appearance */
        lbl_Title.textColor = gAppColor
        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)
        
        self.txt_Msg.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* Appearance */
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /* Notifications */
        let NC = NotificationCenter.default
        NC.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NC.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var vw_Topbar:UIView!
    @IBOutlet var divider:UILabel!
    @IBOutlet var btn_Done:UIButton!
    @IBOutlet var btn_Clear:UIButton!
    @IBOutlet var btn_Preview:UIButton!
    @IBOutlet var lbl_Title:UILabel!
    @IBOutlet var txt_Msg:UITextView!

    // MARK: - *** DECLARATIONS (Variables) ***
    var img_Gift:UIImageView!
    var somethingChanged:Bool = false
}


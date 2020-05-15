/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_PDFPreview.swift
 Author: Kevin Messina
Created: October 24, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Pass this class a UserDefault setting string named "PDF_AttachmentName" which will display.
       Set "PDF_AttachmentName" to "" if it is server based and embed the full URL into the UserDefault 
       "PDF_ServerBasedFilenameAndPath"
--------------------------------------------------------------------------------------------------------------------------*/

import MessageUI
import WebKit

class VC_PDFPreview:UIViewController,
                    WKNavigationDelegate,
                    UIPrintInteractionControllerDelegate,
                    UIPopoverPresentationControllerDelegate,
                    MFMailComposeViewControllerDelegate{
    
// MARK: - *** DEFINITIONS ***
    var Version:String { return "2.01" }
    
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func showFileNotFound() {
        webView.isHidden = true

        let title = "PDF_NotFound_Title".localizedCAS()
        let msg = "\(pdfFilename)\("PDF_NotFound_MsgWithFilename".localizedCAS())"
        sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
    }

    func downloadDocumentFromServer() {
        /* File Found? */
        let foundFile = sharedFunc.FILES().exists(filePathAndName: sharedFunc.FILES().dirDocuments(fileName: pdfFilename))
        if !foundFile {
            if self.isServerFile {
                if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }

                waitHUD().showNow(msg: "WAIT_DOWNLOADING".localizedCAS())
                
                let filename = self.pdfFilename
                #if TARGET_SF // Squareframe specific Apps.
                    let itemDetails = Products().returnComponentsFromPhotoFilename(filename: filename)
                    let orderFolder = itemDetails.orderNum
                    let filePath:String = "\(appInfo.COMPANY.SERVER.ordersFolder!)/\(orderFolder)/\(filename)".replaceCharsForHTML
                #else
                    let filePath:String = "\(appInfo.COMPANY.SERVER!)/\(filename)".replaceCharsForHTML
                #endif
                
                appFunc().downloadFile(downloadURL: filePath,renameTo: filename,callback: "notification_PDFViewer_documentDownloaded")
                return
            }else{
                self.showFileNotFound()
            }
        }else{
            switch shareActionSelected {
                case .print: sharedFunc.THREAD().doAfterDelay(delay: 0.1, perform: { self.printDocuments() })
                case .email: sharedFunc.THREAD().doAfterDelay(delay: 0.1, perform: { self.emailDocuments() })
                default: ()
            }
        }
    }
    
    func emailDocuments() {
        sharedFunc.MAIL().eMailWithAttachment(delegate: self,
                                        viewController: self,
                                                sendTo: self.pdfSendTo,
                                               subject: "SF Admin: \(self.pdfFilename)",
                                               message: "Sent from Squareframe Admininistratin App.",
                                attachmentFilenamePath: sharedFunc.FILES().dirDocuments(fileName: self.pdfFilename),
                                    attachmentMimeType: (pdfFileType.uppercased() == ".PDF") ?kMimeTypes.pdf :kMimeTypes.img_PNG)

        Answers.logContentView(withName: "PDF VIEWER: Send Email with attachment",
                            contentType: "Client Email",
                              contentId: "Screen",
                       customAttributes: nil)
    }
    
    func printDocuments() {
        /* Can Print? */
        let filePath = sharedFunc.FILES().dirDocuments(fileName: self.pdfFilename)
        guard let data = NSData(contentsOfFile: filePath) else { return }
        let canPrint:Bool = (UIPrintInteractionController.canPrint(data as Data) as Bool?)!
        
        if canPrint {
            let printInfo:UIPrintInfo! = UIPrintInfo.printInfo()
                printInfo.outputType = isPhoto ?.photo :.general
                printInfo.jobName = self.pdfFilename
                printInfo.duplex = .longEdge
                printInfo.orientation = .portrait
            
            let PC:UIPrintInteractionController = UIPrintInteractionController.shared
                PC.delegate = self
                PC.printInfo = printInfo
                PC.printingItem = data
                PC.showsNumberOfCopies = true
                PC.showsPaperSelectionForLoadedPapers = true
            
            if isPad {
                PC.present(from: self.BtnShare, animated: true, completionHandler:{ (UIPrintInteractionController, completed, error) -> Void in
                    if ((error != nil) && (!completed)){
                        var msg:String = "PRINTER_DomainError_Msg".localizedCAS()
                            msg = msg.replacingOccurrences(of: "{ERROR_DOMAIN}", with: "\(String(describing: error)))")
                            msg = msg.replacingOccurrences(of: "{ERROR_CODE}", with: "\(String(describing: error)))")
                        let title = "FILE_Download_Title".localizedCAS()
                        sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
                    }else if completed {
                        let title = "PRINTER_Sent_Title".localizedCAS()
                        let msg = "PRINTER_Sent_Msg".localizedCAS()
                        sharedFunc.ALERT().show(title:title,style:.success,msg:msg)
                    }
                })
            }else{
                PC.present(animated: true, completionHandler: { (UIPrintInteractionController, completed, error) -> Void in
                    if ((error != nil) && (!completed)){
                        var msg:String = "PRINTER_DomainError_Msg".localizedCAS()
                            msg = msg.replacingOccurrences(of: "{ERROR_DOMAIN}", with: "\(String(describing: error)))")
                            msg = msg.replacingOccurrences(of: "{ERROR_CODE}", with: "\(String(describing: error)))")
                        let title = "PRINTER_DomainError_Title".localizedCAS()
                        sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
                    }else if completed {
                        let title = "PRINTER_Sent_Title".localizedCAS()
                        let msg = "PRINTER_Sent_Msg".localizedCAS()
                        sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
                    }
                })
            }

            Answers.logCustomEvent(withName: "PDF Viewer:Print",customAttributes:["PDF Filename":printInfo.jobName])
            Flurry.logEvent("PDF Viewer: Print", withParameters: ["PDF Filename":printInfo.jobName])
        }
    }
    
    func loadDefaults() {
        let prefs = UserDefaults.standard

        guard let filename:String = prefs.string(forKey: prefKeys.PDF.attachmentName),
              let serverFilename:String = prefs.string(forKey: prefKeys.PDF.path)
        else {
            showFileNotFound()
            return
        }

        isServerFile = (filename.isEmpty && serverFilename.isNotEmpty)
        pdfFilepath = serverFilename.isNotEmpty ?serverFilename :filename
        pdfFilename = pdfFilepath.lastPathComponent
        pdfFileType = (pdfFilename as NSString).pathExtension
        pdfFilenameNoExtension = pdfFilename.replacingOccurrences(of: ".\(pdfFileType)", with: "")
        
        if isSim {
            print("\nisServer: \(isServerFile)")
            print("pdfFilepath: \(pdfFilepath)")
            print("pdfFilename: \(pdfFilename)")
            print("pdfFileType: \(pdfFileType)")
            print("pdfFilenameNoExtension: \(pdfFilenameNoExtension)")
        }

        if isServerFile.isFalse {
            /* File exist? */
            if sharedFunc.FILES().exists(filePathAndName: pdfFilepath).isFalse {
                showFileNotFound()
                pdfFilename = ""
                return
            }
        }
        
        /* Load file request */
        guard let url = URL(string: pdfFilepath) as URL?,
              let request = URLRequest(url: url) as URLRequest? else {
                
            showFileNotFound()
            return
        }

        webView.load(request)
       
// TODO: ⚙️(Fix) Deprecation - New Method
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let title = "PHOTOS LIBRARY"
            let msg = "Error saving photo to photo library."
            sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
        }
    }

// MARK: - *** ACTIONS ***
    @IBAction func close(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let settingsActionSheet = UIAlertController(title:"DOCUMENT ACTIONS",message:nil,preferredStyle:.actionSheet)
            settingsActionSheet.view.tag = sender.tag
            settingsActionSheet.modalTransitionStyle = .coverVertical
            settingsActionSheet.modalPresentationStyle = .formSheet
            settingsActionSheet.popoverPresentationController?.permittedArrowDirections = .any
            settingsActionSheet.popoverPresentationController?.delegate = self
            settingsActionSheet.popoverPresentationController?.barButtonItem = sender

// MARK: ├─➤ Save
        if show_ShareMenu_Save {
            var title = "Save"
            if isPhoto && saveToCustomPhotoAlbum { title += " Photo to Album"
            }else if isPhoto { title += " Photo"
            }else if isPDF { title += " .PDF"
            }
            
            settingsActionSheet.addAction(UIAlertAction(title:title, style:.default, handler:{ action in
                Answers.logContentView(withName: "PDF VIEWER: \(title)",
                                    contentType: "Client Save",
                                      contentId: "Screen",
                               customAttributes: nil)
                
                if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }
                
                /* Set ShareMenuAction type */
                if self.isPhoto && self.saveToCustomPhotoAlbum { self.shareActionSelected = .savePhotoCustomAlbum
                }else if self.isPhoto { self.shareActionSelected = .savePhoto
                }else if self.isPDF { self.shareActionSelected = .savePDF
                }
                
                self.downloadDocumentFromServer()
                Answers.logCustomEvent(withName: "PDF Viewer:Save",customAttributes:nil)
                Flurry.logEvent("PDF Viewer: Save")
            }))
        }
        
// MARK: ├─➤ Email
        if show_ShareMenu_Email {
            var title = "Email"
            if isPhoto { title += " Photo"
            }else if isPDF { title += " .PDF"
            }
            
            settingsActionSheet.addAction(UIAlertAction(title:title, style:.default, handler:{ action in
                self.shareActionSelected = .email
                self.pdfSendTo = [UserDefaults.standard.string(forKey: prefKeys.MyInfo.email) ?? ""]
                self.downloadDocumentFromServer()
                Answers.logCustomEvent(withName: "PDF Viewer:Email",customAttributes:nil)
                Flurry.logEvent("PDF Viewer: Email")
            }))
        }

// MARK: ├─➤ Print
        if show_ShareMenu_Print {
            var title = "Print"
            if isPhoto { title += " Photo"
            }else if isPDF { title += " .PDF"
            }
            
            settingsActionSheet.addAction(UIAlertAction(title:title, style:.default, handler:{ action in
                self.shareActionSelected = .print
                self.downloadDocumentFromServer()
                Answers.logCustomEvent(withName: "PDF Viewer:Print",customAttributes:nil)
                Flurry.logEvent("PDF Viewer: Print")
            }))
        }
        
// MARK: ├─➤ PrintToSize
        if show_ShareMenu_PrintToSize && isPhoto {
            let title = "Print Photo (PrintToSize App)"
            
            settingsActionSheet.addAction(UIAlertAction(title: title, style:.default, handler:{ action in
                self.shareActionSelected = .printToSize
                
                NotificationCenter.default.post(name: Notification.Name("notification_PrintToSizeSelected"),
                                              object: nil,
                                            userInfo: ["filename":self.pdfFilename])
                
                Answers.logCustomEvent(withName: "PDF Viewer:PrintToSize",customAttributes:nil)
                Flurry.logEvent("PDF Viewer: Print")
                self.dismiss(animated: true)
            }))
        }
        
// MARK: ├─➤ Reload
        if show_ShareMenu_Reload {
            var title = "Reload"
            if isPhoto { title += " Photo"
            }else if isPDF { title += " .PDF/Goto 1st page"
            }
            
            settingsActionSheet.addAction(UIAlertAction(title: title, style:.default, handler:{ action in
                self.shareActionSelected = .reload
                
                self.webView.reload()
                Answers.logCustomEvent(withName: "PDF Viewer:Reload/Home",customAttributes:nil)
                Flurry.logEvent("PDF Viewer: Print")
            }))
        }
    
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel".localizedCAS(), style:.cancel, handler:nil))
        
        present(settingsActionSheet, animated:true)
    }
    
    
// MARK: - *** MAILCOMPOSER ***
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        sharedFunc.MAIL().uponMailCompletion(controller: controller, result: result, error: error as NSError?)
        self.dismiss(animated: true)
    }
    

// MARK: - *** WKWEBVIEW METHODS ***
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        webView.isHidden = false
        waitHUD().hideNow()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        waitHUD().hideNow()

        if isServerFile {
            webView.isHidden = true
            let title = "PDF_NotFound_Title".localizedCAS()
            let msg = "\(error.localizedDescription)"
            sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if isServerFile {
            return
        }else{
            if sharedFunc.FILES().exists(filePathAndName: pdfFilepath) {
                waitHUD().showNow(msg: "\( "WAIT_DOWNLOADING".localizedCAS() )\n\n\( self.pdfFilename )...")
                webView.isHidden = false

                return
            }else{
                waitHUD().hideNow()
                showFileNotFound()
                webView.isHidden = true
                return
            }
        }
    }
    
    
// MARK: - *** PRINTINTERACTION CONTROLLER ***
    func printInteractionControllerWillDismissPrinterOptions(_ printInteractionController: UIPrintInteractionController) { }
    func printInteractionControllerDidDismissPrinterOptions(_ printInteractionController: UIPrintInteractionController) { }
    func printInteractionControllerDidFinishJob(_ printInteractionController: UIPrintInteractionController) { }

    
// MARK: - *** NOTIFICATIONS ***
    @objc func notification_PDFViewer_photoSavedToPhotoAlbum(_ sender: Notification) {
        waitHUD().hideNow()

        guard let userInfo = sender.userInfo else { return }
        
        if let success = userInfo["success"] as? Bool {
            sharedFunc.THREAD().doNow {
                let title = self.saveToCustomPhotoAlbum ?"Custom Photo Album" :"Photo Album"
                let msg = success ?"Photo saved." :"Photo not saved."
                sharedFunc.ALERT().show(title:title,style:success ?.success :.error,msg:msg)
            }
        }
    }
    
    @objc func notification_PDFViewer_documentDownloaded(_ sender: Notification) {
        waitHUD().hideNow()
        
        guard let userInfo = sender.userInfo else { return }
        
        if let success = userInfo["success"] as? Bool {
            if success {
                if let filename = userInfo["filename"] as? String {
                    let filepath = sharedFunc.FILES().dirDocuments(fileName: filename)
                    
                    switch shareActionSelected {
                        case .savePhotoCustomAlbum:
                            let img = UIImage(contentsOfFile: filepath) ?? nil
                            if img != nil {
                                CustomPhotoAlbum().save(image: img!, filename: filename,callback: "notification_photoSavedToAlbum")
                            }
                        case .savePhoto:
                            let img = UIImage(contentsOfFile: filepath) ?? nil
                            if img != nil {
                                UIImageWriteToSavedPhotosAlbum(img!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                            }
                        case .savePDF:
                            let title = "FILE_Downloaded_Title".localizedCAS()
                            let msg = "\(self.pdfFilename) \("FILE_Downloaded_Msg".localizedCAS())"
                            sharedFunc.ALERT().show(title:title,style:.success,msg:msg)
                        case .email:
                            sharedFunc.THREAD().doAfterDelay(delay: 0.1, perform: { self.emailDocuments() })
                        case .print:
                            sharedFunc.THREAD().doAfterDelay(delay: 0.1, perform: { self.printDocuments() })
                        default: ()
                    }
                }
            }else{
                let title = "FILE_Download_Title".localizedCAS()
                let msg = "FILE_Download_Msg".localizedCAS()
                sharedFunc.ALERT().show(title:title,style:.error,msg:msg)
            }
        }
    }
    
    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: blurEffect)

        sharedFunc.DRAW().addShadow(view: toolbar, offsetSize: CGSize(width: 2, height: 2), radius: 2, opacity: Float(kAlpha.quarter))
       
        /* WebView */
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.isHidden = true
        webView.backgroundColor = .clear
        webView.isOpaque = false

// TODO: ⚙️(Fix) Deprecated
//        webView.dataDetectorTypes = [.address,.link,.phoneNumber]
//        webView.paginationMode = .topToBottom
//        webView.scalesPageToFit = true
        
        view = webView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Load Parameters */
        loadDefaults()
        
        /* Appearance */
        if !show_ShareMenu_Email && !show_ShareMenu_Print && !show_ShareMenu_Reload {
            show_ShareMenu = false
        }
        
        BtnShare.isEnabled = show_ShareMenu
        vw_ZoomInfo.isHidden = !show_GestureZoomInstructions
        
        lbl_Title.text = titleText
        lbl_Title.textColor = titleColor

        toolbar.barTintColor = toolbarColor
        toolbar.isTranslucent = show_ToolbarTransparent

        BtnDone.tintColor = closeColor
        BtnShare.tintColor = shareColor
        
        BtnDone.image = show_CloseAsBack ?#imageLiteral(resourceName: "Close_Back") :#imageLiteral(resourceName: "Close_PDF")
        BtnDone.title = show_CloseAsImage ?"" :"Done".localizedCAS()

        /* Notifications */
        let NC = NotificationCenter.default
            NC.addObserver(self, selector: #selector(notification_PDFViewer_documentDownloaded(_:)),
                                     name: NSNotification.Name("notification_PDFViewer_documentDownloaded"),
                                   object: nil)
            NC.addObserver(self, selector: #selector(notification_PDFViewer_photoSavedToPhotoAlbum(_:)),
                                     name: NSNotification.Name("notification_PDFViewer_photoSavedToPhotoAlbum"),
                                   object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Notifications */
        let NC:NotificationCenter = NotificationCenter.default
            NC.removeObserver(self, name: NSNotification.Name("notification_PDFViewer_documentDownloaded"), object: nil)
            NC.removeObserver(self, name: NSNotification.Name("notification_PDFViewer_photoSavedToPhotoAlbum"), object: nil)
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var BtnDone:UIBarButtonItem!
    @IBOutlet var BtnShare:UIBarButtonItem!
    @IBOutlet var toolbar:UIToolbar!
    @IBOutlet var webView:WKWebView!
    @IBOutlet var vw_ZoomInfo:UIView!
    @IBOutlet var lbl_Title:UILabel!
    
// MARK: - *** DECLARATIONS (Variables) ***
    enum shareActions:Int { case print,email,savePhoto,savePhotoCustomAlbum,savePDF,reload,cancel,printToSize }
    
    var pdfFilename:String = ""
    var pdfFilepath:String = ""
    var pdfFileType:String = ""
    var pdfFilenameNoExtension:String = ""
    var pdfSendTo:[String] = []
    var shareActionSelected:shareActions = shareActions.cancel
    
// MARK: - *** DECLARATIONS (Reusable Cells) ***
    
// MARK: - *** PARAMETERS PASSED FROM CALLING VC (Variables) ***
    var show_GestureZoomInstructions:Bool = true
    var show_ShareMenu:Bool = true
    var show_ShareMenu_Email:Bool = true
    var show_ShareMenu_Print:Bool = true
    var show_ShareMenu_Reload:Bool = true
    var show_ShareMenu_Save:Bool = true
    var show_ShareMenu_PrintToSize:Bool = true
    var show_ToolbarTransparent:Bool = true
    var toolbarColor:UIColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var show_CloseAsImage:Bool = true
    var show_CloseAsBack:Bool = true
    var isServerFile:Bool = false
    var isPhoto:Bool = false
    var isPDF:Bool = false
    var saveToCustomPhotoAlbum:Bool = false
    var blurEffect:UIBlurEffect.Style = .light
    var show_Title:Bool = true
    var titleText:String = ""
    var titleColor:UIColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var closeColor:UIColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var shareColor:UIColor = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var statusBarColor:UIStatusBarStyle = .default
}

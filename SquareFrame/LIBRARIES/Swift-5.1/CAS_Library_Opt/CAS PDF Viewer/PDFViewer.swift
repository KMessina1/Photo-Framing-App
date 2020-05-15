/*--------------------------------------------------------------------------------------------------------------------------
    File: PDFViewer.swift
  Author: Kevin Messina
Created: Oct. 30, 2019
Modified:

©2019-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import PDFKit


// MARK: - *** CLASS DEFINITIONS *** -
class PDFViewer:
    UIViewController,
    PDFViewDelegate
{
    
    // MARK: - *** FUNCTIONS ***
    func initButtons() {
        btn_Share.isEnabled = showShareButton
        btn_Close.isEnabled = showCloseButton
        
        if #available(iOS 13.0, *) {
            btn_Close.image = UIImage(systemName: "xmark")
            btn_Share.image = UIImage(systemName: "square.and.arrow.up")
        } else {
            let imgSize = CGSize(width: 30, height: 30)
            btn_Close.image = UIImage(named: "closeX.filled")?.resize(toSize: imgSize, ignoreScale: true)
            btn_Share.image = UIImage(named: "share")?.resize(toSize: imgSize, ignoreScale: true)
        }
    }
    
    func setupNavBar() {
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = UIColor.black.withAlphaComponent(0.66)
        sharedFunc.DRAW().addShadow(view: navBar, offset: 3.0, radius: 3.0, opacity: 0.33)
        sharedFunc.DRAW().roundCorner(view: navBar, radius: 10)
    }
    
    func displayPage() {
        let currentPage:Int = pdfView.document?.index(for: pdfView.currentPage!) ?? 0
        let totalPages:Int = pdfView.document?.pageCount ?? 0

        navBar.topItem?.title = "Page \(currentPage + 1) of \(totalPages)"
    }
    
    func configPDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.displayMode = showThumbnail ? .singlePage : .singlePageContinuous
        pdfView.minScaleFactor = 1.0
        pdfView.maxScaleFactor = 8.0
        
        let filename = pdfURL.lastPathComponent.lowercased()
        
        simPrint().info("PDF PATH: \( pdfURL! )")
        simPrint().info("PDF FILE: \( filename )")

        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
            pdfView.autoScales = true
            pdfView.backgroundColor = .clear
            pdfView.tintColor = .black

            displayPage()
        }else{
            waitHUD().hideNow()
            sharedFunc.ALERT().showFileNotFound(filename: filename)
            // Wait for view to finish loading so it can be dismissed.
            sharedFunc.THREAD().doAfter(delay: 0.33) {
                self.dismiss(animated: true)
            }

            return
        }

        let pagecount = pdfView.document?.pageCount ?? 0
        let multiplePages = (pagecount > 1)
        if showThumbnail && multiplePages {
            thumbnailView.isHidden = false
            thumbnailView.pdfView = pdfView
            thumbnailView.thumbnailSize = CGSize(width: 80, height: 80)
            thumbnailView.translatesAutoresizingMaskIntoConstraints = false
            thumbnailView.layoutMode = .horizontal
            sharedFunc.DRAW().addShadow(view: thumbnailView, offset: 3.0, radius: 3.0, opacity: 0.33)
            sharedFunc.DRAW().roundCorner(view: thumbnailView, radius: 10)
        }else{
            thumbnailView.isHidden = true
        }

        waitHUD().hideNow()
    }
    

    // MARK: - *** ACTIONS ***
    @IBAction func closeView(_ sender:UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareMenu(_ sender:UIBarButtonItem) {
        guard
            let data = pdfView.document?.dataRepresentation()
        else {
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        if let popOver = activityController.popoverPresentationController {
            popOver.sourceView = self.view
            popOver.barButtonItem = self.btn_Share
        }
        
        self.present(activityController, animated: true)
    }


    // MARK: - *** NOTIFICATIONS ***
    @objc func handlePageChange() {
        displayPage()
    }

    
    // MARK: - *** LIFECYCLE ***
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        configPDFView()
        setupNavBar()
        initButtons()

        /* Notifications */
        NotificationCenter.default.addObserver (self,
            selector: #selector(handlePageChange),
            name: Notification.Name.PDFViewPageChanged,
            object: nil
        )
    }
    
    
    // MARK: - *** DECLARATIONS (Variables) ***
    @IBOutlet weak var pdfView:PDFView!
    @IBOutlet weak var btn_Share: UIBarButtonItem!
    @IBOutlet weak var btn_Close: UIBarButtonItem!
    @IBOutlet weak var navBar:UINavigationBar!
    @IBOutlet weak var thumbnailView:PDFThumbnailView!

    // MARK: - *** DECLARATIONS (Variables) ***
    
    // MARK: - *** DECLARATIONS (Presenting VC Configurable Parameters) ***
    var pdfURL:URL!
    var showThumbnail:Bool = true
    var showCloseButton:Bool = true
    var showShareButton:Bool = true
    var showPageNumbers:Bool = true
}


/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_frameGallery.swift
  Author: Kevin Messina
 Created: Jan 26, 2016
Modified: Apr 6, 2018

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
2018_04_06 - Converted to retrieve information from CMS Server based on version.
2016_09_16 - Converted to Swift
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire


// MARK: - *** GLOBAL CONSTANTS ***
class VC_frameGallery:UIViewController,
                      UIPopoverPresentationControllerDelegate,
                      UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }
    
    func getData() {
        frameGalleryPhotos.removeAll(keepingCapacity: false)

        let imgsUrl:URL = cachedImgs.FRAMES.gallery.url

        var filenames = try? FileManager.default.contentsOfDirectory(atPath: imgsUrl.path)
            filenames = filenames?.filter({ $0.contains("frameGallery") })
            filenames = filenames?.sorted(by: { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending } )

        for count in 0..<Int(filenames?.count ?? 0) {
            let filename = imgsUrl.appendingPathComponent(filenames![count])
            frameGalleryPhotos.append(UIImage(contentsOfFile: filename.path) ?? UIImage())
        }
        
        simPrint().info("Found: \( frameGalleryPhotos.count ) files in \( imgsUrl.path.lastPathComponent )",function:#function,line:#line)

        if frameGalleryPhotos.count > 0 {
            collPhotos.reloadData()
        }else{
            /* Get All Frame Gallery Photos */
            FrameGallery().getPhotos()
        }
    }
    
    
// MARK: - *** ACTIONS ***
    @IBAction func showMenu(_ sender:UIButton){
        slideMenuController()?.toggleLeft()
    }
    
    
// MARK: - *** COLLECTION VIEW FLOW LAYOUT ***
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collPhotos.bounds.width - 20
        let font = UIFont(name: Font_Montserrat.light, size: isPad ?32 :16)
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = (1.3 * font!.lineHeight)
            paragraphStyle.alignment = .center
        
        if indexPath.section == sections.text.rawValue {
            let attribs:[NSAttributedString.Key:Any] = [
                .font:font!,
                .paragraphStyle:paragraphStyle
            ]

            let htNeeded = NSAttributedString().heightNeededToFitText(
                txt: CMS_frameGalleryTitle,
                maxWidth: cellWidth,
                attribs: attribs
            )

            return CGSize(width: cellWidth, height: htNeeded + font!.lineHeight)
        }else{
            let photosize = frameGalleryPhotos[0].size
            let aspectRatio = (cellWidth - photosize.width)
            var cellHeight:CGFloat = 0.0
                cellHeight = (photosize.height + (aspectRatio / 1.5))
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }

    
// MARK: - *** COLLECTION VIEW METHODS *** 
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 2 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == sections.text.rawValue) ?1 :frameGalleryPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == sections.text.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.Text, for: indexPath) as? cell_BrowserText
            else { return UICollectionViewCell.init() }

            /* Appearance */
            cell.lbl_Text.textColor = gAppColor
            
            /* Data */
            cell.lbl_Text.attributedText = NSAttributedString(string: CMS_frameGalleryTitle, attributes: textStyleAttributes )

            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.Photos, for: indexPath) as? cell_Browser
            else { return UICollectionViewCell.init() }
            
            /* Appearance */
            sharedFunc.DRAW().addShadow(view: cell, radius: 5, opacity: 0.66)
            
            /* Data */
            cell.img_Photo.image = frameGalleryPhotos[row]

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }

    
// MARK: - *** NOTIFICATIONS ***

    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return false }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        lbl_Title.textColor = gAppColor
        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)

        btn_Menu.setImage(isPad ? #imageLiteral(resourceName: "Menu_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Menu").recolor(gAppColor), for: .normal)

        /* Default Data */
        let font = UIFont(name: Font_Montserrat.light, size: isPad ?32 :16) ?? UIFont.systemFont(ofSize: isPad ?32 :16)
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = (1.2 * font.lineHeight)
            paragraphStyle.alignment = .center
        textStyleAttributes = [.font: font, .paragraphStyle: paragraphStyle]

        /* Localization */
        lbl_Title.text = "Frames(\(gAppID))_Title".localized()
        
        /* Notifications */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Default Data */
        getData()

        /* Appearance */
        collPhotos.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        frameGalleryPhotos.removeAll(keepingCapacity: false)
    }

// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var collPhotos:UICollectionView!
    @IBOutlet var vw_Topbar:UIView!
    @IBOutlet var divider:UILabel!
    @IBOutlet var btn_Menu:UIButton!
    @IBOutlet var lbl_Title:UILabel!
    
    
// MARK: ├─➤ *** DECLARATIONS (Variables)
    enum sections:Int { case text=0,photos }
    
    var textStyleAttributes:[NSAttributedString.Key:Any] = [:]
    var frameGalleryPhotos:[UIImage] = []

// MARK: ├─➤ DECLARATIONS (Cell Reuse Identifiers)
    struct cellID {
        static let Photos = "cell_Browser"
        static let Text = "cell_BrowserText"
    }
}

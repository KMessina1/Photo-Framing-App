/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_FrameInfo.swift
 Author: Kevin Messina
Created: June 06, 2017

©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_FrameInfo:UIViewController,
                   UICollectionViewDelegate,UICollectionViewDataSource,
                   UIGestureRecognizerDelegate {
    
// MARK: - *** FUNCTIONS ***
    func updatePage() {
        switch page.currentPage {
        case 0: lblDescription.text = "Frames_Info_Description_1".localized()
        case 1: lblDescription.text = "Frames_Info_Description_2".localized()
        case 2: lblDescription.text = "Frames_Info_Description_3".localized()
        default: lblDescription.text = ""
        }
    }

    
// MARK: - *** ACTIONS ***


// MARK: - *** COLLECTION METHODS *** 
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return photos.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellID.Photos,for:indexPath) as? cell_Browser
        else { return UICollectionViewCell.init() }

        cell.img_Photo.image = photos[row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collPhotos.contentOffset, size: collPhotos.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collPhotos.indexPathForItem(at: visiblePoint)

        let newpage = indexPath?.row ?? 0

        if newpage >= page.numberOfPages {
        }else{
            page.currentPage = newpage
        }

        updatePage()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    
// MARK: - *** GESTURES ***
    @objc func tap_Hide(_ sender:UITapGestureRecognizer){
        dismiss(animated: true)
    }
    
    @objc func swipe_Hide(_ sender:UISwipeGestureRecognizer){
        dismiss(animated: true)
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
        imgHide.image = imgHide.image?.recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        /* Page Control */
        page.numberOfPages = 3
        page.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        page.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        page.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        /* Gestures */
        imgHide.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "tap_Hide:", delegate: self, numTaps: 1))
        vwContainer.addGestureRecognizer(sharedFunc.GESTURES().returnSwipe(
            selector: "swipe_Hide:",
            delegate: self,
            direction: .down,
            numTouches: 1)
        )
        
        /* Collection View */
        collPhotos.collectionViewLayout.invalidateLayout()
        collPhotos.setCollectionViewLayout(ListFlowLayout.init(), animated: false)
        
        /* Data */
        
        /* Localization */
        lblDescription.text = "Frames_Info_Description".localized()
        
        /* Notifications */
    }
    
    override func viewWillLayoutSubviews() {
        /* Appearance */
        sharedFunc.DRAW().addShadow(view: page, radius: 2, opacity: 0.66)
        sharedFunc.IMAGE().addBlurEffect(view: vwContainer, style: .extraLight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Data */
        page.currentPage = 0

        if (frameColor < 0) || (frameColor >= Frame_Color.count) {
            frameColor = Frame_Color.natural.rawValue
        }
        if item.size == nil  || (item.size < 0) || (item.size >= Frame_Size_All.count) {
            item.size = Frame_Size_All.square_4x4_SL.rawValue
        }

        var offset = 0
        if isPhotoSelected().isTrue && item.photo.isSquare.isFalse {
            offset = CMS_Frames_Square.count
        }
        let size = Frame_Size_All(rawValue:item.size + offset) ?? .square_4x4_SL

        if let color = Frame_Color(rawValue: frameColor) {
            switch color {
                case .black:
                    switch size {
                        case .square_4x4_SL: photos = framePrevImgs.BLACK._4x4SL
                        case .square_4x4_ST: photos = framePrevImgs.BLACK._4x4ST
                        case .square_5x5: photos = framePrevImgs.BLACK._5x5ST
                        case .square_8x8: photos = framePrevImgs.BLACK._8x8ST
                        case .rect_4x6_SL: photos = framePrevImgs.BLACK._4x6SL
                        case .rect_4x6_ST: photos = framePrevImgs.BLACK._4x6ST
                        case .rect_5x7: photos = framePrevImgs.BLACK._5x7ST
                        case .rect_8x10: photos = framePrevImgs.BLACK._8x10ST
                    }
                case .walnut:
                    switch size {
                        case .square_4x4_SL: photos = framePrevImgs.WALNUT._4x4SL
                        case .square_4x4_ST: photos = framePrevImgs.WALNUT._4x4ST
                        case .square_5x5: photos = framePrevImgs.WALNUT._5x5ST
                        case .square_8x8: photos = framePrevImgs.WALNUT._8x8ST
                        case .rect_4x6_SL: photos = framePrevImgs.WALNUT._4x6SL
                        case .rect_4x6_ST: photos = framePrevImgs.WALNUT._4x6ST
                        case .rect_5x7: photos = framePrevImgs.WALNUT._5x7ST
                        case .rect_8x10: photos = framePrevImgs.WALNUT._8x10ST
                    }
                case .graywash:
                    switch size {
                        case .square_4x4_SL: photos = framePrevImgs.GRAYWASH._4x4SL
                        case .square_4x4_ST: photos = framePrevImgs.GRAYWASH._4x4ST
                        case .square_5x5: photos = framePrevImgs.GRAYWASH._5x5ST
                        case .square_8x8: photos = framePrevImgs.GRAYWASH._8x8ST
                        case .rect_4x6_SL: photos = framePrevImgs.GRAYWASH._4x6SL
                        case .rect_4x6_ST: photos = framePrevImgs.GRAYWASH._4x6ST
                        case .rect_5x7: photos = framePrevImgs.GRAYWASH._5x7ST
                        case .rect_8x10: photos = framePrevImgs.GRAYWASH._8x10ST
                    }
                case .natural:
                    switch size {
                        case .square_4x4_SL: photos = framePrevImgs.NATURAL._4x4SL
                        case .square_4x4_ST: photos = framePrevImgs.NATURAL._4x4ST
                        case .square_5x5: photos = framePrevImgs.NATURAL._5x5ST
                        case .square_8x8: photos = framePrevImgs.NATURAL._8x8ST
                        case .rect_4x6_SL: photos = framePrevImgs.NATURAL._4x6SL
                        case .rect_4x6_ST: photos = framePrevImgs.NATURAL._4x6ST
                        case .rect_5x7: photos = framePrevImgs.NATURAL._5x7ST
                        case .rect_8x10: photos = framePrevImgs.NATURAL._8x10ST
                    }
                case .white:
                    switch size {
                        case .square_4x4_SL: photos = framePrevImgs.WHITE._4x4SL
                        case .square_4x4_ST: photos = framePrevImgs.WHITE._4x4ST
                        case .square_5x5: photos = framePrevImgs.WHITE._5x5ST
                        case .square_8x8: photos = framePrevImgs.WHITE._8x8ST
                        case .rect_4x6_SL: photos = framePrevImgs.WHITE._4x6SL
                        case .rect_4x6_ST: photos = framePrevImgs.WHITE._4x6ST
                        case .rect_5x7: photos = framePrevImgs.WHITE._5x7ST
                        case .rect_8x10: photos = framePrevImgs.WHITE._8x10ST
                    }
            }
        }
        
        updatePage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        vwTopBar.isOpaque = false
        vwTopBar.backgroundColor = .clear
        vwTopBar.frame.size.width = self.view.bounds.width
        sharedFunc.DRAW().gradient(view: vwTopBar, startColor: gAppColor, endColor: .clear)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var collPhotos:UICollectionView!
    @IBOutlet var vwContainer:UIView!
    @IBOutlet var vwTopBar:UIView!
    @IBOutlet var imgHide:UIImageView!
    @IBOutlet var lblDescription:UILabel!
    @IBOutlet var imgPhotos:UIImageView!
    @IBOutlet var page:UIPageControl!
    
// MARK: - *** DECLARATIONS (Variables) ***
    var timer:Timer = Timer.init()
    var photos:[UIImage] = []
    var frameColor:Int = 0

// MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let Photos:String = "cell_Browser"
    }
}

class GridFlowLayout: UICollectionViewFlowLayout {
    // here you can define the height of each cell
    var itemHeight: CGFloat = 120
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /**
     Sets up the layout for the collectionView. 1pt distance between each cell and 1pt distance between each row plus use a vertical layout
     */
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
    /// here we define the width of each cell, creating a 2 column layout. In case you would create 3 columns, change the number 2 to 3
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.width / 2) - 1
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(),height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth(),height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}

class ListFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }
    
    /**
     Init method
     - parameter aDecoder: aDecoder
     - returns: self
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /* Sets up the layout for the collectionView. 0 distance between each cell, and vertical layout */
    func setupLayout() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
    }
    
    func itemHeight() -> CGFloat {
        return collectionView!.frame.height
    }
    
    func itemWidth() -> CGFloat {
        return collectionView!.frame.width
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(),height: itemHeight())
        }
        get {
            return CGSize(width: itemWidth(),height: itemHeight())
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}

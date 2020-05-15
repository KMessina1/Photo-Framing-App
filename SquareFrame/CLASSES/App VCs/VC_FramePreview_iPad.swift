/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_FramePreview_iPad
 Author: Kevin Messina
Created: October 28, 2017

©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_FramePreview_iPad:UIViewController {
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    
// MARK: - *** ACTIONS ***
    @IBAction func close(_ sender:UIButton){
        self.dismiss(animated:true)
    }
    
    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        self.modalPresentationCapturesStatusBarAppearance = true
        
        btn_Close.backgroundColor = .clear
        btn_Close.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn_Close.backgroundColor = gAppColor
        img_Close.image = img_Close.image?.recolor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        sharedFunc.DRAW().strokeBorder(view: img_Frame_Portrait, color: UIColor.black.withAlphaComponent(0.5), width: 2.5)
        sharedFunc.DRAW().strokeBorder(view: img_Frame_Rect, color: UIColor.black.withAlphaComponent(0.5), width: 2.5)
        sharedFunc.DRAW().strokeBorder(view: img_Frame_Square, color: UIColor.black.withAlphaComponent(0.5), width: 2.5)
        sharedFunc.DRAW().roundCorner(view: btn_Close, radius: (btn_Close.frame.width / 2))
        sharedFunc.DRAW().addShadow(view: btn_Close, offsetSize: CGSize(width:20,height:20), radius: 10, opacity: 0.5)
        sharedFunc.DRAW().addShadow(view: img_Frame_Rect, offsetSize: CGSize(width:20,height:20), radius: 10, opacity: 0.5)
        sharedFunc.DRAW().addShadow(view: img_Frame_Square, offsetSize: CGSize(width:20,height:20), radius: 10, opacity: 0.5)
        sharedFunc.DRAW().addShadow(view: img_Frame_Portrait, offsetSize: CGSize(width:20,height:20), radius: 10, opacity: 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lbl_selectedFrame.text = "\( frame_Color.localized() ) \( frame_Size.localized() ) \( "Photo".localized() )"

        // NOTE: The larger the newSize number, the more 'matte' area exposed.
        var newSize:CGFloat = 120
        let screenHt = self.view.frame.height
        
        if tempItem.photo.isPortrait {
            switch screenHt {
                case ...1024: newSize = 120
                case ...1112: newSize = 140
                case ...1366: newSize = 170
                default: newSize = 120
            }
        } else if tempItem.photo.isSquare {
            switch screenHt {
                case ...1024: newSize = 150
                case ...1112: newSize = 165
                case ...1366: newSize = 190
                default: newSize = 150
            }
        } else {
            switch screenHt {
                case ...1024: newSize = 95
                case ...1112: newSize = 110
                case ...1366: newSize = 140
                default: newSize = 90
            }
        }

        for constraint in photoConstraints {
            constraint.constant = newSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for img in [img_Frame_Square,img_Frame_Portrait,img_Frame_Rect,img_Photo_Square,img_Photo_Portrait,img_Photo_Rect] {
            img?.isHidden = true
            img?.image = nil
        }
        
        if photoImg.isSquare {
            img_Frame_Square.image = self.frameImg
            img_Photo_Square.image = self.photoImg
            img_Frame_Square.isHidden = false
            img_Photo_Square.isHidden = false
        } else if photoImg.isPortrait {
            img_Frame_Portrait.image = self.frameImg.rotatedByDegrees(degrees: 90)
            img_Photo_Portrait.image = self.photoImg
            img_Frame_Portrait.isHidden = false
            img_Photo_Portrait.isHidden = false
        } else {
            img_Frame_Rect.image = self.frameImg
            img_Photo_Rect.image = self.photoImg
            img_Frame_Rect.isHidden = false
            img_Photo_Rect.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Appearance */
        self.modalPresentationCapturesStatusBarAppearance = false
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var btn_Close:UIButton!
    @IBOutlet var img_Close:UIImageView!
    @IBOutlet var img_Frame_Square:UIImageView!
    @IBOutlet var img_Photo_Square:UIImageView!
    @IBOutlet var img_Frame_Rect:UIImageView!
    @IBOutlet var img_Photo_Rect:UIImageView!
    @IBOutlet var img_Frame_Portrait:UIImageView!
    @IBOutlet var img_Photo_Portrait:UIImageView!
    @IBOutlet var img_Background:UIView!
    @IBOutlet var photoConstraints: [NSLayoutConstraint]!
    @IBOutlet var lbl_selectedFrame: UILabel!

    // MARK: - *** DECLARATIONS (Variables) ***

// MARK: - *** PARAMETERS PASSED FROM CALLING VC (Variables) ***
    var frame_Size:String = ""
    var frame_Color:String = ""
    var frameImg:UIImage = UIImage()
    var photoImg:UIImage = UIImage()
}


/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_FramePreview.swift
 Author: Kevin Messina
Created: April 17, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_FramePreview:UIViewController {
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    
// MARK: - *** ACTIONS ***
    @IBAction func close(_ sender:UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification_refreshScreen"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notify_PreviewCompleted"), object: nil)

        self.dismiss(animated:true)
    }
    
    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .landscapeLeft }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .landscapeLeft }
    override var shouldAutorotate:Bool { return false }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        /* Appearance */
        self.modalPresentationCapturesStatusBarAppearance = true
        
        btn_Close.setImage(#imageLiteral(resourceName: "Close").recolor(gAppColor), for: .normal)
        btn_Close2.setImage(#imageLiteral(resourceName: "Close").recolor(gAppColor), for: .normal)
        
        sharedFunc.DRAW().strokeBorder(view: img_Photo_Square, color: UIColor.black.withAlphaComponent(0.5), width: 1.0)
        sharedFunc.DRAW().strokeBorder(view: img_Photo_Rect, color: UIColor.black.withAlphaComponent(0.5), width: 1.0)

        sharedFunc.DRAW().addShadow(view: img_Frame_Rect, offsetSize: CGSize(width:2,height:2), radius: 5, opacity: 1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        img_Logo2.isHidden = true
        btn_Close.isHidden = true
        for img in [img_Frame_Square,img_Photo_Square,img_Frame_Rect,img_Photo_Rect] {
            img?.isHidden = true
            img?.image = UIImage()
        }

        img_Logo.image = #imageLiteral(resourceName: "Black_Logo").rotatedByDegrees(degrees: 90)

        if photoImg.isSquare || photoImg.isPortrait {
            sharedFunc.DRAW().removeShadow(view: photoImg.isPortrait ?img_Frame_Rect :img_Frame_Square)

            photoImg = photoImg.rotatedByDegrees(degrees: 90)
        }

        sharedFunc.DRAW().addShadow(view: img_Frame_Square,offset: 0,radius: 10,opacity: 0.66)
        sharedFunc.DRAW().addShadow(view: img_Frame_Rect,offset: 0,radius: 10,opacity: 0.66)

        if photoImg.isSquare {
            img_Frame_Square.image = self.frameImg
            img_Photo_Square.image = self.photoImg
            img_Frame_Square.isHidden = false
            img_Photo_Square.isHidden = false

            img_Frame_Square.image = img_Frame_Square.image?.rotatedByDegrees(degrees: -90)
        }else{
            img_Frame_Rect.image = self.frameImg
            img_Photo_Rect.image = self.photoImg
            img_Frame_Rect.isHidden = false
            img_Photo_Rect.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        /* Reversed height/width for landscape UIView orientation */
        let h:CGFloat = self.view.frame.width
        let w:CGFloat = self.view.frame.height
        let margin:CGFloat = img_Logo2.frame.width + 5
        let statusbarHt:CGFloat = 20.0
        let width:CGFloat = (w - ((margin * 2) + statusbarHt))
        let center:CGPoint = CGPoint(x: ((h - statusbarHt) - img_Logo2.frame.width), y: self.view.center.y)

        let frameRect = CGRect(x: 0,y: 0,width: width,height: img_Logo2.frame.width)
        lbl_selectedFrame = UILabel.init(frame: frameRect)
        lbl_selectedFrame.adjustsFontSizeToFitWidth = true
        lbl_selectedFrame.minimumScaleFactor = 0.50
        lbl_selectedFrame.textAlignment = .center
        lbl_selectedFrame.font = UIFont(name: Font_Montserrat.extraLight, size: 28)
        lbl_selectedFrame.text = "\( frame_Size ) \( "Photo".localized() ) (\( frame_Color.localized() ))"
        lbl_selectedFrame.textColor = gAppColor.withAlphaComponent(0.66)
        lbl_selectedFrame.backgroundColor = .clear
        lbl_selectedFrame.rotation = 90
        lbl_selectedFrame.center = center
        self.view.addSubview(lbl_selectedFrame)
    }

    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var btn_Close:UIButton!
    @IBOutlet var btn_Close2:UIButton!
    @IBOutlet var img_Frame_Square:UIImageView!
    @IBOutlet var img_Photo_Square:UIImageView!
    @IBOutlet var img_Frame_Rect:UIImageView!
    @IBOutlet var img_Photo_Rect:UIImageView!
    @IBOutlet var img_Background:UIView!
    @IBOutlet var img_Logo:UIImageView!
    @IBOutlet var img_Logo2:UIImageView!

// MARK: - *** DECLARATIONS (Variables) ***
    var lbl_selectedFrame:UILabel = UILabel.init()

// MARK: - *** PARAMETERS PASSED FROM CALLING VC (Variables) ***
    var frame_Size:String = ""
    var frame_Color:String = ""
    var frameImg:UIImage = UIImage()
    var photoImg:UIImage = UIImage()
}


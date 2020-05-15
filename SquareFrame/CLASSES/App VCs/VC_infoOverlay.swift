/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_infoOverlay.swift
 Author: Kevin Messina
Created: August 26, 2017

©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_infoOverlay:UIViewController {
    
// MARK: - *** FUNCTIONS ***
    func enableReplay(_ enabled:Bool) {
        btn_Replay.isEnabled = enabled
        img_Replay.alpha = enabled ?kAlpha.opaque :kAlpha.quarter
    }

    
// MARK: - *** ANIMATIONS ***
    func anim_reset(withAnimations:Bool) {
        animRunning = true
        enableReplay(self.showTipsOnly.isTrue ?true :false)
        
        UIView.animate(withDuration: showTipsOnly ?0.0 :0.75, delay: 0.0, options: [.curveLinear], animations: {
            if self.showTipsOnly.isTrue {
                for lbl in [self.lbl_Title,self.lbl_Decrip] {
                    lbl?.alpha = kAlpha.transparent
                }
            }else{
                for lbl in [self.lbl_TipTitle,self.lbl_Tip1,self.lbl_Tip2,self.lbl_Tip3,self.lbl_Tip4,self.lbl_Title,self.lbl_Decrip] {
                    lbl?.alpha = kAlpha.transparent
                }
            }
            self.vw_Frame.alpha = kAlpha.transparent
            for img in [self.img_Hand,self.img_AnimSequence] {
                img?.alpha = kAlpha.transparent
            }
        }, completion: { (finished: Bool) -> Void in
            if self.animRunning.isFalse {
                self.enableReplay(true)
                return
            }

            if finished && withAnimations {
                if self.showTipsOnly.isTrue {
                    self.showTipsOnly = false
                    self.animate_Tips()
                }else{
                    self.animate_TapToSelectPhoto()
                }
            }
        })
    }
    
    func animate_TapToSelectPhoto() {
        img_Photo.image = #imageLiteral(resourceName: "NoPhoto_Sq")
        img_Hand.image = #imageLiteral(resourceName: "Gesture_Finger_Side_Opaque")
        self.lbl_Title.text = "InfoOverlay_Slide1_Title".localized()
        self.lbl_Decrip.text = "InfoOverlay_Slide1_Descrip".localized()
        
// MARK: ├─➤ Description
        UIView.animate(withDuration: self.animTimingSpeed, delay: 0.0, options: [.curveLinear], animations: {
            self.lbl_Title.alpha = kAlpha.opaque
            self.lbl_Decrip.alpha = kAlpha.opaque
            self.vw_Frame.alpha = kAlpha.opaque
            self.img_Photo.isHidden = false
            self.img_Hand.center = CGPoint(
                x:self.img_Photo.center.x + (self.img_Hand.frame.width / 2),
                y:self.img_Photo.center.y
            )
            self.img_AnimSequence.center = self.img_Photo.center
        }, completion: { (finished: Bool) -> Void in
// MARK: ├─➤ Hand
            if self.animRunning.isFalse {
                self.enableReplay(true)
                return
            }

            UIView.animate(withDuration: (self.animTimingSpeed * 0.5), delay: 0.0, options: [.curveLinear], animations: {
                self.img_Hand.alpha = kAlpha.opaque
            }, completion: { (finished: Bool) -> Void in
// MARK: ├─➤ Animation Movement
                self.img_AnimSequence.alpha = kAlpha.opaque
                self.img_AnimSequence.startAnimating()
                if self.animRunning.isFalse {
                    self.enableReplay(true)
                    return
                }
                
                UIView.animate(withDuration: (self.animTimingSpeed * 0.25), delay: (self.animTimingSpeed * 2), options: [.curveLinear], animations: {
                    self.img_AnimSequence.alpha = kAlpha.transparent
                }, completion: { (finished: Bool) -> Void in
                    if self.animRunning.isFalse {
                        self.enableReplay(true)
                        return
                    }

                    UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: 0.0, options: [.curveLinear], animations: {
                        self.img_Hand.alpha = kAlpha.transparent
                        self.lbl_Title.alpha = kAlpha.transparent
                        self.lbl_Decrip.alpha = kAlpha.transparent
                    }, completion: { (finished: Bool) -> Void in
                        if self.animRunning.isFalse {
                            self.enableReplay(true)
                            return
                        }

                        self.animate_TapToPreview()
                    })
                })
            })
        })
    }

    func animate_TapToPreview() {
        img_Photo.image = #imageLiteral(resourceName: "NoPhoto_Sq")
        img_Hand.image = #imageLiteral(resourceName: "Gesture_Finger_Side_Opaque")
        self.lbl_Title.text = "InfoOverlay_Slide2_Title".localized()
        self.lbl_Decrip.text = "InfoOverlay_Slide2_Descrip".localized()

        // MARK: ├─➤ Description
        UIView.animate(withDuration: animTimingSpeed, delay: 0.0, options: [.curveLinear], animations: {
            self.lbl_Title.alpha = kAlpha.opaque
            self.lbl_Decrip.alpha = kAlpha.opaque
            self.img_Hand.frame = CGRect( // Position Hand for next animation
                x: self.img_Photo.center.x,
                y: ((self.img_Photo.center.y + (self.img_Hand.frame.height / 4)) - 5),
                width: self.img_Hand.frame.width,
                height: self.img_Hand.frame.height
            )
            self.img_AnimSequence.center.y = self.img_Hand.center.y
        }, completion: { (finished: Bool) -> Void in
            if self.animRunning.isFalse {
                self.enableReplay(true)
                return
            }

            // MARK: ├─➤ Hand
            UIView.animate(withDuration: (self.animTimingSpeed * 0.5), delay: 0.0, options: [.curveLinear], animations: {
                self.img_Hand.alpha = kAlpha.opaque
            }, completion: { (finished: Bool) -> Void in
                if self.animRunning.isFalse {
                    self.enableReplay(true)
                    return
                }

                // MARK: ├─➤ Animation Movement
                self.img_AnimSequence.alpha = kAlpha.opaque
                self.img_AnimSequence.startAnimating()
                
                UIView.animate(withDuration: (self.animTimingSpeed * 0.25), delay: (self.animTimingSpeed * 2), options: [.curveLinear], animations: {
                    self.img_AnimSequence.alpha = kAlpha.transparent
                }, completion: { (finished: Bool) -> Void in
                    if self.animRunning.isFalse {
                        self.enableReplay(true)
                        return
                    }
                    
                    UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: 0.0, options: [.curveLinear], animations: {
                        self.img_Hand.alpha = kAlpha.transparent
                        self.lbl_Title.alpha = kAlpha.transparent
                        self.lbl_Decrip.alpha = kAlpha.transparent
                    }, completion: { (finished: Bool) -> Void in
                        if self.animRunning.isFalse {
                            self.enableReplay(true)
                            return
                        }
                        
                        self.animate_SwipeToChangeColor()
                    })
                })
            })
        })
    }
    
    func animate_SwipeToChangeColor() {
        img_Hand.image = #imageLiteral(resourceName: "Gesture_Finger_Up_Opaque")
        
// MARK: ├─➤ Description
        UIView.animate(withDuration: (animTimingSpeed * 0.75), delay: 0.0, options: [.curveLinear], animations: {
            self.lbl_Title.alpha = kAlpha.opaque
            self.lbl_Decrip.alpha = kAlpha.opaque
            self.lbl_Title.text = "InfoOverlay_Slide3_Title".localized()
            self.lbl_Decrip.text = "InfoOverlay_Slide3_Descrip".localized()
            self.img_Hand.frame = CGRect( // Position Hand for next animation
                x: self.img_Photo.center.x,
                y: self.img_Photo.center.y,
                width: self.img_Hand.frame.width,
                height: self.img_Hand.frame.height
            )
        }, completion: { (finished: Bool) -> Void in
// MARK: ├─➤ Hand
            if self.animRunning.isFalse {
                self.enableReplay(true)
                return
            }
            
            UIView.animate(withDuration: (self.animTimingSpeed * 0.5), delay: 0.0, options: [.curveLinear], animations: {
                self.img_Hand.alpha = kAlpha.opaque
            }, completion: { (finished: Bool) -> Void in
// MARK: ├─➤ Animation Movement LEFT
                if self.animRunning.isFalse {
                    self.enableReplay(true)
                    return
                }
                
                UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: self.animTimingSpeed, options: [.curveLinear], animations: {
                    self.img_Hand.frame = CGRect( // Position Hand for next animation
                        x: (self.img_Frame.frame.origin.x - (self.img_Hand.frame.width / 4)),
                        y: self.img_Photo.center.y,
                        width: self.img_Hand.frame.width,
                        height: self.img_Hand.frame.height
                    )
                }, completion: { (finished: Bool) -> Void in
// MARK: ├─➤ Animation Movement RIGHT
                    if self.animRunning.isFalse {
                        self.enableReplay(true)
                        return
                    }
                    
                    UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: self.animTimingSpeed, options: [.curveLinear], animations: {
                        self.img_Frame.image = #imageLiteral(resourceName: "Frame_Square_Gray")
                        self.img_Hand.frame = CGRect( // Position Hand for next animation
                            x: self.img_Frame.center.x,
                            y: self.img_Photo.center.y,
                            width: self.img_Hand.frame.width,
                            height: self.img_Hand.frame.height
                        )
                    }, completion: { (finished: Bool) -> Void in
                        if self.animRunning.isFalse {
                            self.enableReplay(true)
                            return
                        }
                        
                        self.img_Frame.image = #imageLiteral(resourceName: "Frame_Square_Natural")
                        UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: self.animTimingSpeed, options: [.curveLinear], animations: {
                            self.img_Hand.alpha = kAlpha.transparent
                            self.lbl_Title.alpha = kAlpha.transparent
                            self.lbl_Decrip.alpha = kAlpha.transparent
                        }, completion: { (finished: Bool) -> Void in
                            if self.animRunning.isFalse {
                                self.enableReplay(true)
                                return
                            }
                            
                            self.animate_SwipeToChangeSize()
                        })
                    })
                })
            })
        })
    }

    func animate_SwipeToChangeSize() {
        img_Hand.image = #imageLiteral(resourceName: "Gesture_Finger_Up_Opaque")
        
// MARK: ├─➤ Description
        UIView.animate(withDuration: (animTimingSpeed * 0.75), delay: 0.0, options: [.curveLinear], animations: {
            self.lbl_Title.alpha = kAlpha.opaque
            self.lbl_Decrip.alpha = kAlpha.opaque
            self.lbl_Title.text = "InfoOverlay_Slide4_Title".localized()
            self.lbl_Decrip.text = "InfoOverlay_Slide4_Descrip".localized()
            self.lbl_Title.alpha = kAlpha.opaque
            self.lbl_Decrip.alpha = kAlpha.opaque
            self.img_Hand.frame = CGRect( // Position Hand for next animation
                x: (self.img_Frame.frame.origin.x + (self.img_Hand.frame.width / 4)),
                y: self.img_Frame.center.y,
                width: self.img_Hand.frame.width,
                height: self.img_Hand.frame.height
            )
        }, completion: { (finished: Bool) -> Void in
            if self.animRunning.isFalse {
                self.enableReplay(true)
                return
            }
            
// MARK: ├─➤ Hand
            UIView.animate(withDuration: (self.animTimingSpeed * 0.5), delay: 0.0, options: [.curveLinear], animations: {
                self.img_Hand.alpha = kAlpha.opaque
            }, completion: { (finished: Bool) -> Void in
                if self.animRunning.isFalse {
                    self.enableReplay(true)
                    return
                }
                
// MARK: ├─➤ Animation Movement UP
                UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: self.animTimingSpeed, options: [.curveLinear], animations: {
                    self.img_Hand.frame = CGRect( // Position Hand for next animation
                        x: (self.img_Frame.frame.origin.x + (self.img_Hand.frame.width / 4)),
                        y: (self.img_Frame.center.y - (self.img_Hand.frame.height / 2)),
                        width: self.img_Hand.frame.width,
                        height: self.img_Hand.frame.height
                    )
                }, completion: { (finished: Bool) -> Void in
                    if self.animRunning.isFalse {
                        self.enableReplay(true)
                        return
                    }
                    
                    self.img_Frame.backgroundColor = .clear
                    self.img_Photo.isHidden = true
// MARK: ├─➤ Animation Movement DOWN
                    UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: self.animTimingSpeed, options: [.curveLinear], animations: {
                        self.img_Frame.image = #imageLiteral(resourceName: "Frame_Square_Natural_Small")
                        self.img_Hand.frame = CGRect( // Position Hand for next animation
                            x: (self.img_Frame.frame.origin.x + (self.img_Hand.frame.width / 4)),
                            y: self.img_Frame.center.y,
                            width: self.img_Hand.frame.width,
                            height: self.img_Hand.frame.height
                        )
                    }, completion: { (finished: Bool) -> Void in
                        if self.animRunning.isFalse {
                            self.enableReplay(true)
                            return
                        }
                        
                        self.img_Frame.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        self.img_Frame.image = #imageLiteral(resourceName: "Frame_Square_Natural")
                        self.vw_Frame.isHidden = false
                        self.img_Photo.isHidden = false
                        UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: self.animTimingSpeed, options: [.curveLinear], animations: {
                            for lbl in [self.lbl_TipTitle,self.lbl_Tip1,self.lbl_Tip2,self.lbl_Tip3,self.lbl_Tip4,self.lbl_Title,self.lbl_Decrip] {
                                lbl?.alpha = kAlpha.transparent
                            }
                            self.vw_Frame.alpha = kAlpha.transparent
                            for img in [self.vw_Frame,self.img_Hand,self.img_AnimSequence] {
                                img?.alpha = kAlpha.transparent
                            }
                        }, completion: { (finished: Bool) -> Void in
                            if self.animRunning.isFalse {
                                self.enableReplay(true)
                                return
                            }
                            
                            self.animate_Tips()
                        })
                    })
                })
            })
        })
    }
    
    func animate_Tips() {
// MARK: ├─➤ Description
        UIView.animate(withDuration: (self.animTimingSpeed * 0.75), delay: 0.0, options: [.curveLinear], animations: {
            for view in [self.vw_Tips,self.lbl_TipTitle,self.lbl_Tip1,self.lbl_Tip2,self.lbl_Tip3,self.lbl_Tip4] {
                view?.alpha = kAlpha.opaque
            }
        }, completion: { (finished: Bool) -> Void in
            self.enableReplay(true)
        })
    }

    
// MARK: - *** ACTIONS ***
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func replay(_ sender: UIButton) {
        anim_reset(withAnimations: true)
    }
    

// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    override var prefersStatusBarHidden:Bool { return false }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        sharedFunc.IMAGE().addBlurEffect(view: self.view, style: .dark)
        
        img_Close.image = UIImage(named: "closeX.filled")?.recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        img_Replay.image = #imageLiteral(resourceName: "Replay").recolor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        /* Data */

        /* Animation Initialization */
        sharedFunc.DRAW().addShadow(view: img_Hand, radius: 10, opacity: 0.66)
        img_AnimSequence.animationImages = tapSequenceImages
        img_AnimSequence.animationDuration = 2.0
        img_AnimSequence.animationRepeatCount = 1
        
        /* Localization */
        lbl_TipTitle.text = "InfoOverlay_Title".localized()
        lbl_Tip1.text = "• \("InfoOverlay_Tip1".localized())"
        lbl_Tip2.text = "• \("InfoOverlay_Tip2".localized())"
        lbl_Tip3.text = "• \("InfoOverlay_Tip3".localized())"
        lbl_Tip4.text = "• \("InfoOverlay_Tip4".localized())"
        lbl_Instructions.text = "InfoOverlay_Header".localized()
        
        /* Notifications */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for view in [vw_Frame,lbl_Title,lbl_Decrip] {
            view?.alpha = kAlpha.transparent
        }
        vw_Tips.alpha = showTipsOnly ?kAlpha.opaque :kAlpha.transparent

        anim_reset(withAnimations: true)
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet weak var vw_Tips: UIView!
    @IBOutlet weak var vw_Frame: UIView!
    @IBOutlet weak var vw_OuterFrame: UIView!
    @IBOutlet weak var btn_Close:UIButton!
    @IBOutlet weak var img_Close: UIImageView!
    @IBOutlet weak var btn_Replay:UIButton!
    @IBOutlet weak var img_Replay: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Decrip: UILabel!
    @IBOutlet weak var img_Hand: UIImageView!
    @IBOutlet weak var img_Frame: UIImageView!
    @IBOutlet weak var img_Photo: UIImageView!
    @IBOutlet weak var img_AnimSequence: UIImageView!
    @IBOutlet weak var lbl_TipTitle: UILabel!
    @IBOutlet weak var lbl_Tip1: UILabel!
    @IBOutlet weak var lbl_Tip2: UILabel!
    @IBOutlet weak var lbl_Tip3: UILabel!
    @IBOutlet weak var lbl_Tip4: UILabel!
    @IBOutlet weak var lbl_Instructions: UILabel!

// MARK: - *** DECLARATIONS (Variables) ***
    var tapSequenceImages:[UIImage] = [#imageLiteral(resourceName: "tap_0.png"),#imageLiteral(resourceName: "tap_1.png"),#imageLiteral(resourceName: "tap_2.png"),#imageLiteral(resourceName: "tap_3.png"),#imageLiteral(resourceName: "tap_4.png"),#imageLiteral(resourceName: "tap_5.png"),#imageLiteral(resourceName: "tap_6.png"),#imageLiteral(resourceName: "tap_7.png"),#imageLiteral(resourceName: "tap_8.png"),#imageLiteral(resourceName: "tap_9.png"),#imageLiteral(resourceName: "tap_10.png"),#imageLiteral(resourceName: "tap_11.png"),#imageLiteral(resourceName: "tap_12.png"),#imageLiteral(resourceName: "tap_13.png")]
    var tips:[UILabel]!
    var animRunning:Bool = false
    let animTimingSpeed:TimeInterval = 0.62
    
// MARK: - *** SETTINGS (Calling View Controller) ***
    var showTipsOnly:Bool = true

// MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    
}


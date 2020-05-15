/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_WhatIsNew.swift
 Author: Kevin Messina
Created: July 27, 2015

©2014-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on September 19, 2016.
--------------------------------------------------------------------------------------------------------------------------*/

class cell_WhatsNew:UICollectionViewCell {
    @IBOutlet var imgIcon:UIImageView!
    @IBOutlet var Title:UILabel!
    @IBOutlet var Detail:UITextView!
}

@objc(VC_WhatIsNew) class VC_WhatIsNew:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var Version: String { return "2.00" }
    
    @IBOutlet var btnContinue:UIButton!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblLine:UILabel!
    @IBOutlet var collItems:UICollectionView!

    var arrItems:Array! = []
    var dictItems:NSDictionary! = NSDictionary()
    var gradientColor_Start:UIColor! = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var gradientColor_End:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var color_Text:UIColor! = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var color_Title:UIColor! = #colorLiteral(red: 0.940525949, green: 0.9382938743, blue: 0.9612439275, alpha: 1)
    var font_Title:UIFont!
    var font_CellTitle:UIFont!
    var font_CellText:UIFont!
    var welcomeMsg:String! = "App Highlights"

    
// MARK: - *** INITIALIZER METHODS ***

    
// MARK: - *** ACTIONS ***
    @IBAction func close(_ sender:UIButton){
        dismiss(animated: true)
    }
    

// MARK: - *** COLLECTION METHODS ***
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /* Information */
        let info = arrItems[indexPath.row] as? NSDictionary ?? nil
        if info != nil {
            let title:String! = info!.object(forKey: "title") as? String ?? "n/a"
            let detail:String! = info!.object(forKey: "detail") as? String ?? "n/a"
            let filename:String! = info!.object(forKey: "icon") as? String ?? "n/a"

            if isPad.isTrue {
                let cell_iPad = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWhatsNew_iPad", for: indexPath as IndexPath) as! cell_WhatsNew

                cell_iPad.Title.text = title
                cell_iPad.Detail.text = detail
                cell_iPad.imgIcon.image = UIImage(named: filename)?.withRenderingMode(.alwaysTemplate)
            
                /* Appearance */
                cell_iPad.imgIcon.tintColor = color_Title
                cell_iPad.Title.textColor = color_Title
                cell_iPad.Title.font = UIFont(name: font_CellTitle.fontName, size: isPad.isTrue ?27 :18)
                cell_iPad.Title.textAlignment = isPad.isTrue ? .center : .left
                cell_iPad.Detail.textColor = color_Text
                cell_iPad.Detail.font = UIFont(name: font_CellText.fontName, size: isPad.isTrue ?24 :16)
                cell_iPad.Detail.textAlignment = isPad.isTrue ? .center : .left
                
                /* Force left alignment if bullets */
                if detail.range(of: "•") != nil { cell_iPad.Detail.textAlignment = .left }
                
                return cell_iPad
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWhatsNew", for: indexPath as IndexPath) as! cell_WhatsNew

                cell.Title.text = title
                cell.Detail.text = detail
                cell.imgIcon.image = UIImage(named: filename)?.withRenderingMode(.alwaysTemplate)
            
                /* Appearance */
                cell.imgIcon.tintColor = color_Title
                cell.Title.textColor = color_Title
                cell.Title.font = UIFont.systemFont(ofSize: isPad.isTrue ?24 :15)
                cell.Title.textAlignment = isPad.isTrue ? .center : .left
                cell.Detail.textColor = color_Text
                cell.Detail.font = UIFont(name:Font.HelveticaNeue.Light.regular, size: isPad.isTrue ?20 :12)
                cell.Detail.textAlignment = isPad.isTrue ? .center : .left
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }

    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return gAppColor.isLight() ? .default : .lightContent }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        lblTitle.textColor = color_Title
        lblLine.backgroundColor = color_Text //.withAlphaComponent(0.55)
        btnContinue.tintColor = color_Text //.withAlphaComponent(0.70)

        btnContinue.setImage(btnContinue.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)

        lblTitle.textAlignment = isPad.isTrue.isTrue ?.center :.left
        
        /* Load Defaults */
        let filename = sharedFunc.FILES().dirMainBundle(fileName: appInfo.EDITION.whatsNewFilename)
        let dictItems:NSDictionary! = NSDictionary(contentsOfFile: filename)
        if dictItems != nil {
            arrItems = dictItems.object(forKey: "WhatsNew") as? Array

            /* Look for a 'WHATSNEW_FirstLaunch' status. If yes, change title to reflect App Highlights and drop last item */
            let bFirstLaunch:Bool! = UserDefaults.standard.bool(forKey: "WHATSNEW_FirstLaunch")
            let title:String! = bFirstLaunch.isTrue ?welcomeMsg :"What's New"
            lblTitle.text = title

            if bFirstLaunch.isTrue {
                arrItems.append([
                    "title":"Lots of other features...",
                    "detail":"Please take a few minutes and read the included 'Help' text from screens with the Help Icon shown above.",
                    "icon":"WIN_Tools"
                ])
            }else{
                arrItems.append([
                    "title":"Some Other Stuff...",
                    "detail":"Various other minor changes, fixes and general maintenance.",
                    "icon":"WIN_Tools"
                    ])
            }
        }else{
            sharedFunc.ALERT().show(
                title:"FILE_NotFound_Title".localizedCAS(),
                style:.error,
                msg:"FILE_NotFound_Msg".localizedCAS() + "'\(appInfo.EDITION.whatsNewFilename ?? "n/a")'"
            )

            arrItems = []
        }

        collItems.allowsMultipleSelection = false
        collItems.allowsSelection = false
        collItems.scrollsToTop = true

        /* Load Defaults */
        collItems.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /* Appearance */
        sharedFunc.DRAW().gradientArray(
            view: self.view,
            colorsArray: APPTHEME.gradients.appBackground().colors,
            locationsArray: APPTHEME.gradients.appBackground().locations
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(false, forKey:"WHATSNEW_FirstLaunch")
        UserDefaults.standard.synchronize()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let flowLayout:UICollectionViewFlowLayout! = UICollectionViewFlowLayout()
        if isPad.isTrue && (UIScreen.main.bounds.width > 768) {
            flowLayout.itemSize = CGSize(width:300,height:250)
        }else{
            flowLayout.itemSize = CGSize(width: isPad.isTrue ?344 :collItems.bounds.width - 20,height: isPad.isTrue ?225 :110)
        }
        collItems.setCollectionViewLayout(flowLayout, animated: false)

        /* Select first row */
        let indxPath = IndexPath(item: 0, section: 0)
        collItems.scrollToItem(at: indxPath,at: .top, animated:false)
    }
}

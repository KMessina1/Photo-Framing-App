/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_Help.swift
 Author: Kevin Messina
Created: June 16, 2016

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Updated to Swift 3.0 on September 15, 2016
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** HELP COLLECTIONVIEW ***
class cell_Help_Topic:UICollectionViewCell {
    @IBOutlet var lbl_Topic:UILabel!
    @IBOutlet var img_Icon:UIImageView!
}

// MARK: - *** CLASS DEFINITIONS ***
@objc(VC_Help) class VC_Help:UIViewController,UITextFieldDelegate,
                             UICollectionViewDataSource, UICollectionViewDelegate
                              {
    var Version: String { return "2.00" }

// MARK: - *** FUNCTIONS ***
    func searchTheTextFor(_ search:String){
        if txt_HELP.text.count < 1 { return }
        
        if search.count > 0 {
            let text:NSString! = txt_HELP.text as NSString?
            var range = text.range(of: search)
                range = NSMakeRange(range.location,range.length)

            txt_HELP.selectedRange = range
            txt_HELP.scrollRectToVisible(txt_HELP.firstRect(for: txt_HELP.selectedTextRange!), animated: false)
        }
    }

    /// Highlights plain text.
    func highlightText(_ searchFor:String,hilightColor:UIColor) -> Void {
        let baseString:String! = txt_HELP.text!
        let attributedText = NSMutableAttributedString(string: baseString)
        let attribs:[NSAttributedString.Key:Any] = [
            .backgroundColor:hilightColor
        ]

        do {
            let regex = try NSRegularExpression(pattern: searchFor, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0,baseString.count)

            regex.enumerateMatches(in: baseString,options:NSRegularExpression.MatchingOptions.reportCompletion,range:range,using: {
                (textCheckingResult,matchingFlags,stop) -> Void in
                
                let matchRange:NSRange! = textCheckingResult?.range
                if matchRange != nil {
                    attributedText.addAttributes(attribs,range:matchRange)
                }
            })

            txt_HELP.attributedText = attributedText
        } catch let error as NSError {
            if isSim { print("invalid regex: \(error.localizedDescription)") }
        } catch {
            if isSim { print("Unknown Error.") }
        }
    }
    
    /// Highlights attributed text without disturbing current attributes (except background color).
    func highlightAttributedText(textToSearch searchFor:String,mutableAttribString:NSMutableAttributedString,hilightColor:UIColor) -> NSMutableAttributedString {
        if searchText.length > 0 {
            let attribs:[NSAttributedString.Key:Any] = [
                .backgroundColor:hilightColor
            ]
            
            do {
                let regex = try NSRegularExpression(pattern: searchText!, options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0,searchFor.count)
                
                regex.enumerateMatches(in: searchFor,options:NSRegularExpression.MatchingOptions.reportCompletion,range:range,using: {
                    (textCheckingResult,matchingFlags,stop) -> Void in
                    
                    let matchRange:NSRange! = textCheckingResult?.range
                    if matchRange != nil {
                        mutableAttribString.addAttributes(attribs,range:matchRange)
                    }
                })
                
                return mutableAttribString
            } catch let error as NSError {
                if isSim { print("invalid regex: \(error.localizedDescription)") }
            } catch {
                if isSim { print("Unknown Error.") }
            }
        }

        return mutableAttribString
    }
    
    func setFontSizes() -> Void {
        headerSize = (textSize + 12)
        subHeaderSize = (textSize + 2)
        titleSize = (textSize + 3)
        
        attr_Header = [
            .paragraphStyle:paraCentered_Wrap,
            .font:UIFont(name: "HelveticaNeue-Medium", size: CGFloat(headerSize))!,
            .foregroundColor:headerColor as Any
        ]
        attr_SubHeaderItalic = [
            .paragraphStyle:paraCentered_Wrap,
            .font:UIFont(name: "HelveticaNeue-ThinItalic", size: CGFloat(subHeaderSize))!,
            .foregroundColor:subHeaderColor as Any
        ]
        attr_SubHeader = [
            .paragraphStyle:paraCentered_Wrap,
            .font:UIFont(name: "HelveticaNeue-Thin", size: CGFloat(subHeaderSize))!,
            .foregroundColor:subHeaderColor as Any
        ]
        attr_Title = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-Medium", size: CGFloat(titleSize))!,
            .foregroundColor:titleColor as Any,
            .underlineStyle: NSUnderlineStyle.single
        ]
        attr_TitlePrefix = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-Medium", size: CGFloat(titleSize))!,
            .foregroundColor:titleColor as Any
        ]
        attr_Body = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-Light", size: CGFloat(textSize))!,
            .foregroundColor:bodyColor as Any
        ]
        attr_Links = [
            NSAttributedString.Key.foregroundColor.rawValue: linkColor as Any,
            NSAttributedString.Key.underlineColor.rawValue: linkColor as Any,
            NSAttributedString.Key.underlineStyle.rawValue: NSUnderlineStyle.single
        ]
        attr_SpacerLine = [
            .font:UIFont(name: "HelveticaNeue-Light", size: CGFloat(textSize/3))!
        ]
        attr_SectionTitle = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-CondensedBold", size: CGFloat(textSize - 2))!,
            .foregroundColor:bodyColor as Any
        ]
        attr_SectionBody = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-Light", size: CGFloat(textSize - 2))!,
            .foregroundColor:bodyColor as Any
        ]
        attr_NoteTitle = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-Bold", size: CGFloat(textSize))!,
            .foregroundColor:bodyColor as Any
        ]
        attr_NoteBody = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-LightItalic", size: CGFloat(textSize))!,
            .foregroundColor:bodyColor as Any
        ]
        attr_LinkBody = [
            .paragraphStyle:paraLeft_Wrap,
            .font:UIFont(name: "HelveticaNeue-Light", size: CGFloat(textSize))!,
            .foregroundColor:bodyColor as Any
        ]
    }
    
/// Include a colon : in Note & Section types for special formatting.
    func loopHelpText(_ key:String!,startIndx:Int!,endIndx:Int!,attribs:String!) -> Void {
        var hilightedAttribString:NSMutableAttributedString = NSMutableAttributedString()
        let hiLightColor:UIColor = #colorLiteral(red: 1, green: 0.8015477657, blue: 0.004549824167, alpha: 1).withAlphaComponent(0.5)
        
        let edition = appInfo.EDITION.fullName!
        let website = appInfo.EDITION.URLs().website!
        let twitter = appInfo.EDITION.URLs().twitter!
        let company = appInfo.COMPANY.name!
        
        for i in startIndx...endIndx {
            let topic = "\(key!)\(i)"
            var text = NSLocalizedString(topic, comment: "")
                text = text.replacingOccurrences(of: "(appInfo.COMPANY.Name)", with: company)
                text = text.replacingOccurrences(of: "(appInfo.EDITION.FullName)", with: edition)
                text = text.replacingOccurrences(of: "(appInfo.EDITION.Name)", with: edition)
                text = text.replacingOccurrences(of: "(appInfo.EDITION.Website)", with: website)
                text = text.replacingOccurrences(of: "(appInfo.EDITION.Twitter)", with: twitter)
            
            switch attribs {
                case "Body":
                    hilightedAttribString = NSMutableAttributedString(string:"\(indent!)\(text)\n\n",attributes:attr_Body)
                    allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                case "LinkBody":
                    hilightedAttribString = NSMutableAttributedString(string:"\(text)\n\n",attributes:attr_LinkBody)
                    allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                case "Section" :
                    let foundAt:Int! = text.indexOfCharacter(char: ":")
                    if foundAt != nil {
                        let title = (text as NSString).substring(to: foundAt)
                        let body = (text as NSString).substring(from: foundAt + 1)

                        hilightedAttribString = NSMutableAttributedString(string:"\(title)",attributes:attr_SectionTitle)
                        allText.append(highlightAttributedText(textToSearch:title,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                        hilightedAttribString = NSMutableAttributedString(string:"\(body)\n\n",attributes:attr_SectionBody)
                        allText.append(highlightAttributedText(textToSearch:body,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                    }else{
                        hilightedAttribString = NSMutableAttributedString(string:"\(text)\n\n",attributes:attr_SectionBody)
                        allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                    }
                case "Note":
                    let foundAt:Int! = text.indexOfCharacter(char: ":")
                    if foundAt != nil {
                        let title = (text as NSString).substring(to: foundAt + 1)
                        let body = (text as NSString).substring(from: foundAt + 1)
                        
                        hilightedAttribString = NSMutableAttributedString(string:"\(title)",attributes:attr_SectionTitle)
                        allText.append(highlightAttributedText(textToSearch:title,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                        hilightedAttribString = NSMutableAttributedString(string:"\(body)\n\n",attributes:attr_SectionBody)
                        allText.append(highlightAttributedText(textToSearch:body,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                    }else{
                        hilightedAttribString = NSMutableAttributedString(string:"\(text)\n\n",attributes:attr_SectionBody)
                        allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                    }
                case "Title":
                    allText.append(NSAttributedString(string:"\n",attributes:attr_SpacerLine))

                    let prefix = (text as NSString).substring(with: NSMakeRange(0,2))
                    if  prefix == "§ " {
                        let suffix = (text as NSString).substring(with: NSMakeRange(2,text.count - prefix.count))

                        allText.append(NSAttributedString(string:"\(prefix)",attributes: attr_TitlePrefix))
                        hilightedAttribString = NSMutableAttributedString(string:"\(suffix)\n",attributes:attr_Title)
                        allText.append(highlightAttributedText(textToSearch:suffix,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                    }else{
                        hilightedAttribString = NSMutableAttributedString(string:"\(text)\n",attributes:attr_Title)
                        allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                    }
                    
                    allText.append(NSAttributedString(string:"\n",attributes:attr_SpacerLine))
                case "Header":
                    hilightedAttribString = NSMutableAttributedString(string:"\n\(text)\n",attributes:attr_Header)
                    allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                case "SubHeader":
                    hilightedAttribString = NSMutableAttributedString(string:"\n\(text)\n",attributes:attr_SubHeader)
                    allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                case "SubHeaderItalic":
                    hilightedAttribString = NSMutableAttributedString(string:"\n\(text)\n",attributes:attr_SubHeaderItalic)
                    allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                case "SubHeader_NoCR":
                    hilightedAttribString = NSMutableAttributedString(string:"\n\(text)",attributes:attr_SubHeader)
                    allText.append(highlightAttributedText(textToSearch:text,mutableAttribString:hilightedAttribString,hilightColor:hiLightColor))
                default: ()
            }
        }
    }
    
    func loadHelp(_ key:String){
        var helpKey = key
        
        if helpKey.isEmpty {
            helpKey = arrKeys[0]
        }
        
        let arrHelpComponents:NSMutableArray = NSMutableArray()
        
        let arrItems:[String]! = dictHelp.object(forKey: key) as? [String]
        for item in arrItems {
            arrHelpComponents.add(item)
        }

        arrHelp = NSArray(array: arrHelpComponents) as? [String]
        changeFontSize(slider_FontSize)
    }

    // MARK: - *** ACTIONS ***
    @IBAction func whatsNew(_ sender: UIBarButtonItem){
        let vc = UIStoryboard(name:"WhatsNew",bundle:nil).instantiateViewController(withIdentifier: "VC_WhatIsNew") as! VC_WhatIsNew
            vc.gradientColor_Start = gradientColor_Start
            vc.gradientColor_End = gradientColor_End
            vc.color_Title = WhatsNewcolor_Title
            vc.color_Text = WhatsNewcolor_Text
            vc.font_Title = font_WhatsNewTitle
            vc.font_CellTitle = font_WhatsNewCellTitle
            vc.font_CellText = font_WhatsNewCellText

        present(vc, animated: true)
    }

    @IBAction func changeFontSize(_ sender:UISlider) -> Void {
        textSize = sender.value
        setFontSizes()

        UserDefaults.standard.set(textSize, forKey:"fontSize")
        UserDefaults.standard.synchronize()

        if arrHelp.count < 1 {
            let msg = "\"\(appInfo.EDITION.helpFilename!)\" not found.\n\nPlease Email tech support for assistance by tapping the link below. Remember to include the file name not found.\n\n\(appInfo.COMPANY.SUPPORT.EMAIL.technical!)"
            txt_HELP.attributedText = NSAttributedString(attributedString: NSAttributedString(string:msg,attributes:attr_Body))
            return
        }
        
        allText = NSMutableAttributedString()
        indent = ""
        
        /* Set TOP HEADER */
        allText.append(NSAttributedString(string:"\(appInfo.EDITION.fullName!)\n",attributes:attr_Header))
        allText.append(NSAttributedString(string:"by \(appInfo.COMPANY.name!)\n",attributes:attr_SubHeader))
        allText.append(NSAttributedString(string:"\(appInfo.COMPANY.location!)",attributes:attr_SubHeaderItalic))
        allText.append(NSAttributedString(string:"\n\n",attributes:attr_SpacerLine))

        /* Display all items */
        enum helpItems:Int { case topic,start,end,format }
        for i in 0..<arrHelp.count {
            let arrItem = arrHelp[i].components(separatedBy: "|")
            
            let topic:String = (arrItem[helpItems.topic.rawValue] as String?)!
            let startIndex:Int = Int(arrItem[helpItems.start.rawValue])!
            let endIndex:Int = Int(arrItem[helpItems.end.rawValue])!
            let format:String = (arrItem[helpItems.format.rawValue] as String?)!
            let key:String = "Help(\(gAppID))_\(topic)_"

            loopHelpText(key,startIndx:startIndex,endIndx:endIndex,attribs:format)
        }
        
        /* Set Links to be bolded in text */
        allText.setAsLink(textToFind: appInfo.EDITION.URLs().twitter!,linkURL: appInfo.EDITION.URLs().twitter!, font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: appInfo.EDITION.URLs().website!,linkURL: appInfo.EDITION.URLs().website!, font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: kDeveloper.URL!,linkURL: kDeveloper.URL!, font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        /* Add Links to text */
        allText.setAsLink(textToFind: "Visit our website",linkURL: appInfo.COMPANY.WEBSITE_URLS.company!, font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: true)
        allText.setAsLink(textToFind: "iTunes App Store",linkURL: appInfo.EDITION.appStore.URL, font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: true)
        /* Custom Links */
        
        txt_HELP.attributedText = allText!

        searchTheTextFor(searchText!)
    }
    
    @IBAction func close(_ sender: UIBarButtonItem){
        txtSearch.resignFirstResponder()
        
        sharedFunc.THREAD().doInBackgroundAfterDelay(delay: 0.1, perform:{
            self.dismiss(animated: true)
        })
    }
   
// MARK: - *** COLLECTION METHODS ***
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrKeys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:cell_Help_Topic! = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_Help_Topic", for: indexPath as IndexPath) as? cell_Help_Topic
        sharedFunc.DRAW().roundCorner(view:cell,radius:10.0,color:.darkGray,width:1.0)
        
        let key = arrKeys[indexPath.row] as String
        cell.lbl_Topic.text = "Help(\(gAppID))_Key_\(key)".localized()
        let img:UIImage! = UIImage(named:arrImages[indexPath.row] as String) ?? UIImage()
        cell.img_Icon.image = sharedFunc.IMAGE().recolorImage(img: img,color:#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtSearch.resignFirstResponder()
        
        searchText = ""
        txtSearch.text = ""
        txt_HELP.text = ""
        
        self.loadHelp(self.arrKeys[indexPath.row] )

        sharedFunc.THREAD().doAfterDelay(delay: 0.1, perform: {
            self.txt_HELP.scrollRangeToVisible(NSMakeRange(0,1))
        })
    }


// MARK: - *** SCROLL METHODS ***


// MARK: - *** TEXTFIELD METHODS ***
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchText = txtSearch.text!
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchText = ""
        txtSearch.text = ""
        changeFontSize(slider_FontSize)
        
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var sText:String = textField.text!

        if (string == "\n") {
            /* Exit on RETURN key, Save the values before leaving into temp dict. */
            textField.resignFirstResponder()
            
            return true
        }else if string.isEmpty {
            /* With DELETE or BACKSPACE KEY, remove one character from text */
            if sText.count > 0 {
                sText = (sText as NSString).replacingCharacters(in: range, with: string)
            }
        }else{
            /* Update the label of selected segment with new text. */
            sText = (sText as NSString).replacingCharacters(in: range, with: string)
        }

        searchText = sText
        changeFontSize(slider_FontSize)
        
        return true
    }


// MARK: - *** NOTIFICATIONS ***
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardHt = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
            else {
                return
        }
        
        var vwFrame:CGRect! = txt_HELP.frame
            vwFrame.size.height = (vwFrame.height - keyboardHt) + 50
        
        txt_HELP.frame = vwFrame
   }
    
    @objc func keyboardDidShow(_ sender: Notification) {
        guard let keyboardHt = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
            else {
                return
        }

        var vwFrame:CGRect! = txt_HELP.frame
            vwFrame.size.height = (vwFrame.height - keyboardHt) + 50
        
        txt_HELP.frame = vwFrame
    }
     
    @objc func keyboardWillHide(_ sender: Notification) {
        guard let keyboardHt = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
            else {
                return
        }
        
        var vwFrame:CGRect! = txt_HELP.frame
            vwFrame.size.height = (vwFrame.height + keyboardHt) - 50
        
        txt_HELP.frame = vwFrame
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
        slider_FontSize.minimumTrackTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        slider_FontSize.maximumTrackTintColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        slider_FontSize.minimumValue = isPad.isTrue ?18 :12
        slider_FontSize.maximumValue = isPad.isTrue ?36 :30

        /* Initialize */
        txtSearch.delegate = self
        txt_HELP.textContainerInset = isPad.isTrue ?UIEdgeInsets.init(top: 15.0,left: 15.0,bottom: 15.0,right: 15.0)
                                            :UIEdgeInsets.init(top: 5.0,left: 5.0,bottom: 5.0,right: 5.0)

        /* Set Paragraph Stlye */
        paraCentered_Wrap.lineBreakMode = .byWordWrapping
        paraCentered_Wrap.alignment = .center
        paraLeft_Wrap.lineBreakMode = .byWordWrapping
        paraLeft_Wrap.alignment = .left
        paraLeft_Justify.lineBreakMode = .byWordWrapping
        paraLeft_Justify.alignment = .justified
        
        /* Load defaults */
        searchText = ""
        let filename = sharedFunc.FILES().dirMainBundle(fileName: appInfo.EDITION.helpFilename)
        dictHelp = NSDictionary(contentsOfFile:filename) ?? nil

        /* Load Help Keys */
        if dictHelp == nil {
            NSLog("ERROR: Can't find %@ file.", [filename])
        }
        
        arrKeys = (dictHelp.object(forKey: "Keys") as! Array<String>).first!.components(separatedBy: "|")
        arrImages = (dictHelp.object(forKey: "Images") as! Array<String>).first!.components(separatedBy: "|")
        
        /* Set initial HELP font size */
        textSize = sharedFunc.DEFAULTS().getFloat(key: "fontSize",minValue:slider_FontSize.minimumValue,
                                                                  maxValue:slider_FontSize.maximumValue)
        slider_FontSize.value = textSize
        loadHelp(arrKeys[0])
        collTopics.reloadData()
        setFontSizes()
        changeFontSize(slider_FontSize)
        
        /* Set TextView Link Appearance NOTE: Font can't be changed from LinkTextAttributes */
        txt_HELP.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(attr_Links)
        
        /* Localization */
        lbl_Topics.text = "Help(\(gAppID))_Topics".localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /* Appearance */
        sharedFunc.DRAW().gradientArray(
            view: self.view,
            colorsArray: APPTHEME.gradients.appBackground().colors,
            locationsArray: APPTHEME.gradients.appBackground().locations
        )
        navBar.tintColor = headerColor
        toolbar_Bottom.tintColor = headerColor
        sharedFunc.DRAW().roundCorner(view: txt_HELP,radius:10,color:headerColor.withAlphaComponent(0.75),width:2)
        sharedFunc.DRAW().roundCorner(view: collTopics,radius:10,color:headerColor.withAlphaComponent(0.75),width:2)
        lbl_Topics.textColor = headerColor
        btnWhatsNew.tintColor = headerColor
        btn_Done.tintColor = headerColor
        btn_Done.image = show_CloseAsBack ?#imageLiteral(resourceName: "Help_Back") :#imageLiteral(resourceName: "Help_Close")
        txtSearch.tintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)

        slider_FontSize.tintColor = headerColor
        slider_FontSize.minimumValueImage = #imageLiteral(resourceName: "Font_Small").recolor(headerColor)
        slider_FontSize.maximumValueImage = #imageLiteral(resourceName: "Font_Large").recolor(headerColor)
        slider_FontSize.thumbTintColor = headerColor
        
        /* Notifications */
        let NC = NotificationCenter.default
        NC.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NC.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Notifications */
        let NC = NotificationCenter.default
        NC.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NC.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* Reset text view scroll area to always go to top */
        sharedFunc.THREAD().doAfterDelay(delay: 0.01, perform: {
            self.txt_HELP.scrollRangeToVisible(NSMakeRange(0,1))
        })
        
        lbl_Topics.transform = CGAffineTransform(rotationAngle: CGFloat(sharedFunc.DRAW().degreesToRadians(degrees: Double(270))))
        
        txtSearch.frame.size.width = navBar.frame.size.width - 100
        slider_FontSize.frame.size.width = toolbar_Bottom.frame.size.width - (isPad.isTrue ?175 :140)
    }


    // MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var txt_HELP:UITextView!
    @IBOutlet var slider_FontSize:UISlider!
    @IBOutlet var btn_Done:UIBarButtonItem!
    @IBOutlet var btnWhatsNew:UIBarButtonItem!
    @IBOutlet var collTopics:UICollectionView!
    @IBOutlet var lbl_Topics:UILabel!
    @IBOutlet var txtSearch:UITextField!
    @IBOutlet var navBar:UINavigationBar!
    @IBOutlet var toolbar_Bottom:UIToolbar!
    
    // MARK: - *** DECLARATIONS (Variables) ***
    var paraCentered_Wrap = NSMutableParagraphStyle(),paraLeft_Wrap = NSMutableParagraphStyle(),
        paraLeft_Justify = NSMutableParagraphStyle()
    var attr_Links:[String:Any]!
    var attr_Header,attr_Title,attr_SubHeader,attr_Body,attr_SpacerLine,attr_SectionTitle,attr_SectionBody,
        attr_NoteTitle,attr_NoteBody,attr_LinkBody,attr_SubHeaderItalic,attr_TitlePrefix:[NSAttributedString.Key:Any]!
    var textSize,titleSize,subHeaderSize,headerSize:Float!
    var indent:String!
    var allText:NSMutableAttributedString!
    var arrHelp,arrKeys,arrImages:Array<String>!
    var dictHelp:NSDictionary!
    var searchText:String! = ""
    var isScrolling:Bool! = false

    /* These variables should be set prior to displaying in the presentViewController function of the caller VC */
    /* Appearance */
    var headerColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var titleColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var subHeaderColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var bodyColor:UIColor! = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var linkColor:UIColor! = #colorLiteral(red: 0, green: 0.4812201262, blue: 0.9983773828, alpha: 1)
    var barTintColor:UIColor! = #colorLiteral(red: 0.5601567626, green: 0.5578907132, blue: 0.5808923841, alpha: 1)
    
    /* These variables are passed to What's New */
    /* Appearance */
    var gradientColor_Start:UIColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var gradientColor_End:UIColor! = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
    var color_Text:UIColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var color_Title:UIColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var font_WhatsNewTitle:UIFont!
    var font_WhatsNewCellTitle:UIFont!
    var font_WhatsNewCellText:UIFont!
    var WhatsNewcolor_Text:UIColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var WhatsNewcolor_Title:UIColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var show_CloseAsBack:Bool = false
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

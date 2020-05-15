/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_getStarted.swift
 Author: Kevin Messina
Created: January 26, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

import Siren

// MARK: - *** GLOBAL CONSTANTS ***

class VC_getStarted:
    UIViewController,
    UIPopoverPresentationControllerDelegate,
    UIActionSheetDelegate,
    UIViewControllerTransitioningDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate,
    iCarouselDataSource,iCarouselDelegate
{
                    
    // MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }

    fileprivate func updateScreenItems(){
        vw_Carousel.reloadData()
        updateItemLabel()
    }
    
    func setItemsAsBlank() {
        item = Item.init()
        item.photo = noPhotoSelected[0]
    }
    
    func updateCartCount() {
        let itemCount:Int = (localCart != nil) ?localCart.itemCount :0
        var img = UIImage.init()
        let cartHasItems = (itemCount > 0)
        
        lbl_CartCount.text = (itemCount > 0) ?"\(itemCount)" :""

        img = isPad
            ?cartHasItems ?#imageLiteral(resourceName: "Cart_LG") :#imageLiteral(resourceName: "Empty_LG")
            :cartHasItems ?#imageLiteral(resourceName: "Cart") :#imageLiteral(resourceName: "EmptyCart")

        btn_Cart.setImage(img.recolor(gAppColor), for: .normal)
    }

    func selectPhotoFromLibrary() {
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = ["public.image"] //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imgPicker.modalPresentationStyle = .fullScreen
        
        present(imgPicker, animated: true)
    }

    func showPhotoBrowser(source: photoSource){
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable(simulateOff:kSimulateNoInternet) { return }

        switch source {
            case .UNSELECTED: ()
            case .PHOTOS:
                photoLibrary().requestForAccess(vc:self, completionHandler: { Void in
                    if photoLibrary().authorizedAccess().isTrue {
                        self.selectPhotoFromLibrary()
                    }
                })
        }
    }
    
    func buildItemDetails() -> (
        frameColor:String,
        photoSize:String,
        framedSize:String,
        SKU:String,
        price:Double,
        formattedPrice:String,
        format:String,
        colorIndex:Int,
        frameSizeIndex:Int,
        style:String,
        styleCode:String
    ) {
        rebuildSKU(colorIndx: item.color)

        let frameColor:String = Frames.products().returnProductColor(SKU: item.SKU!).name
        let photoSize:String = Frames.products().returnProductPhotoSize(SKU: item.SKU!).name
        let framedSize:String = Frames.products().returnProductFramedSize(SKU: item.SKU!).name
        let price:Double = Frames.products().returnProductPrice(SKU: item.SKU!).price
        let formattedPrice:String = Frames.products().returnProductPrice(SKU: item.SKU!).formatted
        let format:String = Frames.products().returnProductShape(SKU: item.SKU!).name
        let style:String = Frames.products().returnProductStyle(SKU: item.SKU!).name
        let styleCode:String = Frames.products().returnProductStyle(SKU: item.SKU!).code

        return (frameColor,photoSize,framedSize,item.SKU!,price,formattedPrice,format,item.color!,item.size!,style,styleCode)
    }
    
    func updateItemLabel() {
        let itemDetails = buildItemDetails()
        
        // Display Frame Info
        let frameText:String = "framed".localized()
        let photoText:String = "photo".localized().capitalized
        let sizeText:String = "size".localized().capitalized
        let color:String = itemDetails.frameColor.localized()
        let format:String = itemDetails.format.localized()
        let photoSize:String = itemDetails.photoSize
        let framedSize:String = itemDetails.framedSize
        let price = itemDetails.formattedPrice
        var style:String = itemDetails.style.localized()

// MARK: ├─➤ Append NEW! if before Exp. date
        if itemDetails.styleCode.uppercased() == "SL" {
            let currentDate = Date()
            let expDate = "01/01/2019".convertToDate(format: kDateFormat.MMddyyyy)
            let isNew = (expDate > currentDate)
            if isNew { style = "\( "New!".localized().uppercased() ) \( style )" }
        }
            
        lbl_Title1.text = "\(color) \(format) \(photoSize) \(photoText)"
        lbl_Title2.text = "\(style) (\(frameText) \(sizeText) \(framedSize))"
        lbl_Title3.text = "\(price)"
        let orientation = item.photo.isSquare
            ?"Square"
            :item.photo.isPortrait ?"Portrait" :"Landscape"
        
        simPrint().info("\n🎠 CAROUSEL ITEM: \(lbl_Title1.text!) - \(lbl_Title2.text!) - \(lbl_Title3.text!) - \(orientation)",function:#function,line:#line)
    }
    
    func animateCart(_ img:UIImage,cellFrame:CGRect){
        let topCartPosition = CGPoint(x:self.vw_Topbar.frame.origin.x + self.btn_Cart.center.x + (self.btn_Cart.frame.size.width / 3),
                                      y:self.vw_Topbar.frame.origin.y + self.btn_Cart.frame.origin.y + (self.btn_Cart.frame.size.height / 2))
        let bottomCartPosition = self.vw_Carousel.center
        let obj = UIImageView(frame: cellFrame)
            obj.contentMode = .scaleAspectFit
            obj.image = img
            obj.center = topCartPosition
            obj.alpha = kAlpha.solid
        self.view.addSubview(obj)

        let path = UIBezierPath()
            path.move(to: bottomCartPosition)
            path.addCurve(to: obj.center, controlPoint1: CGPoint(x: bottomCartPosition.x - 50, y: topCartPosition.y / 4), controlPoint2: CGPoint(x: bottomCartPosition.x + 50, y: topCartPosition.y / 6))

        let anim = CAKeyframeAnimation(keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = CAAnimationRotationMode.rotateAuto
            anim.repeatCount = 0
            anim.duration = 0.75
            anim.isRemovedOnCompletion = true

        obj.layer.add(anim, forKey: "animate position along path")

        UIView.animate(withDuration: anim.duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            obj.alpha = kAlpha.half
            obj.frame = CGRect(x:topCartPosition.x, y:topCartPosition.y,width: 0,height: 0)
            }, completion: { (value: Bool) in
        })
        
        /* Update the app cart count */
        self.updateCartCount()
        waitHUD().hideNow()
    }

    func loadSelectedPhoto() {
        if sharedFunc.FILES().exists(filePathAndName: selectedPhotoFilepath) {
            item.photo = UIImage(contentsOfFile: selectedPhotoFilepath) ?? noPhoto_Square

            Photo.selectedPhoto.keyChain().load()
            item.photoInfo = Photo.init(
                name:selectedPhoto.filename,
                url:selectedPhoto.photoURL
            )
        }else{
            item.photoInfo = Photo.init()
            item.photo = noPhoto_Square
        }

        updateScreenItems()
    }

    /// Uses item.color as key to find the SKU
    func rebuildSKU(colorIndx:Int) {
        item.color = colorIndx
        item.SKU = Products().returnNewSKUforItem()
        item.frame = Frames.products().returnProductImg(SKU: item.SKU!)
        
        selectedColor = colorIndx
    }
    
// MARK: - *** ACTIONS ***
    @IBAction func viewCart(_ sender:UIButton){
        slideMenuController()?.toggleRight()
    }

    @IBAction func info(_ sender: Any) {
        let vc = gBundle.instantiateViewController(withIdentifier: "VC_infoOverlay") as! VC_infoOverlay
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.showTipsOnly = true
        
        self.present(vc, animated: true)
    }
    
    @IBAction func details(_ sender: Any) {
        let vc = gBundle.instantiateViewController(withIdentifier: "VC_FrameInfo") as! VC_FrameInfo
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overCurrentContext
            vc.frameColor = vw_Carousel.currentItemIndex

        self.present(vc, animated: true)
    }
    
    @IBAction func addToCart(_ sender:UIButton){
        if (sharedFunc.NETWORK().displayMsgIfNotAvailable().isFalse || isPhotoSelected().isFalse) { return }

// MARK: ├─➤ Validate Photo URL's
        /* If for some reason photo is unlinked from information */
        if selectedPhoto == nil || selectedPhoto.filename.isEmpty {
            appFunc.keychain.SELECTED_PHOTO().get()
            if selectedPhoto == nil || selectedPhoto.filename.isEmpty {
                sharedFunc.ALERT().show(
                    title:"Cart_AddErrorPhoto_Title".localizedCAS(),
                    style:.error,
                    msg:"Cart_AddErrorPhoto_Msg".localizedCAS()
                )
                btn_AddToCart.isEnabled = false
                
                SelectedPhoto().resetSelectedPhoto()
                PhotoManager.shared[selectedPhotoFilename] = nil // We save the image to the disk.

                return
            }
        }

// MARK: ├─➤ Validate Products loaded
        /* Are products loaded from Server? */
        if CMS_products.count < 1 {
            sharedFunc.ALERT().show(
                title:"Cart_AddError_Title".localized(),
                style:.error,
                msg:"Cart_AddError_Msg".localized()
            )
            btn_AddToCart.isEnabled = false
            Frames().loadComponents { (success) in return }

            return
        }

// MARK: ├─➤ Product in Stock?
        rebuildSKU(colorIndx: vw_Carousel.currentItemIndex)
        var qtyToAdd = 1
        var stockLevel:Int = 0

        /* Is in Stock? & get Updated price */
        Frames.products().inStock(showMsg: true, SKU: item.SKU!) { (success, matches, error) in
            if matches.count > 0 {
                let product = matches.first!
                stockLevel = product.qty.intValue
                item.price = product.price.doubleValue
            }

            /* Validate sufficient Stock Level in inventory */
            if stockLevel < qtyToAdd {
                sharedFunc.ALERT().show(
                    title:"Order_OutOfStock_Title".localizedCAS(),
                    style:.error,
                    msg:"Order_OutOfStock_Msg".localizedCAS()
                )
                waitHUD().hideNow()

                return
            }

// MARK: ├─➤ Product in Cart? Increase qty for SKU in cart.
            /* Already in cart? */
            waitHUD().showNow(msg:"WAIT_PRODUCTS_INFO".localizedCAS())

            let photoURL = tempItem.photoInfo?.url ?? "" // Used as photo unique ID even if product SKU is same in order.
            let match = localCart.hasItem(SKU: item.SKU, instagramImageURL: photoURL)
            if match.found { qtyToAdd += match.qty }

// MARK: ├─➤ Create product thumbnail image.
            /* Take screenshot for thumbnail */
            guard let cell = self.vw_Carousel.itemView(at: self.vw_Carousel.currentItemIndex)
            else {
                sharedFunc.ALERT().show(
                    title:"IMAGE_SaveThumbError_Title".localizedCAS(),
                    style:.error,
                    msg:"IMAGE_SaveThumbError_Msg".localizedCAS()
                )
                waitHUD().hideNow()
                return
            }

            let img = sharedFunc.IMAGE().screenShotWithTransparency(view: cell)

            /* Save thumbnail screenshot */
            let thumbnailFilename = "thumbnail_\( item.SKU! )_\( selectedPhoto.filename! )"
            let thumbnailURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(thumbnailFilename)
            try? img.jpegData(compressionQuality: 1.0)?
                    .write(to: thumbnailURL, options: .atomic)

            /* Copy selected to item Photo */
            let photoFilename = "photo_\( item.SKU! )_\( selectedPhoto.filename! )"
            let PhotoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(photoFilename)

            if sharedFunc.FILES().exists(filePathAndName: selectedPhotoFilepath).isTrue {
                do {
                    try FileManager.default.copyItem(
                        atPath: selectedPhotoFilepath,
                        toPath: PhotoURL.path
                    )
                    simPrint().success("Photo file copied to: \( photoFilename )",function:#function,line:#line)
                } catch let error1 as NSError {
                    simPrint().error("Photo file NOT copied to: \( photoFilename ). Error:  \( error1 ) ",function:#function,line:#line)
                }
            }

// MARK: ├─➤ prepare cart item.
            /* Prepare for adding to cart */
            waitHUD().showNow(msg:"WAIT_UPDATING_CART".localizedCAS())
            item.quantity = qtyToAdd
            item.amount = item.price * Double(item.quantity)

            /* Create cart item with Qty (incase update if already in cart) */
            let newCartItem = LocalCartItem.init(
                frame_size: item.size,
                frame_color: item.color,
                frame_shape: item.format,
                frame_style: item.style,
                matte_color: item.matteColor,
                frame_material: item.material,
                photo_ThumbnailFileName: thumbnailFilename,
                photo_FullSizeFileName: photoFilename,
                instagramImageURL: photoURL,
                quantity: item.quantity,
                price: Decimal(item.price),
                amount: Decimal(item.amount),
                SKU: item.SKU
            )

            if match.found.isTrue {
                if localCart.updateItem(cartItem:newCartItem,qtyToChange: 1).isFalse{
                    sharedFunc.ALERT().show(
                        title:"Cart_AddError_Title".localized(),
                        style:.error,
                        msg:"Cart_AddError_Msg".localized()
                    )
                    waitHUD().hideNow()

                    return
                }
            }else{
                localCart.addItem(cartItem:newCartItem)
            }

            self.animateCart(img, cellFrame: cell.frame)
            self.updateCartCount()
            AppDelegate().saveCurrentSessionData()
            waitHUD().hideNow()
        }
    }

    @IBAction func showMenu(_ sender:UIButton){
        slideMenuController()?.toggleLeft()
    }

    
// MARK: - *** iCAROUSEL METHODS ***
    func numberOfItems(in carousel: iCarousel) -> Int {
        return CMS_frame_colors.count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemFrame = UIImageView.init()
        var itemPhoto = UIImageView.init()
        var itemPhotoTap = UIImageView.init()
        var frameSize:CGSize = CGSize.zero
        var photoSize:CGSize = CGSize.zero
        let itemViewSize:CGFloat = carousel.frame.size.width - (isPad ?240 :80)
        let itemView = UIView(frame:CGRect(x:0, y:0, width:itemViewSize, height:itemViewSize))
        let colorIndex = index

        /* Determine the size of frames/Photos in cell displayed according to item.size */
        rebuildSKU(colorIndx: colorIndex)
        let sizeIndex = Products().returnOffsetItemSize().newIndex
        if isPhotoSelected().isFalse {
            item.photo = (sizeIndex < CMS_Frames_Square.count) ?noPhoto_Square :noPhoto_Rect
        }

// MARK: ├───➤ Set display size of frames/photos
        var modifierSize:CGFloat = isPad ?100 :50.0
        let modifierRatio:CGFloat = item.photo.isSquare ?1.0 :0.75 //1:1 //Used for changing scale
        var modifierPhotoRatio:CGFloat = isPad ?0.550 :0.525

        if item.photo.isSquare.isFalse {
            modifierSize = isPad ?90.0 :30.0
            modifierPhotoRatio = item.photo.isPortrait
                ?isPad ?0.66 :0.60
                :isPad ?0.58 :0.52
        }

        if let SIZE = Frame_Size_All(rawValue: sizeIndex) {
            switch SIZE { //smaller modifierSize = larger on screen size.
            case .square_5x5: modifierSize = (modifierSize * 0.75)
            case .square_8x8: modifierSize = (modifierSize * 0.25)
            case .rect_5x7: modifierSize = (modifierSize * 0.66)
            case .rect_8x10: modifierSize = 0
            default: ()
            }
        }
        
        let w:CGFloat = itemViewSize - modifierSize
        let h:CGFloat = w * modifierRatio
        frameSize = CGSize(
            width: item.photo.isSquare
                ?w
                :w - (w * 0.05),
            height: h
        )
        photoSize = CGSize(
            width: item.photo.isSquare
                ?w * modifierPhotoRatio
                :w * (modifierPhotoRatio - 1.13),
            height: item.photo.isSquare
                ?h * modifierPhotoRatio
                :h * (modifierPhotoRatio + 0.01)
        )
 
// MARK: ├───➤ Set display size of frames/photos
        itemFrame = UIImageView(frame:CGRect(
            x: 10,
            y: 10,
            width: item.photo.isPortrait
                ?frameSize.height + (frameSize.height * 0.10)
                :frameSize.width,
            height: item.photo.isPortrait
                ?frameSize.width + (frameSize.width * 0.10)
                :frameSize.height
            )
        )
        
        itemPhoto = UIImageView(frame: CGRect(
            x: 55,
            y: 55,
            width: item.photo.isPortrait
                ?photoSize.height // - (photoSize.height * 0.05)
                :photoSize.width,
            height: item.photo.isPortrait
                ?photoSize.width + (photoSize.width * 0.30)
                :photoSize.height
        ))

        // Drawing Mode
        itemFrame.contentMode = .scaleAspectFit
        itemPhoto.contentMode = .scaleToFill
        
// MARK: ├───➤ Draw Frame
        itemFrame.image = sharedFunc.IMAGE().resizeImage(
            image: item.frame,
            toSize: frameSize,
            ignoreScale: false
        )
        itemFrame.backgroundColor = .white

// MARK: ├───➤ Testing frame/photo dimensions with Visual Debugger
        if (isAdhoc.isTrue && debugShowCarouselColors.isTrue) {
            itemPhoto.backgroundColor = .red
            let itemColors:[UIColor] = [.yellow,.green,.blue,.orange,.purple]
            itemView.backgroundColor = itemColors[index].withAlphaComponent(0.33)
            carousel.backgroundColor = .gray
        }else{
            itemPhoto.backgroundColor = .clear
            itemView.backgroundColor = .clear
            carousel.backgroundColor = .clear
        }
        
        // Draw Tap Button
        itemPhotoTap = UIImageView(frame: itemPhoto.frame)
        itemPhotoTap.image = nil
        itemPhotoTap.isOpaque = false
        itemPhotoTap.backgroundColor = .clear
        
// MARK: ├───➤ Rotate Frame Image if PORTRAIT
        if (item.photo.isPortrait && (itemFrame.image?.size != CGSize.zero)) {
            itemFrame.image = itemFrame.image?.rotatedByDegrees(degrees: 90)
        }
        
// MARK: ├───➤ Draw Photo
        itemPhoto.image = item.photo
        
// MARK: ├───➤ Center Images
        itemFrame.center = itemView.center
//        itemFrame.center = CGPoint(x: itemView.center.x, y: (itemFrame.frame.height / 2)) // Top align view in Carousel
        itemPhoto.center = item.photo.isSquare
            ?itemFrame.center
            :item.photo.isPortrait
                ?CGPoint(x: itemView.center.x - 1 , y: itemView.center.y + 1)
                :CGPoint(x: itemView.center.x - 1, y: itemView.center.y - 1)
        itemPhotoTap.center = itemPhoto.center
        
// MARK: ├───➤ Add Tap Gestures
        itemFrame.isUserInteractionEnabled = true
        itemFrame.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "tap_Preview:", delegate: self, numTaps: 1))

        itemPhotoTap.isUserInteractionEnabled = true
        itemPhotoTap.addGestureRecognizer(sharedFunc.GESTURES().returnTap(selector: "tap_ChangePhoto:", delegate: self, numTaps: 1))

// MARK: ├───➤ Add outlines
        sharedFunc.DRAW().strokeBorder(view: itemPhoto, color: .black, width: 0.75)
        
// MARK: ├───➤ Add subviews to cell
        itemView.addSubview(itemFrame)
        itemView.addSubview(itemPhoto)
        itemView.addSubview(itemPhotoTap)

// MARK: ├───➤ Add GESTURES to cell
        itemView.isUserInteractionEnabled = true
        itemView.addGestureRecognizer(sharedFunc.GESTURES().returnSwipe(selector:"swipe_Up:",delegate:self,direction:.up,numTouches:1,cancelTouches: true))
        itemView.addGestureRecognizer(sharedFunc.GESTURES().returnSwipe(selector:"swipe_Down:",delegate:self,direction:.down,numTouches:1,cancelTouches: true))

        return itemView
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        rebuildSKU(colorIndx: carousel.currentItemIndex)

        updateItemLabel()
    }
    
 
    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertView, animated: true)
    }

    
// MARK: - *** IMAGE PICKER ***
    func resizeImgIfTooLarge(_ imgToResize:UIImage) ->UIImage {
        let chosenImage = imgToResize
        
        // TODO: ⚙️(Fix) Image Resizing
        //        /* Resize image if larger than necessary */
        //        if chosenImage.isSquare {
        //            if chosenImage.size.height > photoPixelSizes.max.square.height || chosenImage.size.width > photoPixelSizes.max.square.width {
        //                chosenImage = sharedFunc.IMAGE().resizeImage(
        //                    image: chosenImage,
        //                    toSize: photoPixelSizes.max.square,
        //                    ignoreScale: true
        //                )
        //                if isSim { print("Square photo resized to max size.") }
        //            }
        //        }else if chosenImage.isPortrait {
        //            if chosenImage.size.height > photoPixelSizes.max.rect.width || chosenImage.size.width > photoPixelSizes.max.rect.height {
        //                chosenImage = sharedFunc.IMAGE().resizeImage(
        //                    image: chosenImage,
        //                    toSize: CGSize(width:photoPixelSizes.max.rect.height,height:photoPixelSizes.max.rect.width),
        //                    ignoreScale: true
        //                )
        //                if isSim { print("Rect Portrait resized to max size.") }
        //            }
        //        }else{
        //            if chosenImage.size.height > photoPixelSizes.max.rect.height || chosenImage.size.width > photoPixelSizes.max.rect.width {
        //                chosenImage = sharedFunc.IMAGE().resizeImage(
        //                    image: chosenImage,
        //                    toSize: photoPixelSizes.max.rect,
        //                    ignoreScale: true
        //                )
        //                if isSim { print("Rect Landscape photo resized to max size.") }
        //            }
        //        }
        
        return chosenImage
    }
    
    func rotateImgIfFromIphone(_ imgToRotate:UIImage) -> UIImage {
        var chosenImage = imgToRotate
        
        /* If the photo was taken on the iPhone Camera, then check for it's rotation discrepancy and correct it */
        if (chosenImage.isPortrait.isTrue && (chosenImage.imageOrientation != .up)) ||
            (chosenImage.isSquare.isTrue && (chosenImage.imageOrientation != .up)) {
            
            UIGraphicsBeginImageContextWithOptions(chosenImage.size, false, chosenImage.scale)
            let rect = CGRect(x: 0, y: 0, width: chosenImage.size.width, height: chosenImage.size.height)
            chosenImage.draw(in: rect)
            chosenImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            if isSim { print("Photo rotated 90 degress.") }
        }
        
        return chosenImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard var chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            sharedFunc.ALERT().show(
                title: "IMAGE_GetError_Title".localizedCAS(),
                style: .error,
                btnText: "OK".localizedCAS(),
                msg: "IMAGE_GetError_Msg".localizedCAS()
            )
            
            picker.dismiss(animated: true)
            return
        }

        waitHUD().showNow(msg: "photoSource.processing".localized())
        simPrint().info("\( print(info) )",function:#function,line:#line)
        
        /* Manipulate Img if needed */
        chosenImage = resizeImgIfTooLarge(chosenImage)
        chosenImage = rotateImgIfFromIphone(chosenImage)
        
        let fileName = selectedPhotoFilename
        
        do {
            let fileURL = try! FileManager.default
                .url(for: .documentDirectory,in: .userDomainMask,appropriateFor: nil,create: false)
                .appendingPathComponent(fileName)
            
            try chosenImage.pngData()?
                .write(to: fileURL, options: .atomic)

            let photoLOCATIONURL = (info[UIImagePickerController.InfoKey.imageURL] as? URL)
            let photoURL =  photoLOCATIONURL?.absoluteString ?? ""
            let photoName =  photoLOCATIONURL?.lastPathComponent ?? ""
            
            tempItem.photo = chosenImage
            tempItem.photoInfo = Photo.init(name: photoName, url: photoURL)
           
            selectedPhoto = SelectedPhoto.init(filename: tempItem.photoInfo.name, photoURL: tempItem.photoInfo.url)
            if isSim { print("Photo saved") }
        } catch {
            sharedFunc.ALERT().show(
                title: "IMAGE_SaveError_Title".localizedCAS(),
                style: .error,
                btnText: "OK".localizedCAS(),
                msg: "IMAGE_SaveError_Msg".localizedCAS() + "\(fileName)'."
            )
            if isSim { print("Photo error") }
        }
        
        item.photo = tempItem.photo

        appFunc.keychain.SELECTED_PHOTO().save()
        waitHUD().hideNow()

        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
// MARK: - *** GESTURES ***
    @objc func tap_showDebugMenu(_ sender:UILongPressGestureRecognizer){
        if isAdhoc.isFalse { return }

        switch sender.state {
            case .began:
                let actSheet = sharedFunc.actSheet().setup(vc: self,title: "R&D Debug Menu")
                
                actSheet.addAction(UIAlertAction(title:"Toggle Carousel Background", style: .default, handler:{ action in
                    self.debugShowCarouselColors.toggle()
                    self.updateScreenItems()
                }))

                actSheet.addAction(UIAlertAction(title:"Reset Seleted Photo", style: .default, handler:{ action in
                    sharedFunc.FILES().delete(filePathAndName: selectedPhotoFilepath)
                    selectedPhoto = SelectedPhoto.init()
                    self.setItemsAsBlank()
                    tempItem.photo = item.photo
                    self.vw_Carousel.currentItemIndex = 0
                    self.selectedColor = 0
                    self.updateScreenItems()
                }))

                actSheet.addAction(UIAlertAction(title:"Show Actual Photo Size", style: .default, handler:{ action in
                    let h = NumberFormatter.number().string(from: NSNumber(value: Int(item.photo.size.height))) ?? ""
                    let w = NumberFormatter.number().string(from: NSNumber(value: Int(item.photo.size.width))) ?? ""
                    let shape = item.photo.isSquare ?"☐" :item.photo.isPortrait ?"⌷" :"▭"
                    
                    sharedFunc.ALERT().show(
                        title:"photo.showDetails.Title".localized(),
                        style:.error,
                        msg:"\nShape: \(shape) \t Size: \(h)h x \(w)w\n"
                    )
                }))
                
                present(actSheet, animated:true)
            default: ()
        }
    }
    
    @objc func tap_ChangePhoto(_ sender:UITapGestureRecognizer){
        UserDefaults.standard.set(photoSource.PHOTOS.rawValue, forKey: prefKeys.photoSource.current)
        UserDefaults.standard.synchronize()
        self.showPhotoBrowser(source:photoSource.PHOTOS)
    }
    
    @objc func tap_Preview(_ sender:UITapGestureRecognizer){
        //TODO: ⚙️(Fix) TAP PREVIEW DISABLED
        
//        sharedFunc.ALERT().showUnderConstructionMsg()
        
//
//        if isPad.isTrue {
//            return
//        }
//
//        if isPhotoSelected().isFalse {
//            sharedFunc.ALERT().show(
//                title:"FramePreview_Title".localized(),
//                style:.error,
//                msg:"FramePreview_Msg".localized()
//            )
//            return
//        }
//
//        item.color = vw_Carousel.currentItemIndex
//        item.SKU = Products().returnNewSKUforItem()
//        item.frame = Frames.products().returnProductImg(SKU: item.SKU!)
//
//        let frameImage = item.frame ?? UIImage.init()
//        let frame_color:String = Frames.products().returnProductColor(SKU: item.SKU!).name
//        let frame_size:String = Frames.products().returnProductPhotoSize(SKU: item.SKU!).name
//        let photo_img = item.photo
//        let noPhoto_img = (item.photo.isSquare ?noPhotoSelected[0] :noPhotoSelected[CMS_Frames_Square.count])
//
//        if isPad {
//            let vc = gBundle.instantiateViewController(withIdentifier: "VC_FramePreview_iPad") as! VC_FramePreview_iPad
//                vc.frameImg = frameImage
//                vc.frame_Size = frame_size
//                vc.frame_Color = frame_color
//                vc.photoImg = photo_img ?? noPhoto_img
//            self.present(vc, animated: true)
//        }else{
//            let vc = gBundle.instantiateViewController(withIdentifier: "VC_FramePreview") as! VC_FramePreview
//                vc.frameImg = frameImage
//                vc.frame_Size = frame_size
//                vc.frame_Color = frame_color
//                vc.photoImg = photo_img ?? noPhoto_img
//                vc.modalTransitionStyle = .crossDissolve
//
//            self.present(vc, animated: false)
//
//            UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveLinear], animations: {
//                self.vw_Preview.alpha = kAlpha.opaque
//                self.vw_Topbar.alpha = kAlpha.transparent
//                self.vw_Info.alpha = kAlpha.transparent
//                self.vw_Details.alpha = kAlpha.transparent
//            }, completion: { (finished: Bool) -> Void in
//            })
//        }
    }
    
    @objc func swipe_Up(_ sender:UISwipeGestureRecognizer){
        let maxSize:Int = isPhotoSelected()
            ?item.photo.isSquare
                ?CMS_Frames_Square.count
                :CMS_Frames_Rect.count
            :CMS_frame_sizes.count
        let newSize:Int = item.size + 1

        item.size = (newSize >= maxSize) ?0 :newSize
        
        rebuildSKU(colorIndx: vw_Carousel.currentItemIndex)
        simPrint().info("++++++++++ Swipe Up, Item.Size: \( item.size! )  (new SKU: \(item.SKU!))",function:#function,line:#line)
        updateScreenItems()
    }
    
    @objc func swipe_Down(_ sender:UISwipeGestureRecognizer){
        let maxSize:Int = isPhotoSelected()
            ?item.photo.isSquare
                ?CMS_Frames_Square.count
                :CMS_Frames_Rect.count
            :CMS_frame_sizes.count
        let newSize:Int = item.size - 1

        item.size = (newSize < 0) ?(maxSize - 1) :newSize

        rebuildSKU(colorIndx: vw_Carousel.currentItemIndex)
        simPrint().info("---------- Swipe Down, Item.Size: \( item.size! )  (new SKU: \(item.SKU!))",function:#function,line:#line)
        updateScreenItems()
    }
    
    
// MARK: - *** NOTIFICATIONS ***
    @objc func notify_PreviewCompleted(_ sender: Notification) {
        UIView.animate(withDuration: 0.10, delay: 0.0, options: [.curveLinear], animations: {
            self.vw_Preview.alpha = kAlpha.transparent
            self.vw_Topbar.alpha = kAlpha.opaque
            self.vw_Info.alpha = kAlpha.opaque
            self.vw_Details.alpha = kAlpha.opaque
        }, completion: { (finished: Bool) -> Void in
        })
    }

    @objc func notify_productListingCompleted(_ sender: Notification) {
        btn_AddToCart.isEnabled = (CMS_products.count > 0)
    }
    
    @objc func notification_ShowOrderPlaced(_ sender: Notification) {
        /* Reset Carousel to default values */
        selectedColor = 0
        vw_Carousel.currentItemIndex = 0
        updateScreenItems()

        /* Show order .pdf if user had selected it */
        if let UserInfo = sender.userInfo?["OrderInfo"] as? NSDictionary {
            let title = UserInfo["title"] as? String ?? ""
            let msg = UserInfo["msg"] as? String ?? ""
            let filepath_Order = UserInfo["url"] as? String ?? ""
            let filename:String = filepath_Order.lastPathComponent
            var showErrorMsg = false

            if sharedFunc.FILES().exists(filePathAndName: filepath_Order).isFalse {
                showErrorMsg = true
            }else{
                guard
                    let fileURL = URL(fileURLWithPath: filepath_Order) as URL?
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

            waitHUD().hideNow()
            
            if showErrorMsg {
                sharedFunc.ALERT().show(title: title,style:.error,msg: msg)
            }
        }
    }
    
    @objc func notification_CartCount(_ sender: Notification) {
        updateCartCount()
    }
    
    @objc func notification_refreshScreen(_ sender: Notification) {
        updateScreenItems()
    }
    
    @objc func notification_PhotoSelected(_ sender: Notification) {
        if PhotoManager.shared[selectedPhotoFilename] == nil {
            updateScreenItems()

            return
        }
        
        selectedPhoto = SelectedPhoto.init(filename: tempItem.photoInfo.name, photoURL: tempItem.photoInfo.url)
        
        /* If Selected Photo is of different format, then set to min. size */
        let oldFormat:UIImage.imgOrientationStruct = item.photo.orientation
        
        var newFormat:UIImage.imgOrientationStruct = .square
        if (PhotoManager.shared[selectedPhotoFilename]?.isSquare.isFalse)! {
            if (PhotoManager.shared[selectedPhotoFilename]?.isPortrait.isTrue)! {
                newFormat = .portrait
            }else{
                newFormat = .landscape
            }
        }
        
        if newFormat != oldFormat {
            item.size = 0
        }
        
        appFunc.keychain.SELECTED_PHOTO().save()

        loadSelectedPhoto()
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
        for lbl in [lbl_Title1,lbl_Title2,lbl_Title3] {
            lbl?.textColor = gAppColor
        }
        
        lbl_Title2.textColor = gAppColor.withAlphaComponent(0.50)

        vw_Preview.isHidden = false
        let fontName:String = (APPFONTS().buttonTitles?.fontName)!
        let fontSize:CGFloat = (APPFONTS().buttonTitles?.pointSize)!

        for btn in [btn_AddToCart,btn_Details] {
            sharedFunc.DRAW().roundCorner(view: btn!, radius: 10)
            sharedFunc.DRAW().addShadow(view: btn!, offsetSize: CGSize(width:3,height:3), radius: 3, opacity: 0.66)
            btn?.backgroundColor = gAppColor
            btn?.titleLabel?.font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
        
        /* Load Defaults */
        debugShowCarouselColors = false
        lbl_CartCount.text = "0"
        
        /* setup Carousel */
        vw_Carousel.type = iCarouselType.linear
        vw_Carousel.decelerationRate = 0.0
        vw_Carousel.isPagingEnabled = true
        
        /* Localizations */
        btn_AddToCart.setTitle("Cart_AddTo".localized(), for: .normal)
        btn_Details.setTitle("Cart_FrameInfo".localized(), for: .normal)
        
        // Adjust Font Size for Spanish
        for btn in [btn_AddToCart,btn_Details] {
            btn?.titleLabel?.minimumScaleFactor = 0.5
            btn?.titleLabel?.numberOfLines = 1
            btn?.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        /* Add Long-Press Debug Gesture */
        if isAdhoc {
            let longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(tap_showDebugMenu(_:)))
                longPressGesture1.minimumPressDuration = 2.0 // Seconds
                longPressGesture1.allowableMovement = 15 // Points
                longPressGesture1.delegate = self
            vw_Topbar.addGestureRecognizer(longPressGesture1)
            vw_Topbar.isUserInteractionEnabled = true
        }
        
        /* Notifications */
        let NC = NotificationCenter.default
            NC.addObserver(self,selector:#selector(notification_ShowOrderPlaced(_:)), name:Notification.Name("notification_ShowOrderPlaced"),object: nil)
            NC.addObserver(self,selector: #selector(notification_CartCount(_:)),name: NSNotification.Name("notification_CartCount"),object: nil);
            NC.addObserver(self,selector: #selector(notify_productListingCompleted(_:)),name: NSNotification.Name("notify_productListingCompleted"),object: nil);
            NC.addObserver(self,selector: #selector(notification_PhotoSelected(_:)),name: NSNotification.Name("notification_PhotoSelected"),object: nil);
            NC.addObserver(self,selector: #selector(notification_refreshScreen(_:)),name: NSNotification.Name("notification_refreshScreen"),object: nil);
            NC.addObserver(self,selector: #selector(notify_PreviewCompleted(_:)),name: NSNotification.Name("notify_PreviewCompleted"),object: nil);
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Appearance */
        vw_Preview.alpha = kAlpha.transparent
        vw_Topbar.alpha = kAlpha.opaque
        vw_Info.alpha = kAlpha.opaque
        vw_Details.alpha = kAlpha.opaque

        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)
        btn_Menu.setImage(isPad ? #imageLiteral(resourceName: "Menu_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Menu").recolor(gAppColor), for: .normal)
        btn_Cart.setImage(isPad ? #imageLiteral(resourceName: "Cart_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Cart").recolor(gAppColor), for: .normal)
        img_Info.image = #imageLiteral(resourceName: "info_Circle").recolor(gAppColor)
        
        /* Load defaults */
        setItemsAsBlank()
        loadSelectedPhoto()

        /* Refresh Cart */
        updateCartCount()

        btn_AddToCart.isEnabled = (CMS_products.count > 0)
        
        let prefs = UserDefaults.standard
        // Restore carousel indexes
        item.size = prefs.integer(forKey: prefKeys.selected.size)
        item.color = prefs.integer(forKey: prefKeys.selected.color)
        item.style = prefs.integer(forKey: prefKeys.selected.style)
        vw_Carousel.currentItemIndex = item.color
        
        // Show Info Overlay?
        let infoOverlayHasAlreadyShown = prefs.bool(forKey: prefKeys.infoOverlay.hasShown)
        if infoOverlayHasAlreadyShown.isFalse {
            prefs.set(true, forKey: prefKeys.infoOverlay.hasShown)
            prefs.synchronize()
            
            let vc = gBundle.instantiateViewController(withIdentifier: "VC_infoOverlay") as! VC_infoOverlay
                vc.showTipsOnly = false
            
            self.present(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* Appearance */
        if !DeviceType.hasNotch {
            self.view.addSubview(addGradientToTopView(view: self.view))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Save carousel indexes
        let prefs = UserDefaults.standard
            prefs.set(item.size, forKey: prefKeys.selected.size)
            prefs.set(vw_Carousel.currentItemIndex, forKey: prefKeys.selected.color)
            prefs.set(item.style, forKey: prefKeys.selected.style)
        prefs.synchronize()
        
        waitHUD().hideNow()
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var vw_Carousel:iCarousel!
    @IBOutlet var lbl_CartCount:UILabel!
    @IBOutlet var lbl_Title1:UILabel!
    @IBOutlet var lbl_Title2:UILabel!
    @IBOutlet var lbl_Title3:UILabel!
    @IBOutlet var vw_Topbar:UIView!
    @IBOutlet var divider:UILabel!
    @IBOutlet var btn_Menu:UIButton!
    @IBOutlet var btn_Cart:UIButton!
    @IBOutlet var btn_AddToCart:UIButton!
    @IBOutlet var btn_Details:UIButton!
    @IBOutlet var btn_Info:UIButton!
    @IBOutlet var img_Info:UIImageView!
    @IBOutlet var vw_Preview:UIView!
    @IBOutlet var vw_Info:UIView!
    @IBOutlet var vw_Details:UIStackView!
    @IBOutlet var vw_Titles: UIStackView!
    
    
// MARK: - *** DECLARATIONS (Variables) ***
    var photosManager:PhotosManager { return .shared }
    var selectedColor:Int = 0
    var imgPicker = UIImagePickerController()
    var debugShowCarouselColors:Bool = false

// MARK: - *** DECLARATIONS (Presenting VC Configurable Parameters) ***
    
// MARK: - *** DECLARATIONS (Reusable Cells) ***
    
}


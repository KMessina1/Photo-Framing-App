/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_ShoppingCart.swift
  Author: Kevin Messina
 Created: Apr 21, 2016
Modified: Apr 16, 2018
 
©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: 2016-09-19 Converted to Swift.
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_ShoppingCart:
    UIViewController,
    UIPopoverPresentationControllerDelegate,
    UIActionSheetDelegate,
    UITableViewDelegate,UITableViewDataSource
{
    
// MARK: - *** FUNCTIONS ***
    func enableButtons() {
        for button in [btn_Checkout,btn_EmptyCart] {
            button?.isEnabled = (localCart.items.count > 0)
        }
    }
    
    func reloadTableData() {
        /* Format data */
        let Amount:String! = String(format:"$%0.2f",localCart.subtotal.doubleValue)
        let item = (localCart.items.count == 1) ?"item".localizedCAS() :"items".localizedCAS()
        let cart = (localCart.subtotal.doubleValue < 1000) ?"in cart".localizedCAS() + " " :""

        /* Display data */
        lblCartTotal.text = "\(localCart.itemCount!) \(item) \(cart)(\(Amount!))"

        /* If there's < 1 product in the cart, disable the checkout button */
        enableButtons()
        
        /* Refresh table data */
        tableView.reloadData()
    }


// MARK: - *** ACTIONS ***
    @IBAction func emptyCart(_ sender: UIBarButtonItem) {
        enableButtons()
        
        if localCart.items.count > 0 {
            let actSheet = sharedFunc.actSheet().setup(vc: self,barButton: sender,title: "CART_Emptied_Title".localizedCAS(),message: nil)

            actSheet.addAction(UIAlertAction(title:"EmptyCart".localizedCAS(), style: .destructive, handler:{ action in
                localCart.empty()
                selectedPayment = CREDITCARD.creditCARD.init()
                selectedCoupon = Coupons.couponStruct.init()
                order = Orders.orderStruct.init()
                
                NotificationCenter.default.post(name: Notification.Name("notification_CartCount"), object: nil)
                self.reloadTableData()
                
                AppDelegate().saveCurrentSessionData()
            }))

            present(actSheet, animated:true)
        }
    }

    @IBAction func checkOut(_ sender: UIBarButtonItem) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }

        /* New AppStore version available? Force Update */
        let testUser = isTestDeviceOrUser()
        let _ = ApplicationInfo().getAppStoreInfo { (appStoreInfo, needsUpdating, appStoreVer, currentVer, error) in
            if needsUpdating && testUser.isFalse {
                ApplicationInfo().forceSirenUpdate(
                    appStoreVersion: appStoreVer,
                    currentVersion: currentVer
                )
            }else{
                Server.CMS_Services().isActive { (isActive,msg_eng,msg_esp,major,build,revision,requiresUpdate) in
                    if requiresUpdate {
                        waitHUD().hideNow()
                        sharedFunc.ALERT().show(
                            title:"Siren_Update_Title".localized(),
                            style:.error,
                            msg:"Siren_Update_Msg".localized()
                        )
                        return
                    }else if (isActive || testUser) {
                        /* Allow test users backdoor bypass to server availability = OFF to be able to test */
                        showTestUserInfo(CMS_Services_Active:isActive)

                        /* Get early start on loading customer addresses if possible */
                        if (customerInfo.ID > 0) {
                            Customers.address().search(showMsg: true, customerID: customerInfo.ID!) { (success, addressRecords, error) in
                                shippingAddresses = success ?addressRecords.sorted(by: { (($0.lastName < $1.lastName) && ($0.firstName < $1.firstName)) }) :[]
                                
                                simPrint().info("Saved Addresses: \( shippingAddresses.count )",function:#function,line:#line)
                                waitHUD().hideNow()
                                NotificationCenter.default.post(name: Notification.Name("shippingAddressesLoaded"), object: nil)
                            }
                        }
                        
                        /* Initialize New Order */
                        order = Orders.orderStruct.init(
                            id: -1,
                            orderNum: "-1",
                            orderDate: Date().toString(format: "yyyy-MM-dd"),
                            statusID: "Unpaid",
                            customerID: customerInfo.ID!,
                            customerNum: "\( customerInfo.ID! )",
                            customer_firstName: customerInfo.firstName!,
                            customer_lastName: customerInfo.lastName!,
                            customer_address1: customerInfo.address.address1,
                            customer_address2: customerInfo.address.address2,
                            customer_city: customerInfo.address.city,
                            customer_stateCode: customerInfo.address.stateCode,
                            customer_zip: customerInfo.address.zip,
                            customer_countryCode: customerInfo.address.countryCode,
                            customer_phone: customerInfo.phone,
                            customer_email: customerInfo.email,
                            cartID: "-1",
                            productCount: localCart.itemCount,
                            photoCount: localCart.items.count,
                            giftMessage: "",
                            subtotal: localCart.subtotal,
                            taxAmt: 0.00,
                            shippingAmt: CMS_defaulShipingRate,
                            discountAmt: 0.00,
                            totalAmt: 0.00,
                            couponID: 0,
                            shipToID: -1,
                            shipToMoltinID: "",
                            shipTo_firstName: "",
                            shipTo_lastName: "",
                            shipTo_address1: "",
                            shipTo_address2: "",
                            shipTo_city: "",
                            shipTo_stateCode: "",
                            shipTo_zip: "",
                            shipTo_countryCode: "",
                            shipTo_phone: "",
                            shipTo_email: "",
                            shippingPriority: "Standard",
                            shippedVia: "US Postal Service",
                            trackingNum: "",
                            shippedAmt: 0.00,
                            shippedDate: "",
                            deliveredDate: "",
                            mailer_compFilesDate: "",
                            mailer_confDate: "",
                            mailer_trackingDate: "",
                            taxJarTransactionID: "",
                            paymentAuthorized: "",
                            paymentCard: "",
                            StripeTransactionID: "",
                            shippoTransactionID: "",
                            orderFolder: appInfo.COMPANY.SERVER.ordersFolder!,
                            orderDocs: "",
                            photos: "",
                            notes: "SF-App v.\( Bundle.main.fullVer )."
                        )
                        
                        /* Show Checkout screen */
                        let vc = gBundle.instantiateViewController(withIdentifier: "VC_Checkout") as! VC_Checkout
                            vc.modalTransitionStyle = .coverVertical
                            vc.modalPresentationStyle = isPad ?.formSheet : .overFullScreen

                        if isPad {
                            vc.preferredContentSize = CGSize(width: 500,height: self.view.frame.height - 100)
                        }
                        
                        self.present(vc,animated:true,completion:nil)
                    }else{
                        let msg = (gAppLanguageCode == "en") ?msg_eng :msg_esp
                        sharedFunc.ALERT().show(title: "Server.DontIntterrupt.Title".localized(),style:.error,msg: msg)
                        return
                    }
                }
            }
        }
    }

    @IBAction func changeQty(_ sender: UIStepper) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }
        
        let row = sender.tag

        guard var item = localCart.items[row] as LocalCartItem?,
              let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? cell_ShoppingCart,
              let newQty = Int(cell.step_Qty.value) as Int?
        else {
            sharedFunc.ALERT().show(
                title:"Cart_AddError_Title".localized(),
                style:.error,
                msg:"Cart_AddError_Msg".localized()
            )
            waitHUD().hideNow()
            return
        }

        if (newQty == 0) { // Delete item from cart.
            let actSheet = sharedFunc.actSheet().setup(
                vc: self,
                barButton:UIBarButtonItem.init(),
                title:"CART_DeleteItem_Title".localizedCAS(),
                message: "CART_DeleteItem_Msg".localizedCAS()
            )
            
            actSheet.addAction(UIAlertAction(title:"Delete".localizedCAS(), style: .destructive, handler:{ action in
                localCart.removeItem(cartItem: item)

                NotificationCenter.default.post(name: Notification.Name("notification_CartCount"), object: nil)
                self.reloadTableData()
                AppDelegate().saveCurrentSessionData()
            }))

            present(actSheet, animated:true)
            return
        }

        let qtyToAdjust = (newQty - item.quantity)
        var stockLevel:Int = 0

        /* Is in Stock? & get Updated price */
        Frames.products().inStock(showMsg: true, SKU:item.SKU) { (success, matches, error) in
            waitHUD().hideNow()

            if matches.count > 0 {
                stockLevel = matches.first?.qty.intValue ?? 0
            }
            
            /* Validate sufficient Stock Level in inventory */
            if stockLevel < qtyToAdjust {
                sharedFunc.ALERT().show(
                    title:"Order_OutOfStock_Title".localized(),
                    style:.error,
                    msg:"Order_OutOfStock_Msg".localized()
                )
                return
            }
            
            item.quantity = newQty
            item.amount = (Decimal(newQty) * item.price)
            
            if localCart.updateItem(cartItem: item, qtyToChange: qtyToAdjust).isFalse {
                sharedFunc.ALERT().show(
                    title:"Cart_AddError_Title".localized(),
                    style:.error,
                    msg:"Cart_AddError_Msg".localized()
                )
                return
            }

            NotificationCenter.default.post(name: Notification.Name("notification_CartCount"), object: nil)
            self.reloadTableData()
            AppDelegate().saveCurrentSessionData()
        }
    }


// MARK: - *** TABLEVIEW ***
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return localCart.items.count }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView.init() }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView.init() }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return isPad ?240 :175 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        /* Get Info */
        guard let item = localCart.items[row] as LocalCartItem?,
              let cell = tableView.dequeueReusableCell(withIdentifier: cellID.shoppingCart) as? cell_ShoppingCart
        else { return UITableViewCell() }

        cell.contentView.isOpaque = true
        cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        /* Appearance */
        cell.step_Qty.tintColor = gAppColor

        /* Get Item Info */
        let color = Frames.products().returnProductColor(SKU: item.SKU).name
        let itemPhoto = UIImage(contentsOfFile: sharedFunc.FILES().dirDocuments(fileName: item.photo_ThumbnailFileName))
        let fullSizePhoto = UIImage(contentsOfFile: sharedFunc.FILES().dirDocuments(fileName: item.photo_FullSizeFileName))

        let productPrice = Frames.products().returnProductPrice(SKU: item.SKU)
        let price:Double = productPrice.price
        let priceString:String = productPrice.formatted
        let photoSize:String = Frames.products().returnProductPhotoSize(SKU: item.SKU).name
        let framedSize:String = Frames.products().returnProductFramedSize(SKU: item.SKU).name
        let style:String = Frames.products().returnProductStyle(SKU: item.SKU).localized
        let quantity:Int = item.quantity
        let amount:String = NumberFormatter.currency().string(from: NSNumber(value: price * Double(quantity))) ?? "n/a"
        let frames:String = (quantity == 1) ? "frame".localized() :"frames".localized()
        let shape = (fullSizePhoto?.isSquare)!
            ? "Square"
            : "Rectangular"

        /* Display Titles */
        cell.lbl_Title_Color.text = "Color".localizedCAS().capitalized
        cell.lbl_Title_Size.text = "Size".localizedCAS().capitalized
        cell.lbl_Title_Format.text = "Style".localized().capitalized
        cell.lbl_Title_Price.text = "Price".localizedCAS().capitalized
        cell.lbl_Title_Quantity.text = "Quantity".localizedCAS().capitalized

        /* Display Info */
        cell.lbl_Color.text = color.capitalized
        cell.lbl_Size.text = "\(photoSize) (\("framed".localized().capitalized) \(framedSize))"
        cell.lbl_Format.text = "\( style.capitalized ) \( shape.localized().capitalized )"
        cell.step_Qty.value = Double(quantity)
        cell.lbl_Price.text = "\(priceString) \("Cart(SF)_PerFrame".localized().capitalized)"
        cell.lbl_Quantity.text = "\(quantity) \(frames) (\(amount))"
        cell.img_Thumbnail.image = itemPhoto

        /* Add Getures */
        cell.img_Thumbnail.addGestureRecognizer(
            sharedFunc.GESTURES().returnTap(
                selector: "tap_Preview:",
                delegate: self,
                numTaps: 1
            )
        )

        /* Set TAG Indx values to row */
        cell.img_Thumbnail.tag = row
        cell.step_Qty.tag = row

        return cell
    }


// MARK: - *** GESTURES ***
    @objc func tap_Preview(_ sender:UITapGestureRecognizer){
        
        //TODO: ⚙️(Fix) TAP PREVIEW DISABLED
        
//        sharedFunc.ALERT().showUnderConstructionMsg()
        
//        if isPad.isTrue {
//            return
//        }
//
//        guard let Indx = sender.view?.tag,
//              let item = localCart.items[Indx] as LocalCartItem?
//        else { return }
//
//        let frame_color = frameColors.arr[item.frame_color]
//        let photo_img = UIImage(contentsOfFile: sharedFunc.FILES().dirDocuments(fileName: item.photo_FullSizeFileName)) ?? noPhotoSelected[0]
//        let frameIndexOffset = photo_img.isSquare ?0 : Frame_Size_Rect.count
//        var frameImage:UIImage = UIImage.init()
//
//        if Frames.products().isSlimLine(SKU: item.SKU) {
//            frameImage = photo_img.isSquare
//                ?FrameImgs_Square_SL[item.frame_color]
//                :FrameImgs_Rect_ST[item.frame_color]
//        }else{
//            frameImage = photo_img.isSquare
//                ?FrameImgs_Square_SL[item.frame_color]
//                :FrameImgs_Rect_ST[item.frame_color]
//        }
////        let frameImage:UIImage = photo_img.isSquare ?FrameImgs_Square[item.frame_color] :FrameImgs_Rect[item.frame_color]
//        let frame_size = Frame_Size_Names[item.frame_size + frameIndexOffset]
//
//        if isPad {
//            let vc = gBundle.instantiateViewController(withIdentifier: "VC_FramePreview_iPad") as! VC_FramePreview_iPad
//                vc.frameImg = frameImage
//                vc.frame_Size = frame_size
//                vc.frame_Color = frame_color
//                vc.photoImg = photo_img
//            present(vc, animated: true)
//        }else{
//            let vc = gBundle.instantiateViewController(withIdentifier: "VC_FramePreview") as! VC_FramePreview
//                vc.frameImg = frameImage
//                vc.frame_Size = frame_size
//                vc.frame_Color = frame_color
//                vc.photoImg = photo_img
//                vc.modalTransitionStyle = .crossDissolve
//            present(vc, animated: true)
//        }
    }
    
// MARK: - *** NOTIFICATIONS ***
    
    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return true }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        sharedFunc.DRAW().addShadow(view: self.view, offsetSize: CGSize(width:0,height:5), radius: 5.0, opacity: 1.0)
        sharedFunc.DRAW().addShadow(view: topView, radius: 2, opacity: 0.4)
        sharedFunc.DRAW().addShadow(view: toolbar, radius: 2, opacity: 0.4)
        sharedFunc.DRAW().addShadow(view: navbar, offsetSize: CGSize(width:0,height:-1), radius: 1.0, opacity: 0.4)
        
        /* Table init */
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        if localCart == nil {
            localCart = LocalCart.init()
        }
    }

    override func viewDidLayoutSubviews() {
        /* Localization */
        btn_Checkout.possibleTitles = Set(arrayLiteral: "Checkout", "Revisa")
        btn_Checkout.title = "Checkout".localizedCAS()
        btn_Checkout.tintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)

        btn_EmptyCart.possibleTitles = Set(arrayLiteral: "Empty cart", "Carro vacio")
        btn_EmptyCart.title = "EmptyCart".localizedCAS()
        btn_EmptyCart.tintColor = #colorLiteral(red: 0.835, green: 0.157, blue: 0.22, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SlideMenuOptions.contentViewScale = 1
        
        /* Appearance */
        lblCartTotal.textColor = gAppColor

        let libUrl:URL = cachedImgs.APP.url
            .appendingPathComponent("shoppingCart.jpg")
        
        backgroundImage.image = UIImage(contentsOfFile: libUrl.path)?.alpha(value: 0.86) ?? UIImage()
        
        enableButtons()
        
        
        /* Notifications */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Appearance */
        tableView.separatorColor = gAppColor.withAlphaComponent(0.3)
        tableView.backgroundColor = gAppColor.withAlphaComponent(0.1)
        btn_Checkout.tintColor = gAppColor
        btn_EmptyCart.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

        /* Load Defaults */
        reloadTableData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Notifications */
    }
    
    
// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var logo:UIImageView!
    @IBOutlet weak var backgroundImage:UIImageView!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var navbar:UINavigationBar!
    @IBOutlet weak var btn_EmptyCart:UIBarButtonItem!
    @IBOutlet weak var btn_Checkout:UIBarButtonItem!
    @IBOutlet weak var lblCartTotal:UILabel!
    @IBOutlet weak var toolbar: UIToolbar!

    // MARK: - *** DECLARATIONS (Variables) ***
    var Home = gBundle.instantiateViewController(withIdentifier: "VC_Home") as! VC_Home
    
// MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let shoppingCart = "cell_ShoppingCart"
    }
}


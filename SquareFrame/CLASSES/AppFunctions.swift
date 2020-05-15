/*--------------------------------------------------------------------------------------------------------------------------
   File: AppFunctions.swift
 Author: Kevin Messina
Created: January 23, 2016

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift on September 19, 2016
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import Locksmith
import RappleProgressHUD

// MARK: - *** GLOBAL CONSTANTS ***
var titleFontname:String = APPFONTS().PDFTitles?.fontName ?? "HelveticaNeue"
var titleFontsize:CGFloat = 10
var infoFontname:String = APPFONTS().PDFInfo?.fontName ?? "HelveticaNeue-Thin"
var infoFontsize:CGFloat = 9
var headerTop:CGFloat = 110
var logoSizeH:CGFloat = 40.0
var logoSizeW:CGFloat = 200.0
var inset:CGFloat = 5
var currentOrder:Order = Order.init()


//MARK: - ****************************************
//MARK: GENERAL FUNCTIONS
//MARK: **************************************** -
func copyFilesToFolderFromBundleIfNeeded(toUrl:URL,filterBy:String,showMsg:Bool = false) {
    let FM = FileManager.default
    let toPath = toUrl.path
    let toFolderName = toUrl.path.lastPathComponent
    var folderExists = sharedFunc.FILES().exists(filePathAndName: toPath)
    var bundlefiles = try? FM.contentsOfDirectory(atPath: sharedFunc.FILES().dirMainBundle())
        bundlefiles = bundlefiles?.filter({ !$0.contains(".DS_Store") })
    var bundleFilenames = filterBy.isEmpty ?bundlefiles! :bundlefiles?.filter({ $0.contains(filterBy) }) ?? []
        bundleFilenames.sort(by: { $0.compare($1, options: [.caseInsensitive,.numeric]) == .orderedAscending })
    
    if showMsg { waitHUD().showNow(msg: "Copying Files") }

    /* Create folder if not exist */
    if folderExists.isFalse {
        do {
            try FM.createDirectory(
                at: toUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
            simPrint().success("Folder \( toFolderName ) created!",function:#function,line:#line)
            folderExists = true
        } catch {
            simPrint().error("Folder \( toFolderName ) NOT created.\n\( error )",function:#function,line:#line)
        }
    }

    /* Copy files to folder from bundle if not exist */
    if folderExists {
        for filename in bundleFilenames {
            let toFileURL = toUrl.appendingPathComponent(filename)
            let fromFilePath = sharedFunc.FILES().dirMainBundle(fileName: filename)
            
            do {
                if FM.fileExists(atPath: toFileURL.path).isFalse {
                    try FM.copyItem(atPath: fromFilePath, toPath: toFileURL.path )
                    simPrint().success("\( filename ) copied.",function:#function,line:#line)
                }else{
                    simPrint().info("\( filename ) exists, skip copy.",function:#function,line:#line)
                    /* Check date of file, if bundle is newer, replace it */
                    let localFileDate = try FM.attributesOfItem(atPath: toFileURL.path)[FileAttributeKey.modificationDate] as! Date
                    let bundleFileDate = try FM.attributesOfItem(atPath: fromFilePath)[FileAttributeKey.modificationDate] as! Date

                    if bundleFileDate.greaterThan(date: localFileDate) {
                        try FM.removeItem(atPath: toFileURL.path)
                        try FM.copyItem(atPath: fromFilePath, toPath: toFileURL.path )
                        simPrint().info("--> \( filename ) out of date, copied.",function:#function,line:#line)
                    }else{
                        simPrint().info("--> \( filename ) date OK, skip copy.",function:#function,line:#line)
                    }
                }
            } catch {
                simPrint().error("Error copying \( filename ). \( error )",function:#function,line:#line)
            }
        }
    }
    
    if showMsg { waitHUD().hideNow() }
}

func isFrameSizeSquare(frameSize:String) -> Bool {
    let squareFrames = CMS_frame_sizes.filter { $0.frameShape == "Square" }
    
    return squareFrames.contains(where: {$0.photoSize == frameSize})
}

func removeOrderNumberFromFilename(_ filename:String) -> (
    filename:String,filenameWithoutOrderNum:String,orderNum:String,orderFolerName:String,frameSize:String,
    frameColor:String,frameFormat:String,photoNum:String,SKU:String,suffix:String) {
        
        var suffix:String = ""
        var orderNum:String = ""
        var frameSize:String = ""
        var frameColor:String = ""
        var frameFormat:String = ""
        var photoNum:String = ""
        var SKU:String = ""
        var shortFilename:String = filename
        var locPeriod = 0
        var locOrderNum = 0
        var locFormat = 0
        var locPhotoNum = 0
        
        /* SUFFIX */
        // Find the last occurance of a . in the filename
        var regex = try! NSRegularExpression(pattern: ".", options: [.caseInsensitive,.ignoreMetacharacters])
        var matches = regex.matches(in: filename, options: [], range: NSRange(location: 0, length: filename.count))
        if matches.count > 0 {
            locPeriod = (matches.last?.range.location)!
            suffix = (filename as NSString).substring(from: locPeriod)
        }
        
        /* FIELDS IN PREFIX */
        // Find the occurances of _ in the filename. Photos have 3, .PDF's have one in the naming scheme
        // PDF File = {filename}_{order number}.pdf
        // PNG File = {filename}_{order number}_{frame SKU}_{photo number}.pdf
        // Note: Frame SKU = Last 2 chars = color, remainder is size
        regex = try! NSRegularExpression(pattern: "_", options: [.caseInsensitive,.ignoreMetacharacters])
        matches = regex.matches(in: filename, options: [], range: NSRange(location: 0, length: filename.count))
        if matches.count == 1 { // PDF
            locOrderNum = (matches[0].range.location + 1)
            orderNum = (filename as NSString).substring(with: NSRange(location: locOrderNum, length: (locPeriod - locOrderNum)))
            
            // Remove orderNum from filename
            shortFilename = shortFilename.replacingOccurrences(of: "_\(orderNum)", with: "")
        }else if matches.count == 3 { // Photo
            locOrderNum = (matches[0].range.location + 1)
            locFormat = (matches[1].range.location + 1)
            locPhotoNum = (matches[2].range.location + 1)
            
            orderNum = (filename as NSString).substring(with: NSRange(location: locOrderNum, length: (locFormat - locOrderNum) - 1))
            SKU = (filename as NSString).substring(with: NSRange(location: locFormat, length: (locPhotoNum - locFormat - 1)))
            photoNum = (filename as NSString).substring(with: NSRange(location: locPhotoNum, length: (locPeriod - locPhotoNum)))
            
            // Separate SKU into Size & Color
            frameSize = SKU[0..<(SKU.length - 2)]
            frameColor = SKU[(SKU.length - 2)..<SKU.length]
            frameFormat = isFrameSizeSquare(frameSize: frameSize) ?"Square" :"Rectangular"
            
            // Remove orderNum from filename
            shortFilename = shortFilename.replacingOccurrences(of: "_\(orderNum)", with: "")
        }
        
        return (filename,shortFilename,orderNum,"Order_\(orderNum)",frameSize,frameColor,frameFormat,photoNum,SKU,suffix)
}

func dataDictFrom(dict:[String:Any],_ key1:String,_ key2:String? = "",_ key3:String? = "",_ key4:String? = "",_ key5:String? = "") -> [String:Any] {
    let dict1_data = dict[key1] as? [String:Any]
    
    if key2!.isNotEmpty {
        let dict2_data = dict1_data?[key2!] as? [String:Any]
        
        if key3!.isNotEmpty {
            let dict3_data = dict2_data?[key3!] as? [String:Any]
            
            if key4!.isNotEmpty {
                let dict4_data = dict3_data?[key4!] as? [String:Any]
                
                if key5!.isNotEmpty {
                    let dict5_data = dict4_data?[key5!] as? [String:Any]
                    
                    return dict5_data ?? [String:Any]()
                }else{
                    return dict4_data ?? [String:Any]()
                }
            }else{
                return dict3_data ?? [String:Any]()
            }
        }else{
            return dict2_data ?? [String:Any]()
        }
    }else{
        return dict1_data ?? [String:Any]()
    }
}

func setupInputTableVC() -> VC_InputTable {
    let vc = gBundle.instantiateViewController(withIdentifier: "VC_InputTable") as! VC_InputTable
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.preferredContentSize = CGSize(width: isPad.isTrue ? 500:320,height: isPad.isTrue ?900 :480)
        vc.borderColor_Active = APPTHEME.borderColor_Active
        vc.borderColor_Inactive = APPTHEME.borderColor_Inactive
        vc.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        vc.placeholderColor = APPTHEME.placeholderColor
        vc.alert_ShowAsAppleStandard = alert_ShowAsAppleStandard
        vc.alert_TintColor = APPTHEME.alert_TintColor
    
    return vc
}

func savePhoto(_ filePathAndName:String,img:UIImage,asPNG:Bool,quality:CGFloat) {
    if sharedFunc.FILES().exists(filePathAndName: filePathAndName) {
        let _ = sharedFunc.FILES().delete(filePathAndName: filePathAndName)
    }
    
    do {
        if asPNG.isTrue {
            let _ = try img.pngData()?
                .write(to: URL(fileURLWithPath: filePathAndName), options: .atomic)
        }else{
            let _ = try img.jpegData(compressionQuality: quality)?
                .write(to: URL(fileURLWithPath: filePathAndName),options: .atomic)
        }
    } catch {
        sharedFunc.ALERT().show(
            title:"IMAGE_SaveError_Title".localized(),
            style:.error,
            msg:"IMAGE_SaveError_Msg".localized()
        )
    }
}

func deletePhoto(_ filePathAndName:String ) {
    if !sharedFunc.FILES().delete(filePathAndName: filePathAndName) {
        sharedFunc.ALERT().show(
            title:"FILE_Error_Title".localized(),
            style:.error,
            msg:"FILE_Error_Msg".localized()
        )
    }
}

func isFrameSquare() -> Bool {
    if tempItem.frame != nil {
        return tempItem.frame.isSquare
    }
    
    return true
}

func isFrameAndPhotoSameFormat() -> Bool {
    if ((tempItem.photo != nil) && (tempItem.frame != nil)) {
        if tempItem.photo.isSquare.isTrue {
            return (tempItem.photo.isSquare.isTrue == isFrameSquare().isTrue)
        }else{
            return (tempItem.photo.isSquare.isFalse == isFrameSquare().isFalse)
        }
    }
    
    return false
}

func isFrameAndPhotoInAspectAndSelected() -> Bool {
    return (isPhotoSelected().isTrue && isFrameAndPhotoSameFormat().isTrue)
}

func isTaxableState(stateCode:String) -> Bool {
    let stateCode = stateCode.uppercased()
    
    let matches = CMS_TaxableStates.filter { $0.code == stateCode }
    
    return (matches.count > 0)
}

func isCustomerInfoFilledOut() -> Bool {
    return (
        order.customer_firstName.isNotEmpty &&
        order.customer_lastName.isNotEmpty &&
        order.customer_address1.isNotEmpty &&
        order.customer_city.isNotEmpty &&
        order.customer_stateCode.isNotEmpty &&
        order.customer_zip.isNotEmpty &&
        order.customer_countryCode.isNotEmpty &&
        order.customer_email.isNotEmpty &&
        order.customer_phone.isNotEmpty
    )
}

func isShipToFilledOut() -> Bool {
    return (
        order.shipTo_firstName.isNotEmpty &&
        order.shipTo_lastName.isNotEmpty &&
        order.shipTo_address1.isNotEmpty &&
        order.shipTo_city.isNotEmpty &&
        order.shipTo_stateCode.isNotEmpty &&
        order.shipTo_zip.isNotEmpty &&
        order.shipTo_countryCode.isNotEmpty
    )
}

func shipToAddressRequiresSalesTax(stateCode:String) -> Bool {
    return (isShipToFilledOut() && isTaxableState(stateCode:stateCode))
}


/// NOTE: Clear has a black color channel use UIColor(white: 1, alpha: 0) in place of .clear
func addGradientToTopView(view:UIView) -> UIView {
    var ht:CGFloat = 22
    
    if DeviceType.hasNotch {
        ht *= 2
    }
    
    let newView = UIView.init(frame: CGRect(x:0,y:0,width:view.frame.width,height: ht))
    sharedFunc.DRAW().gradient(view: newView, startColor: gAppColor, endColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.01))
    return newView
}

// MARK: - *** SERVER DATABASE FUNCTIONS ***
func getOrderDefaultValues() {
    CAS_SalesTax.TaxableState().list(showMsg: true) { (success, taxstates, error) in
        let Georgia = Jurisdictions.US.States.Contiguous.Georgia
        
        CMS_TaxableStates = success ?taxstates :[
            CAS_SalesTax.TaxableState.init(name: Georgia.name, code: Georgia.code)
        ] // Only used if JSON not returned from CMS

        return
    }

    Fulfillment().list(showMsg: true) { (success, infoRecord, error) in
        CMS_defaulShipingRate = success ?(infoRecord.first?.defaultShippingPrice)! :5.00
        
        return
    }
}


//MARK: - ****************************************
//MARK: ORDER PDF FUNCTIONS
//MARK: **************************************** -
func createOrderPDFs(completion: @escaping (Bool,[String],orderError) -> Void) {
    renamePhotos( completion: { (success,attachments_Company,filesToUpload,error) in
        if isSimDevice {
            var i:Int = 0
            attachments_Company.forEach({ (item) in
                i += 1
                print ("Photo #\( i ) attachment filename: \( item )")
            })
        }
        
        if success {
            buildPDFs( completion: { (success,error) in
                if success {
                    // Add the Order pdf's to file parameters.
                    let fileURLs = buildOrderFileURLS()
                    var filesToUploadList = filesToUpload
                        filesToUploadList.updateValue(fileURLs.serverFolderName, forKey: fileURLs.customerOrder)
                        filesToUploadList.updateValue(fileURLs.serverFolderName, forKey: fileURLs.companyOrder)
                    var attachments_CompanyList = attachments_Company
                        attachments_CompanyList.append(fileURLs.companyOrder)

                    createServerOrderNumberFolder( completion: { (success,error) in
                        if success {
                            uploadOrderFilesToServer(filesToUpload:filesToUploadList, completion: { (success,error) in
                                if success { completion(true,attachments_CompanyList,.none) }
                                else{ completion(false,[],error) }
                            })}
                        else{ completion(false,[],error) }
                    })}
                else{ completion(false,[],error) }
            })}
        else{ completion(false,[],error) }
    })
}

func buildPDFs( completion: @escaping (Bool,orderError) -> Void) {
    let fileURLs = buildOrderFileURLS()

    /* Delete all .PDF's */
    if sharedFunc.FILES().deleteFiles(Predicate: "SELF ENDSWITH[cd] 'pdf'", path: sharedFunc.FILES().dirDocuments()).isFalse {
        completion(false,.pdfs_NotDeleted(filename: "Deleting old .pdf's"))
    }

    /* Initialize PDF settings */
    PDF().setPaperSize(paperSize: PDF.PaperSizeFormat.Letter)

    /* Create Customer copy of 'ORDER DETAILS' */
    waitHUD().updateNow(msg: "PDF.OrderDetails.Msg".localized())
    PDF().createAtFilePath(fileNameAndPath: fileURLs.customerOrderPath)
    pdf_OrderConfirmation().create(finishRpt: true, packingSlip: false, giftMessage: false, forceEnglish: false, completion: { (success) in
        if success {
            /* Create Company copy of 'ORDER DETAILS' */
            PDF().createAtFilePath(fileNameAndPath: fileURLs.companyOrderPath)
            pdf_OrderConfirmation().create(finishRpt: false, packingSlip: false, giftMessage: false, forceEnglish: true, completion: { (success) in
                if success {
                    /* Create Company copy of 'PACKING SLIP' & 'GIFT MESSAGE' */
                    pdf_OrderConfirmation().create(finishRpt: true, packingSlip: true, giftMessage: order.giftMessage.isNotEmpty, forceEnglish: false, completion: { (success) in
                        if success {
                            // Give time for PDF write(s) to complete to disk
                            var fileExists:Bool = false
                            var loopNum = 0
                            repeat {
                                fileExists = sharedFunc.FILES().exists(filePathAndName: fileURLs.customerOrderPath)
                                simPrint().info("📄 PDF write Delay Looping, pass #: \( loopNum )",function:#function,line:#line)
                                sharedFunc.THREAD().doNothingFor(seconds: 1)
                                loopNum += 1
                            } while ((fileExists == false) && (loopNum <= 10))
                            
                            /* Copy Customer copy to LastOrder.pdf for customer preview if desired */
                            if fileExists {
                                if sharedFunc.FILES().copy(
                                    fromPathAndName: fileURLs.customerOrderPath,
                                    toPathAndName: fileURLs.lastOrderPath,
                                    overwrite: true).isFalse {
                                    
                                    completion(false,.pdfs_NotCopied(filename: "Copying Order Details PDF (Customer) to Last Order PDF"))
                                }
                            }

                            loopNum = 0
                            repeat {
                                fileExists = sharedFunc.FILES().exists(filePathAndName: fileURLs.companyOrderPath)
                                simPrint().info("📄 PDF write Delay Looping, pass #: \( loopNum )",function:#function,line:#line)
                                sharedFunc.THREAD().doNothingFor(seconds: 1)
                                loopNum += 1
                            } while ((fileExists == false) && (loopNum < 10))

                            if sharedFunc.FILES().exists(filePathAndName: fileURLs.customerOrderPath),
                                sharedFunc.FILES().exists(filePathAndName: fileURLs.companyOrderPath),
                                sharedFunc.FILES().exists(filePathAndName: fileURLs.lastOrderPath) {

                                currentOrder = Order.init(
                                    number: order.orderNum,
                                    filename: fileURLs.customerOrder,
                                    filepath: fileURLs.customerOrderPath
                                )

                                completion(true,.none)
                            }else{
                                completion(false,.pdfs_NotFound(filename:"Order PDF's Not found."))
                            }
                        }else{
                            completion(false,.pdfs_NotCreated(filename:"Creating Packing Slip & Gift Message PDF"))
                        }
                    })
                }else{
                    completion(false,.pdfs_NotCreated(filename:"Creating Order Details PDF (Company)"))
                }
            })
        }else{
            completion(false,.pdfs_NotCreated(filename:"Creating Order Details PDF (Customer)"))
        }
    })
}

func buildOrderFileURLS() -> (
    customerOrder:String,
    customerOrderPath:String,
    companyOrder:String,
    companyOrderPath:String,
    lastOrder:String,
    lastOrderPath:String,
    serverFolderName:String)
{
    
    let filename_Company = appInfo.COMPANY.ORDERS.order! + "\(order.orderNum).pdf"
    let filepath_Company = sharedFunc.FILES().dirDocuments(fileName: filename_Company)
    let filename_Customer = appInfo.COMPANY.ORDERS.orderConfirmation! + "\(order.orderNum).pdf"
    let filepath_Customer = sharedFunc.FILES().dirDocuments(fileName: filename_Customer)
    let filename_LastOrder = appInfo.COMPANY.ORDERS.lastOrder!
    let filepath_LastOrder = sharedFunc.FILES().dirDocuments(fileName: filename_LastOrder)
    let serverFolderName = "Order_\(order.orderNum)"
    
    return (
        customerOrder:filename_Company,
        customerOrderPath:filepath_Company,
        companyOrder:filename_Customer,
        companyOrderPath:filepath_Customer,
        lastOrder:filename_LastOrder,
        lastOrderPath:filepath_LastOrder,
        serverFolderName:serverFolderName
    )
}

func createServerOrderNumberFolder(completion: @escaping (Bool,orderError) -> Void) {
    let scriptName:String = serverScriptNames.ORDERS.createServerFolder
    let scriptPath:String = "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)"
    guard let scriptURL = URL(string: scriptPath)
    else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }

    URLCache.shared.removeAllCachedResponses()
    waitHUD().updateNow(msg: "Server.CreatingOrderFolder.Msg".localized())

    /* Setup parameters to pass to script */
    let params:Parameters = [
        "orderNum":order.orderNum
    ]

    Server().dumpParams(params,scriptName: scriptName)

    Alamofire.request(scriptURL, parameters: params)
    .validate(statusCode: 200..<300)
    .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
    .responseJSON(completionHandler: { response in
        Server().dumpURLfromResponse(response)

        switch response.result {
        case .success:
            let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
            
            completion(results.success,.none)
        case .failure(let error):
            simPrint().error("|--> \(scriptName) Failed: Creating Order Folder.",function:#function,line:#line)

            if error._code == NSURLErrorTimedOut {
                sharedFunc.ALERT().show(title: "COMMUNICATIONS ERROR", style: .error, msg: "\n\(scriptName.uppercased())\n\ntimed-out with no response.")
                simPrint().error("\n\n !! \(scriptName.uppercased())\n\ntimed-out with no response.",function:#function,line:#line)
            }else{
                if let err = response.result.error as? AFError {
                    Server().displayAlamoFireError(err,scriptTitle: scriptName)
                }
            }
            
            completion(false,.folder_NotCreated(filename: "Server.CreatingOrderFolder.Failed.Msg".localized()))
        }
    })
}

func uploadOrderFilesToServer(filesToUpload:[String:String], completion: @escaping (Bool,orderError) -> Void) {
    URLCache.shared.removeAllCachedResponses()
    waitHUD().updateNow(msg: "Server.UploadingFiles.Msg".localized())

    AFuploadError = false
    
    DispatchQueue(label: "upload").async {
        var completed:Int = Int(100.0 / Double(filesToUpload.count))
        var counter:Int = 0
        
        for (filename,fileURL) in filesToUpload {
            let semaphore = DispatchSemaphore(value: 0)
            
            var fileDisplayName:String = ""
            if filename.contains("OrderConfirmation_") { fileDisplayName = "Order Confirmation" }
            else if filename.contains("Order_") { fileDisplayName = "Order Details" }
            else if filename.contains("Photo_") {
                counter += 1
                fileDisplayName = "Photo #\(counter)"
            }
         
            waitHUD().updateNow(msg: "\( "WAIT_UPLOADING".localizedCAS() )\n\(fileDisplayName)")

            appFunc.SERVER().uploadFile(name: filename, serverUploadFolderURL: fileURL, completion: { (success,error) in
                if success {
//                    sharedFunc.THREAD().doNothingFor(seconds: 1)
                    semaphore.signal()
                }else{
                    simPrint().error("\n*** Upload of \( fileDisplayName ) File FAILED. ***",function:#function,line:#line)
                    completion(false,error)
                }
            })
            
            semaphore.wait()
            completed += completed
        }
        
        simPrint().info("\n*** Upload of \( filesToUpload.count ) Files completed. ***",function:#function,line:#line)
        completion(true,.none)
    }
}

func renamePhotos( completion: @escaping (Bool,[String],[String:String],orderError) -> Void) {
    waitHUD().updateNow(msg: "Renaming Photos...".localized())

    var attachments_Company:[String] = []
    var filesToUpload:[String:String] = [:]
    let fileURLs = buildOrderFileURLS()

    for i in 0..<localCart.items.count {
        /* Rename & Add photo attachments */
        let itemInfo = localCart.items[i]

        /* Build new photo name Photo_{order#}_{frameSizeCode}{frameColorCode}_{photo#}.png */
        let photoNum:Int = Int(i + 1)
        let filename = "Photo_\( order.orderNum )_\( photoNum )_SKU_\( itemInfo.SKU! ).png"
        let filepath = sharedFunc.FILES().dirDocuments(fileName: filename)

        /* Get old photo name */
        let photoname = itemInfo.photo_FullSizeFileName ?? ""
        let photopath = sharedFunc.FILES().dirDocuments(fileName: photoname)

        /* Rename old photo name to new formatted one */
        var retries = 0
        repeat {
            if sharedFunc.FILES().copy(fromPathAndName: photopath, toPathAndName: filepath, overwrite:true).isTrue {
                simPrint().info("|--> PHOTOS rename '\(photoname)' to '\(filename)'",function:#function,line:#line)
                retries = 0
                break
            }

            retries += 1
        } while retries <= 10

        if retries > 0 {
            completion(false,[],[:],.photo_NotRenamed(filename:"'\(photoname)' renaming to '\(filename)'"))
            break
        }

        /* Append file names */
        attachments_Company.append(filename)
        filesToUpload.updateValue(fileURLs.serverFolderName, forKey: filename)
    }

    completion(true,attachments_Company,filesToUpload,.none)
}

func sendServerEmailToCustomer(attachment:String, completion: @escaping (Bool,orderError) -> Void) {
    /* Setup script */
    let scriptName:String = serverScriptNames.EMAIL.CUSTOMER.confirmation
    let scriptPath:String = "\(appInfo.COMPANY.SERVER.phpMailScriptsFolder!)/\(scriptName)".replaceCharsForHTML
    guard let scriptURL = URL(string: scriptPath) else { return completion(false,.script_CreationFailed(scriptname:scriptName)) }

    URLCache.shared.removeAllCachedResponses()
    
    waitHUD().updateNow(msg: "Server.SendingEmail_Customer.Msg".localized())

    let params:Parameters = [
        "orderNum":order.orderNum,
        "customerEmail":order.customer_email,
        "customerNum":order.customerNum,
        "appVersion":Bundle.main.fullVer,
        "attachmentFileName":attachment,
        "calledFromApp":appInfo.EDITION.appEdition!
    ]

    Server().dumpParams(params,scriptName: scriptName)
    
    Alamofire.request(scriptURL, parameters: params)
    .validate(statusCode: 200..<300)
    .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
    .responseString(completionHandler: { response in
        switch response.result {
        case .success:
            completion(true,.none)
        case .failure(let error):
            if error._code == NSURLErrorTimedOut {
                sharedFunc.ALERT().show(title: "COMMUNICATIONS ERROR", style: .error, msg: "\n\(scriptName.uppercased())\n\ntimed-out with no response.")
                simPrint().error("\n\n !! \(scriptName.uppercased())\n\ntimed-out with no response.",function:#function,line:#line)
            }else{
                if let err = response.result.error as? AFError {
                    Server().displayAlamoFireError(err,scriptTitle: scriptName)
                }
            }
            
            completion(false,.serverEmail_NotSent(recipient: "Customer Order Confirmation"))
        }
    })
}

func sendServerEmailToCompany(attachments:[String], sendToCustomer:Bool, completion: @escaping (Bool,orderError) -> Void) {
    /* Setup script */
    let scriptName:String = serverScriptNames.EMAIL.COMPANY.sendOrderFiles
    let scriptPath:String = "\(appInfo.COMPANY.SERVER.phpMailScriptsFolder!)/\(scriptName)".replaceCharsForHTML
    guard let scriptURL = URL(string: scriptPath) else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
    
    URLCache.shared.removeAllCachedResponses()

    let attachmentFiles:[String] = attachments.sorted()
    var filenamesAsString:String = ""
    attachmentFiles.forEach { (filename) in
        filenamesAsString += filenamesAsString.isEmpty ?"\( filename )" :",\( filename )"
    }
    
    waitHUD().updateNow(msg: "Server.SendingEmail_Company.Msg".localized())

    let orderdate = order.orderDate.convertToDate(format: kDateFormat.yyyyMMdd).toString(format: kDateFormat.MMM_d_yyyy)
    var phone = sharedFunc.STRINGS().stripPhoneNumFormatting(text: order.customer_phone)
        phone = sharedFunc.STRINGS().formatPhoneNumTextWithAreaCode(text: phone)
    
    let params:Parameters = [
        "OrderNum":order.orderNum,
        "OrderDate":orderdate,
        "CustomerEmail":order.customer_email,
        "CustomerPhone": phone,
        "CustomerName":"\(order.customer_firstName) \(order.customer_lastName)",
        "CustomerNum":order.customerID,
        "attachmentFilenames":filenamesAsString,
        "appVersion":Bundle.main.fullVer,
        "calledFromApp":appInfo.EDITION.appEdition!
    ]
    
    Server().dumpParams(params,scriptName: scriptName)
    
    Alamofire.request(scriptURL, parameters: params)
    .validate(statusCode: 200..<300)
    .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
    .responseJSON(completionHandler: { response in
        Server().dumpURLfromResponse(response)

        switch response.result {
        case .success:
            let _ = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
            
            if sendToCustomer.isTrue {
                let fileURLs = buildOrderFileURLS()
                sendServerEmailToCustomer(attachment:fileURLs.customerOrder, completion: { (success,error) in
                    waitHUD().hideNow()
                    
                    completion(success,success ?.none :.serverEmail_NotSent(recipient: "Customer Order Confirmation from Company Order"))
                })
            }else{
                waitHUD().hideNow()
                completion(true,.none)
            }
        case .failure(let error):
            waitHUD().hideNow()
            if error._code == NSURLErrorTimedOut {
                sharedFunc.ALERT().show(title: "COMMUNICATIONS ERROR", style: .error, msg: "\n\(scriptName.uppercased())\n\ntimed-out with no response.")
                simPrint().error("\n\n !! \(scriptName.uppercased())\n\ntimed-out with no response.",function:#function,line:#line)
            }else{
                if let err = response.result.error as? AFError {
                    Server().displayAlamoFireError(err,scriptTitle: scriptName)
                }
            }
            
            completion(false,.serverEmail_NotSent(recipient: "Company Order Confirmation"))
        }
    })
}


//MARK: - ****************************************
//MARK: CLASS appFunc FUNCTIONS
//MARK: **************************************** -
class appFunc:Alamofire.SessionDelegate {
    func resetAllPrefs() {
        let domain = Bundle.main.bundleIdentifier!
        let prefs = UserDefaults.standard
            prefs.removePersistentDomain(forName: domain)
            prefs.synchronize()
        let keysCount = Array(prefs.dictionaryRepresentation().keys).count
        
        simPrint().info("UserDefaults: Reset; current Keys count: \( keysCount )")
        
        AppDelegate().initSessionData()
        AppDelegate().loadCurrentSessionData()
        AppDelegate().setup_InitializeApp()
    }
    
    func resetKeychainAndSession() {
        /* Reset Default Info */
        customerInfo = CustomerInfo.init()
        appFunc().resetAllPrefs()

        /* Reset Keychain */
        appFunc.keychain().resetEntireKeychain()
        
        /* Reset Persistance of data */
        AppDelegate().saveCurrentSessionData()
        AppDelegate().loadCurrentSessionData()
    }
    
    func resetOrderAndcleanupOrderFiles() {
        /* Delete Order PDFs */
        sharedFunc.FILES().deleteFiles(
            Predicate: "SELF BEGINSWITH[cd] 'Order' && SELF ENDSWITH[cd] 'pdf'",
            path: sharedFunc.FILES().dirDocuments()
        )
        
        /* Reset Order */
        localCart = LocalCart.init()
        localCart.empty()
        order = Orders.orderStruct.init()
        selectedCoupon = Coupons.couponStruct.init()
        selectedPayment = CREDITCARD.creditCARD.init()
        CMS_cart = Cart.init()
        CMS_item = Orders.itemStruct.init()
        shippingAddresses = []
        
        /* Reset Selected Photo */
        selectedPhoto = SelectedPhoto.init()
        item = Item.init()
        tempItem = TempItem.init()
        sharedFunc.FILES().delete(filePathAndName: selectedPhotoFilepath)

        /* Reset Persistance of data */
        AppDelegate().saveCurrentSessionData()
    }

    struct keychain {
// MARK: ├─➤ Keychain: MyInfo
        struct MYINFO {
            func get() {
                if ((customerInfo != nil) && (customerInfo.email.isNotEmpty)) {
                    MYINFO().save()
                    return
                }
                
                if let dict = Locksmith.loadDataForUserAccount(userAccount: "squareframe") {
                    customerInfo = CustomerInfo.init(
                        ID: (dict["customerInfo.ID"] as? String ?? "").intValue, 
                        firstName: dict["customerInfo.firstName"] as? String ?? "",
                        lastName: dict["customerInfo.lastName"] as? String ?? "",
                        email: dict["customerInfo.email"] as? String ?? "",
                        phone: dict["customerInfo.phone"] as? String ?? "",
                        mailingList: (dict["customerInfo.mailingList"] as? String ?? "").boolValue,
                        address: Customers.address.init(
                            id: (dict["customerInfo.addressID"] as? String ?? "").intValue,
                            customerID: (dict["customerInfo.customerID"] as? String ?? "").intValue,
                            firstName: dict["customerInfo.addressFirstName"] as? String ?? "",
                            lastName: dict["customerInfo.addressLastName"] as? String ?? "",
                            address1: dict["customerInfo.address1"] as? String ?? "",
                            address2: dict["customerInfo.address2"] as? String ?? "",
                            city: dict["customerInfo.city"] as? String ?? "",
                            stateCode: dict["customerInfo.stateCode"] as? String ?? "",
                            zip: dict["customerInfo.zip"] as? String ?? "",
                            countryCode: dict["customerInfo.countryCode"] as? String ?? "",
                            phone: dict["customerInfo.addressPhone"] as? String ?? "",
                            email: dict["customerInfo.addressEmail"] as? String ?? ""
                        )
                    )
                }else{
                    if customerInfo.email.isNotEmpty {
                        MYINFO().save()
                    }
                }
            }
            
            func save() {
                if customerInfo == nil {
                    customerInfo = CustomerInfo.init()
                }
                
                let data:[String:Any] = [
                    "customerInfo.ID": customerInfo.ID!,
                    "customerInfo.firstName": customerInfo.firstName!,
                    "customerInfo.lastName": customerInfo.lastName!,
                    "customerInfo.email": customerInfo.email!,
                    "customerInfo.phone": customerInfo.phone!,
                    "customerInfo.mailingList": customerInfo.mailingList!,
                    "customerInfo.addressID": customerInfo.address.id,
                    "customerInfo.customerID": customerInfo.address.customerID,
                    "customerInfo.addressFirstName": customerInfo.address.firstName,
                    "customerInfo.addressLastName": customerInfo.address.lastName,
                    "customerInfo.address1": customerInfo.address.address1,
                    "customerInfo.address2": customerInfo.address.address2,
                    "customerInfo.city": customerInfo.address.city,
                    "customerInfo.stateCode": customerInfo.address.stateCode,
                    "customerInfo.zip": customerInfo.address.zip,
                    "customerInfo.countryCode": customerInfo.address.countryCode,
                    "customerInfo.addressPhone": customerInfo.address.phone,
                    "customerInfo.addressEmail": customerInfo.address.email
                ]
                
                Server().dumpParams(data)
                
                try? Locksmith.updateData(data: data,forUserAccount: "squareframe")
                
                AppDelegate().saveCurrentSessionData()
            }
        }

// MARK: ├─➤ Keychain: Selected Photo
        struct SELECTED_PHOTO {
            func get() {
                if let dict = Locksmith.loadDataForUserAccount(userAccount: "squareframe") {
                    selectedPhoto = SelectedPhoto.init(
                        filename: dict["selectedPhoto.filename"] as? String ?? "",
                        instagramURL: dict["selectedPhoto.instagramURL"] as? String ?? ""
                    )
                }else{
                    if selectedPhoto.filename.isNotEmpty {
                        SELECTED_PHOTO().save()
                    }
                }
            }
            
            func save() {
                let data:[String:Any] = [
                    "selectedPhoto.filename": selectedPhoto.filename!,
                    "selectedPhoto.instagramURL": selectedPhoto.instagramURL!
                ]

                Server().dumpParams(data,scriptName: "SELECTED_PHOTO")
                
                try? Locksmith.updateData(data: data, forUserAccount: "squareframe")
 
                if let encoded = try? JSONEncoder().encode(selectedPhoto) {
                    UserDefaults.standard.set(encoded, forKey: prefKeys.Archive.photosInfo)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        
// MARK: ├─➤ Keychain: Delete Account
        func delete() {
            try? Locksmith.deleteDataForUserAccount(userAccount: "squareframe" )
        }
        
        func resetEntireKeychain() {
            try? Locksmith.deleteDataForUserAccount(userAccount: "SQInsta")
            try? Locksmith.deleteDataForUserAccount(userAccount: "squareframe" )
            simPrint().info(
                """
                \n******** Keychain Reset *********\n
                \( Array(UserDefaults.standard.dictionaryRepresentation().keys ))\n
                ******** Keychain Reset *********\n\n
                """
                ,function:#function,line:#line
            )

            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            simPrint().info(
                """
                \n******** User Defaults Reset *********\n
                \( Array(UserDefaults.standard.dictionaryRepresentation().keys ))\n
                ******** User Defaults Reset *********\n\n
                """
                ,function:#function,line:#line
            )
        }
    }
    
    func isExpired(month ExpM:Int,year ExpY:Int) -> Bool {
        let year = Date().yearNum
        let month = Date().monthNum

        return ((year >= ExpY) && (month >= ExpM)) ?true :false
    }
    
    struct sqlDB {
// MARK: ├─➤ FUNCTIONS
        func buildQueryArgumentsFromDictionary(fieldsAndVals:[String:AnyObject]) -> (fields:String,placeholders:String,values:[AnyObject]) {
            var valArguments:String = ""
            var fields:String = ""
            var values:[AnyObject] = []
            var count = 0
            for item in fieldsAndVals {
                fields += "\(item.0)"
                values.append(item.1)
                valArguments += "?"
                
                count += 1
                if count < fieldsAndVals.count {
                    valArguments += ","
                    fields += ","
                }
            }
            
            return (fields,valArguments,values)
        }
    }
    
    func downloadFile(downloadURL:String,renameTo:String,callback:String? = "",finishedMsg:String? = "") {
        let destination:DownloadRequest.DownloadFileDestination = { _, _ in
            return (appFunc().returnDocsDestinationFor(filename:renameTo), [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(downloadURL, to: destination)
            .downloadProgress { progress in
                let progressNum = NSNumber(value: progress.fractionCompleted)
                let formattedProgress = NumberFormatter.percent(numPlaces: 0).string(from: progressNum)
                waitHUD().updateProgressNow(progress: CGFloat(truncating: progressNum), msg:formattedProgress!)
                
                if isSim {print("Download Progress: \(String(describing: formattedProgress))") }
            }
            
            .responseString(completionHandler: { response in
                let status:RappleCompletion = response.result.isSuccess ?.success :.failed
                
                if (finishedMsg?.isNotEmpty)! {
                    waitHUD().hideWithMsgNow(status: status, msg: finishedMsg!, showFor: 1.25)
                }else{
                    waitHUD().hideNow()
                }
                
                if callback!.isNotEmpty {
                    NotificationCenter.default.post(name: Notification.Name(callback!),
                                                    object: nil,
                                                    userInfo: ["success":response.result.isSuccess,
                                                               "filename":renameTo
                        ]
                    )
                }
                
                switch response.result {
                case .success:
                    if isSim { print(response.result) }
                case .failure(let error):
                    if isSim { print(error) }
                }
            }
        )
    }
    
   func returnDocsDestinationFor(filename:String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        return fileURL
    }
    
    
// MARK: - *** JSON Console Output Functions ***
    struct JSON {
        func outputResponseToConsole(response:DataResponse<String>){
            if isSim {
                print("Validation Successful")
                print("\nRequest: \(response.request!)")  // original URL request
                print("\nResponse: \(response.response!)") // HTTP URL response
                print("\nData: \(response.data!)")     // server data
                print("\nResult: \(response.result)")   // result of response serialization
            }
        }
        
        func outputResponseToConsole(response:DataResponse<Any>){
            if isSim {
                print("Validation Successful")
                print("\nRequest: \(response.request!)")  // original URL request
                print("\nResponse: \(response.response!)") // HTTP URL response
                print("\nData: \(response.data!)")     // server data
                print("\nResult: \(response.result)")   // result of response serialization
            }
        }
    }

// MARK: - *** Server Functions ***
    struct SERVER {
        /// Upload a single file to the Server. Use uploadFiles method to upload multiple files of any type.
        /// - parameter name: (String) Name of file.
        /// - parameter serverUploadFolderURL: (String) filepathURL of imgName.
        /// - parameter completion: (Completion Block) - leave as default value
        func uploadFile(name:String, serverUploadFolderURL:String, completion: @escaping (Bool,orderError) -> Void) {
            /* Name and path of PHP Script to execute */
            let scriptName:String = serverScriptNames.FILES.upload
            let serverScript:String = "\(appInfo.COMPANY.SERVER.SCRIPTS.files!)/\(scriptName)".replaceCharsForHTML
            
            /* Parameters being passed to PHP Script */
            var components = URLComponents(string: serverScript)
                components?.queryItems = [URLQueryItem(name: "folderName", value: serverUploadFolderURL)]
    
            /* Create URLs */
            guard let serverScriptAndComponentsURL = try! components!.asURL() as URL?,
                  let fileURL = URL(fileURLWithPath: sharedFunc.FILES().dirDocuments(fileName: name)) as URL?
            else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }

            /* Setup Configuration for upload which will include a timeout */
            let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 90
            AFmanager = Alamofire.SessionManager(configuration: config)
            
            if isSim {
                print("\n\nScript: \( serverScriptAndComponentsURL.absoluteString )")
                print("\n*** Upload File Started ***")
            }
            
            /* Setup Alamofire to upload file in multiple parts asynchronously */
            AFmanager.upload(
            multipartFormData: { multipartFormData in multipartFormData.append(fileURL, withName: "uploadFile") },
            to: serverScriptAndComponentsURL.absoluteString, encodingCompletion: { encodingResult in
                if isSim { print("Encoding completed, starting Upload of \( name )...") }

                switch encodingResult {
                case .success(let upload, _, _): upload
                    .uploadProgress { progress in
                        let progressNum = NSNumber(value: progress.fractionCompleted)
                        let formattedProgress = NumberFormatter.percent(numPlaces: 0).string(from: progressNum)
                        sharedFunc.THREAD().doNow {
                            waitHUD().updateProgress(progress: CGFloat(truncating: progressNum), msg:formattedProgress!)
                        }

                        if isSim { print("\(name) Upload progress: \(formattedProgress!)") }
                    }
                    .responseData { JSON in
                        if isSim { print("Upload of \( name ) completed.") }
                        completion(true,.none)
                    }
                case .failure(let encodingError):
                    if isSim { print("Upload ERROR of \(name): \(encodingError)\n\n") }
                
                    AFuploadError = true
                    completion(false,.file_NotUploaded(filename:"Upload of \(name) to server Failed."))
                }
            })
        }
        
        /// Upload 1 or more files to the Server.
        /// NOTE: Dictionary must have string path to desired folder. Use .. to back up one directory. Ex: "..\Orders"
        /// - parameter imgName: (String) Name of file.
        /// - parameter serverUploadFolderURL: (String) filepathURL of imgName.
        func uploadFiles(dictFilenameAndURL:[String:String],callback:String) {
            AFuploadError = false
            
            DispatchQueue(label: "upload").async {
                var completed:Int = Int(100.0 / Double(dictFilenameAndURL.count))
                var counter:Int = 0
                
                for (filename,fileURL) in dictFilenameAndURL {
                    let semaphore = DispatchSemaphore(value: 0)

                    var fileDisplayName:String = ""
                    if filename.contains("OrderConfirmation_") { fileDisplayName = "Order Confirmation" }
                    else if filename.contains("Order_") { fileDisplayName = "Order Details" }
                    else if filename.contains("Photo_") {
                        counter += 1
                        fileDisplayName = "Photo #\(counter)"
                    }
                    let msg = "\( "WAIT_UPLOADING".localizedCAS() )\n\( fileDisplayName )"
                    waitHUD().showNow(msg: msg)
                
                    self.uploadFile(name: filename, serverUploadFolderURL: fileURL, completion: { (success,error) in
                        semaphore.signal()
                    })
                
                    semaphore.wait()
                    completed += completed
                }
                
                if isSim { print("\n*** Upload Multiple Files completed. ***") }
                
                sharedFunc.THREAD().doNow {
                    waitHUD().hideWithMsg(status: RappleCompletion.success, msg: "Done".localizedCAS(), showFor: 1.25)
                    
                    sharedFunc.THREAD().doAfterDelay(delay: 1.3, perform: {
                        NotificationCenter.default.post(name: Notification.Name(callback),
                                                        object: nil,
                                                        userInfo: ["success":!AFuploadError])
                    })
                }
            }
        }
    }
}



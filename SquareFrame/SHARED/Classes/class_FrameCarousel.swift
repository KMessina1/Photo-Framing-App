/*--------------------------------------------------------------------------------------------------------------------------
     File: class_FrameCarousel.swift
   Author: Kevin Messina
  Created: Apr 12, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class FrameCarousel:NSObject,Codable {
    let Version:String = "1.01"
    let name:String = "Carousel"
    
    var shape:String
    var color:String
    var style:String
    var img:String

    init (
        shape:String? = "",
        color:String? = "",
        style:String? = "",
        img:String? = ""
    ){
        self.shape = shape!
        self.color = color!
        self.style = style!
        self.img = img!
    }
    
    init(dictionary:[String:Any]) {
        self.shape = dictionary["shape"] as? String ?? ""
        self.color = dictionary["color"] as? String ?? ""
        self.style = dictionary["style"] as? String ?? ""
        self.img = dictionary["img"] as? String ?? ""
    }
    
    // MARK: - *** FUNCTIONS ***
    func getPhotos() {
        AppImages().downloadNewerFilesIfNeeded(
            toFolderUrl:cachedImgs.FRAMES.carousel.url,
            fromFolderUrl:serverImgs.FRAMES.carousel.url,
            fromFolderPath:serverImgs.FRAMES.carousel.folderPath
        )
    }
    
    func getInfo(showMsg:Bool? = false,completion: @escaping (Bool,FrameGallery,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,FrameGallery.init(),.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.FRAME_GALLERY.getInfo
        let className = FrameGallery().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.frameGallery!)/\(scriptName)")
        else { return completion(false,FrameGallery.init(),.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") }

        Alamofire.request(scriptURL, parameters:["calledFromApp":appInfo.EDITION.appEdition!])
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            simPrint().success(" URL: \( response.request!.url! )",function:#function,line:#line)
            
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response,scriptTitle: scriptName)
                if results.success {
                    completion(true,FrameGallery.init(dictionary: results.records.first!),.none)
                }else{
                    completion(false,FrameGallery.init(),.items_NotFound)
                }
            case .failure(let error):
                completion(false,FrameGallery.init(),.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

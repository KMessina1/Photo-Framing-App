/*--------------------------------------------------------------------------------------------------------------------------
     File: class_FrameGallery.swift
   Author: Kevin Messina
  Created: Apr 6, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** CLASS ***
class FrameGallery:NSObject,Codable {
    let Version:String = "1.01"
    let name:String = "Frame Gallery"
    
    var id:Int // Primary Index.
    var title_en:String // English Title
    var title_es:String // Spanish Title
    var photos:String // Comma separated list of photo names.
    
    init (
        id:Int? = -1,
        title_en:String? = "",
        title_es:String? = "",
        photos:String? = ""
    ){
        self.id = id!
        self.title_en = title_en!
        self.title_es = title_es!
        self.photos = photos!
    }
    
    init(dictionary:[String:Any]) {
        self.id = dictionary["id"] as? Int ?? -1
        self.title_en = dictionary["title_en"] as? String ?? ""
        self.title_es = dictionary["title_es"] as? String ?? ""
        self.photos = dictionary["photos"] as? String ?? ""
    }
    
    // MARK: - *** FUNCTIONS ***
    /// Get all photos for app from Bundle and if needed, download from CMS Server.
    /// - requires:
    ///     - Alamofire
    ///     - "CAS_Get_Directories.php"
    /// ---
    /// - returns: - array of filenames, filenames & dates, success from PhP script.
    func getPhotos() {
        // Get the text from CMS server
        FrameGallery().getInfo(showMsg: false) { (success, info, error) in
            if success {
                CMS_frameGalleryTitle = (gAppLanguageCode == "en") ?info.title_en :info.title_es
            }else{
                CMS_frameGalleryTitle = "Frames(SF)_Descrip".localized()
            }
        }
        
        // Get files if needed from CMS server
        AppImages().downloadNewerFilesIfNeeded(
            toFolderUrl:cachedImgs.FRAMES.gallery.url,
            fromFolderUrl:serverImgs.FRAMES.gallery.url,
            fromFolderPath:serverImgs.FRAMES.gallery.folderPath
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
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        Server().dumpParams(params)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            if showMsg! { waitHUD().hideNow() }
            Server().dumpURLfromResponse(response)

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

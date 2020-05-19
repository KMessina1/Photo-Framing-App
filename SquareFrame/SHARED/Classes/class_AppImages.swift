/*--------------------------------------------------------------------------------------------------------------------------
     File: class_appImages.swift
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
class AppImages:NSObject,Codable {
    let Version:String = "1.01"
    let name:String = "App Images"
    
    var id:Int // Primary Index.
    var homeScreen:String
    var leftMenu:String
    var shoppingCart:String
    
    init (
        id:Int? = -1,
        homeScreen:String? = "",
        leftMenu:String? = "",
        shoppingCart:String? = ""
    ){
        self.id = id!
        self.homeScreen = homeScreen!
        self.leftMenu = leftMenu!
        self.shoppingCart = shoppingCart!
    }
    
    init(dictionary:[String:Any]) {
        self.id = dictionary["id"] as? Int ?? -1
        self.homeScreen = dictionary["homeScreen"] as? String ?? ""
        self.leftMenu = dictionary["leftMenu"] as? String ?? ""
        self.shoppingCart = dictionary["shoppingCart"] as? String ?? ""
    }
    
    // MARK: - *** FUNCTIONS ***
    func downloadNewerFilesIfNeeded(toFolderUrl:URL,fromFolderUrl:URL,fromFolderPath:String) {
        let FM = FileManager.default
        
        /* Get server files array */
        Server().get_FilesInDirectory(showMsg: false, folderPath: fromFolderPath) { (success, files, error) in
            if success {
                files.forEach({ (fileInfo) in
                    let localFileURL = toFolderUrl.appendingPathComponent(fileInfo.fileName)
                    let serverFileURL = fromFolderUrl.appendingPathComponent(fileInfo.fileName)
                    
                    /* If file does not exist locally, download from server */
                    if FM.fileExists(atPath: toFolderUrl.path).isFalse {
                        Server().downloadFile(fromURL: serverFileURL, toURL: localFileURL)
                        simPrint().success("File doesn't exist, downloading: \( fileInfo.fileName )",function:#function,line:#line)
                        // Downloading assumes latest date locally, so no need to test for newer version of file.
                    }else{
                        let filename = fileInfo.fileName
                        let serverFileDate = fileInfo.modifiedDate
                            .changDateFormat(
                                fromFormat: kDateFormat.UNIX,
                                toFormat: kDateFormat.yyyyMMdd_hmmss_a
                            )
                            .convertToDate(format: kDateFormat.yyyyMMdd_hmmss_a)
                            .convertToLocalTime(fromTimeZone: TimeZone.current.abbreviation()!)
                        guard let localFileDate = sharedFunc.FILES().modifiedDate(url: localFileURL)?
                            .convertToLocalTime(fromTimeZone: TimeZone.current.abbreviation()!)
                        else { return }
                        
//                        simPrint().info("\(filename) Server: \(serverFileDate!.toString(format: kDateFormat.yyyyMMdd_hmmss_a)), Local: \(localFileDate.toString(format: kDateFormat.yyyyMMdd_hmmss_a))",function:#function,line:#line)
                        
                        /* Compare local and server filedates, download if newer available */
                        if (serverFileDate?.greaterThan(date: localFileDate))! {
                            do {
                                try FM.removeItem(atPath: localFileURL.path)
                                try FM.copyItem(atPath: serverFileURL.path, toPath: localFileURL.path )
                                simPrint().info("--> \( filename ) out of date, downloaded.",function:#function,line:#line)
                            }catch{
                                simPrint().error("Error dlownloading \( filename ). \( error )",function:#function,line:#line)
                            }
                        }else{
                            simPrint().info("--> \( filename ) date OK, skip download.",function:#function,line:#line)
                        }
                    }
                })
            }else{
                simPrint().error("Unknown error getting server file list from folder \( fromFolderUrl.lastPathComponent )",function:#function,line:#line)
            }
        }
    }

    func getPhotos() {
        downloadNewerFilesIfNeeded(
            toFolderUrl:cachedImgs.APP.url,
            fromFolderUrl:serverImgs.APP.url,
            fromFolderPath:serverImgs.APP.folderPath
        )
    }
    
    func getInfo(showMsg:Bool? = false,completion: @escaping (Bool,AppImages,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,AppImages.init(),.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.APP_IMAGES.getInfo
        let className = "App Images"
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.appImages!)/\(scriptName)")
        else { return completion(false,AppImages.init(),.script_CreationFailed(scriptname: scriptName)) }
        
        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        
        let params:Alamofire.Parameters = [
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params,scriptName: scriptName)

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
                    completion(true,AppImages.init(dictionary: results.records.first!),.none)
                }else{
                    completion(false,AppImages.init(),.items_NotFound)
                }
            case .failure(let error):
                completion(false,AppImages.init(),.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

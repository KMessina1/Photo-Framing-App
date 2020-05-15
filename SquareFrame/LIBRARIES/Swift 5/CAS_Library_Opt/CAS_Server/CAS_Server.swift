/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Server.swift
  Author: Kevin Messina
 Created: November 16, 2016
 
©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: This file requires certain PHP Scripts to be installed in server location.
--------------------------------------------------------------------------------------------------------------------------*/

import Alamofire
import SwiftyJSON
import CodableAlamofire

// MARK: - *** SERVER CONSTANTS ***


@objc(Server) class Server:NSObject {
    var Version: String { return "1.05" }
    var name: String = "Server"

    struct filesStruct:Codable {
        var fileName:String
        var modifiedDate:String
        
        init (
            fileName:String? = "",
            modifiedDate:String? = ""
        ){
            self.fileName = fileName!
            self.modifiedDate = modifiedDate!
        }

        init(dictionary:[String:Any]) {
            self.fileName = dictionary["fileName"] as? String ?? ""
            self.modifiedDate = dictionary["modifiedDate"] as? String ?? ""
        }
        
        func convertStructToDictionary(structure:Server.filesStruct) -> [String:Any] {
            var dict:[String:Any] = [:]
                dict.updateValue(structure.fileName, forKey: "fileName")
                dict.updateValue(structure.modifiedDate, forKey: "modifiedDate")
            
            return dict
        }
        
        func returnArray(arrayOfDictionaries:[[String:Any]]) -> [Server.filesStruct] {
            var arr:[Server.filesStruct] = []
            arrayOfDictionaries.forEach { (dict) in arr.append(Server.filesStruct.init(dictionary: dict)) }
            
            return arr
        }
        
        func returnArrayOfDictionaries(arrayOfStructs:[Server.filesStruct]) -> [[String:Any]] {
            var arr:[[String:Any]] = []
            arrayOfStructs.forEach { (fileInfo) in arr.append(Server.filesStruct().convertStructToDictionary(structure: fileInfo) ) }

            return arr
        }
    }

// MARK: - *********************************************************
// MARK: STRUCT: CMS_Services
// MARK: *********************************************************
    struct CMS_Services {
        struct CMS_ServicesStruct:Codable {
            var active:Int!
            var unavailableMsg_eng:String!
            var unavailableMsg_esp:String!
            var minMajorVersion:Int!
            var minBuildVersion:Int!
            var minRevisionVersion:Int!

            init (
                active:Int? = 0,
                unavailableMsg_eng:String? = "",
                unavailableMsg_esp:String? = "",
                minMajorVersion:Int? = 0,
                minBuildVersion:Int? = 0,
                minRevisionVersion:Int? = 0
            ){
                self.active = active!
                self.unavailableMsg_eng = unavailableMsg_eng!
                self.unavailableMsg_esp = unavailableMsg_esp!
                self.minMajorVersion = minMajorVersion!
                self.minBuildVersion = minBuildVersion!
                self.minRevisionVersion = minRevisionVersion!
            }
            
            init(dictionary:[String:Any]) {
                self.active = (dictionary["active"] as? String ?? "").intValue
                self.unavailableMsg_eng = dictionary["unavailableMsg_eng"] as? String ?? ""
                self.unavailableMsg_esp = dictionary["unavailableMsg_esp"] as? String ?? ""
                self.minMajorVersion = (dictionary["minMajorVersion"] as? String ?? "").intValue
                self.minBuildVersion = (dictionary["minBuildVersion"] as? String ?? "").intValue
                self.minRevisionVersion = (dictionary["minRevisionVersion"] as? String ?? "").intValue
            }
            
            func convertStructToDictionary(structure:CMS_Services.CMS_ServicesStruct) -> [String:Any] {
                var dict:[String:Any] = [:]
                    dict.updateValue(structure.active!, forKey: "active")
                    dict.updateValue(structure.unavailableMsg_eng!, forKey: "unavailableMsg_eng")
                    dict.updateValue(structure.unavailableMsg_esp!, forKey: "unavailableMsg_esp")
                    dict.updateValue(structure.minMajorVersion!, forKey: "minMajorVersion")
                    dict.updateValue(structure.minBuildVersion!, forKey: "minBuildVersion")
                    dict.updateValue(structure.minRevisionVersion!, forKey: "minRevisionVersion")

                return dict
            }
            
            func returnArray(arrayOfDictionaries:[[String:Any]]) -> [CMS_Services.CMS_ServicesStruct] {
                var arr:[CMS_Services.CMS_ServicesStruct] = []
                arrayOfDictionaries.forEach { (dict) in arr.append(CMS_Services.CMS_ServicesStruct.init(dictionary: dict)) }
                
                return arr
            }
            
            func returnArrayOfDictionaries(arrayOfStructs:[CMS_Services.CMS_ServicesStruct]) -> [[String:Any]] {
                var arr:[[String:Any]] = []
                arrayOfStructs.forEach { (fileInfo) in
                    arr.append(CMS_Services.CMS_ServicesStruct().convertStructToDictionary(structure: fileInfo))
                }
                
                return arr
            }
        }

        func isActive(showMsg:Bool? = true, completion: @escaping (Bool,String,String,Int,Int,Int,Bool) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,"","",0,0,0,false) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.SERVER.isActive
            guard let scriptURL = URL(string:"\(appInfo.COMPANY.SERVER.SCRIPTS.services!)/\(scriptName)")
            else { return completion(false,"","",0,0,0,false) }
            
            /* Setup parameters to pass to script */
            let params:Alamofire.Parameters = [
                "appVersion":Bundle.main.fullVer,
                "calledFromApp":appInfo.EDITION.appEdition!
            ]
            
            if showMsg! { waitHUD().showNow(msg: "\( dbActions.SEARCH.verb ) \( "Wait.Server.Available".localizedCAS() )...") }
            Server().dumpParams(params, scriptName: scriptName)

            Alamofire.request(scriptURL, parameters: params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseJSON(completionHandler: { response in
                if showMsg! { waitHUD().hideNow() }
                Server().dumpURLfromResponse(response)
                
                switch response.result {
                case .success:
                    let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                    let stat = CMS_Services.CMS_ServicesStruct.init(dictionary: results.records.first!)

                    var requiresUpdate = false
                    let current_Ver = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
                    
                    let serverMin_Ver = "\(stat.minMajorVersion!).\( stat.minBuildVersion < 10 ?"0\(stat.minBuildVersion!)" :"\(stat.minBuildVersion!)" )"

                    if ((current_Ver < serverMin_Ver)) {
                        requiresUpdate = true
                    }
                    
                    completion(
                        Bool(stat.active),
                        stat.unavailableMsg_eng,
                        stat.unavailableMsg_esp,
                        stat.minMajorVersion,
                        stat.minBuildVersion,
                        stat.minRevisionVersion,
                        requiresUpdate
                    )
                case .failure(let error):
                    if let err = response.result.error as? AFError {
                        Server().displayAlamoFireError(err,scriptTitle: scriptName)
                    }else{
                        simPrint().error("Error Code: \(error._code)\n\n\(error.localizedDescription)",function:#function,line:#line)
                    }

                    completion(false,"","",0,0,0,false)
                }
            })
        }
    
        func updateActive(active:Bool,msg_eng:String,msg_esp:String,completion: @escaping (Bool) -> Void) {
            if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false) }
            
            URLCache.shared.removeAllCachedResponses()
            let scriptName = serverScriptNames.SERVER.updateActive
            guard let scriptURL = URL(string:"\(appInfo.COMPANY.SERVER.SCRIPTS.services!)/\(scriptName)")
            else { return completion(false) }
            
            let newStatus:Int = active.intValue
            
            /* Setup parameters to pass to script */
            let params:Alamofire.Parameters = [
                "active":newStatus,
                "msg_eng":msg_eng,
                "msg_esp":msg_esp,
                "appVersion":Bundle.main.fullVer,
                "calledFromApp":appInfo.EDITION.appEdition!
            ]
            
            waitHUD().showNow(msg: "\( dbActions.UPDATE.verb ) \( "Wait.Server.Available".localizedCAS() )...")
            Server().dumpParams(params, scriptName: scriptName)

            Alamofire.request(scriptURL, parameters: params)
            .validate(statusCode: 200..<300)
            .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
            .responseJSON(completionHandler: { response in
                waitHUD().hideNow()
                Server().dumpURLfromResponse(response)
                
                switch response.result {
                case .success:
                    let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                    
                    completion(results.success)
                case .failure(let error):
                    if let err = response.result.error as? AFError {
                        Server().displayAlamoFireError(err,scriptTitle: scriptName)
                    }else{
                        simPrint().error("Error Code: \(error._code)\n\n\(error.localizedDescription)",function:#function,line:#line)
                        completion(false)
                    }
                }
            })
        }
    }

// MARK: - *** JSON DATA FUNCTIONS ***
    func returnTupleForCAS_PhP_JSON(_ alamoFire_response:Alamofire.DataResponse<Any>,scriptTitle:String) -> (debug:Bool,version:String,stack:[String],found:Int,success:Bool,records:[[String:Any]]) {
        guard let JSONdict = alamoFire_response.result.value as? [String:Any],
              let version = JSONdict["version"] as? String,
              let stack = JSONdict["stack"] as? [String],
              let found = JSONdict["found"] as? Int,
              let success = JSONdict["success"] as? Bool
        else {
            dumpStack(["n/a"], scriptName:scriptTitle, version:"n/a")
            return (false,"",["n/a"],0,false,[])
        }

        /* Handle whether JSON returns an Array of Dictionaries or a Dictionary and force into an array of dictionaries */
        var records:[[String:Any]] = []
        if let results = JSONdict["records"] as? [[String:Any]] {
            records = results
        }else if let results = JSONdict["records"] as? [String:Any] {
            records = [results]
        }
        
        let debugValue = JSONdict["debug"] as? Int ?? 0
        let debug = Bool(debugValue)

        simPrint().success(
             """
            \n\n\( "=".repeatNumTimes(80) )")/n
            📲📜 RESPONSE DUMP for \( scriptTitle ) 📜📲/n
            \( "=".repeatNumTimes(80) )/n
            \( Server().dumpURLfromResponse(alamoFire_response) ) /n
            • DEBUG MODE: \( debug ?"True" :"False" )/n
            • Version: \( version )/n
            • Found: \( found )/n
            • Success: \( success ?"True" :"False" )/n
            • Record Count: \( records.count )/n
            • Records: \( (records.count > 0) ?"True" :"False" )/n
            \( dumpStack(stack, scriptName:scriptTitle, version:version) )/n
            """,function:#function,line:#line
        )

        return (debug,version,stack,found,success,records)
    }

// MARK: - *** SERVER FILE FUNCTIONS ***
    func downloadFile(fromURL:URL,toURL:URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fromURL)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil { // Success
               let statusCode = Int((response as? HTTPURLResponse)?.statusCode ?? -1)
               let lastModifiedDate = (response as? HTTPURLResponse)?.allHeaderFields["Last-Modified"]
                
                /* Determine if last-modified date is present, if so update */
                if ((statusCode >= 0) && isSimDevice) {
                    print("Successfully downloaded. Status code: \( statusCode )")
                    
                    let lastModifiedDateString = (lastModifiedDate as! String)
                    if lastModifiedDateString.isNotEmpty {
                        /* Convert HMTL Header date to UNIX file std format */
                        var lastModDate = lastModifiedDateString
                            .convertToDate(format: kDateFormat.HTML_HDR_RESPONSE)
                            .toString(format: kDateFormat.SQL)

                        print("Last-Modified Date converted to date: \( lastModDate )")

                        lastModDate = lastModDate
                            .convertToDate(format: kDateFormat.SQL)
                            .UTCToLocal(date: lastModDate)

                        print("Last-Modified Date converted from UTC to local: \( lastModDate )")
                        print("-------------------------------")
                    }
                }
                
                // Delete file if already exists...
                do {
                    if FileManager.default.fileExists(atPath: toURL.path) {
                        simPrint().info("Found old file: \( toURL.path.lastPathComponent ).",function:#function,line:#line)
                        try FileManager.default.removeItem(at: toURL)
                        simPrint().success("<#comment text#>",function:#function,line:#line)
                        simPrint().success("Successfully deleted old file: \( toURL.path.lastPathComponent ).",function:#function,line:#line)
                    }
                } catch {
                    simPrint().error("Error deleting  file \( toURL.path ) : \( error )",function:#function,line:#line)
                }

                // Copy file if already exists...
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: toURL)
                    simPrint().success("Successfully copied file: \( toURL.path.lastPathComponent ).",function:#function,line:#line)
                } catch {
                    simPrint().error("Error copying file \( toURL.path.lastPathComponent ) : \( error )",function:#function,line:#line)
                }
            }else{
                simPrint().error("Error downloading \( toURL.path.lastPathComponent ), Error = \( error?.localizedDescription as Any )",function:#function,line:#line)
            }
        }
        
        task.resume()
    }
    
    func serverFileExists(fileNameAndPath:String, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }

        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.FILES.serverFileExists
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.files!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }

        /* Setup parameters to pass to script */
        let params:Alamofire.Parameters = [
            "folderAndfileName":fileNameAndPath,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]
        
        Server().dumpParams(params, scriptName: scriptName)
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            Server().dumpURLfromResponse(response)
            
            switch response.result {
            case .success:
                let dict = response.result.value as! [String:Any]
                let success = dict["success"] as! Bool
                if success {
                    completion(true,.none)
                }else{
                    completion(false,.items_NotFound)
                }
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
    
    /// Returns all of the files in the server directory. The script surpresses the "." and ".." items.
    /// - parameter folderPath: ex: "https://sqframe.com/client-tools/squareframe"
    /// - requires: Alamofire + "CAS_Get_Directories.php"
    /// - returns: ["Files"] as? [String:Any], ["FilesAndDates" as? [String:String], ["Status"] as? String
    func get_FilesInDirectory(showMsg:Bool? = false,folderPath:String,completion: @escaping (Bool,[Server.filesStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }

        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.FILES.getDirectoryFiles
        let className = Server().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.files!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }

        let params:Alamofire.Parameters = [
            "folderAndfileName" : folderPath,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]

        if showMsg! { waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") } 
        Server().dumpParams(params,scriptName: scriptName)

        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)

            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["success"] as? Bool,
                   let arrFiles = JSONdict["filesAndDates"] as? [[String:Any]] {

                    let filesArray:[Server.filesStruct] = Server.filesStruct().returnArray(arrayOfDictionaries: arrFiles)
                    
                    completion(success,success ?filesArray :[],success ?.none :.notFound(scriptname: scriptName))
                }else{
                    completion(false,[],.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }

    func getFilesForOrder(orderID:String,completion: @escaping (Bool,[Server.filesStruct],cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,[],.network_Unavailable) }
        
        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.ORDERS.getOrderFiles
        let className = Server().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.orders!)/\(scriptName)")
        else { return completion(false,[],.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "orderNum" : orderID,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp" : appInfo.EDITION.appEdition!
        ]
        
        waitHUD().showNow(msg: "\( dbActions.LIST.verb ) \( className )...") 
        
        let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970 // It is necessary for correct decoding. Timestamp -> Date.
        
        Alamofire.request(scriptURL, parameters:params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
            Server().dumpURLfromResponse(response)

            switch response.result {
            case .success:
                if let JSONdict = response.result.value as? [String:Any],
                   let success = JSONdict["success"] as? Bool,
                   let arrFiles = JSONdict["filesAndDates"] as? [[String:Any]] {
                    
                    let filesArray:[Server.filesStruct] = Server.filesStruct().returnArray(arrayOfDictionaries: arrFiles)
                    
                    completion(success,success ?filesArray :[],success ?.none :.notFound(scriptname: scriptName))
                }else{
                    completion(false,[],.notInserted(scriptname:scriptName))
                }
            case .failure(let error):
                completion(false,[],.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }


// MARK: - *** PHP FUNCTIONS ***
    func displayServerErrorMsg(_ msg:String) {
        sharedFunc.ALERT().show(
            title: "ERROR",
            style: .serverError,
            msg: msg
        )
    }
    
    func displayServerNoRecordsMsg(_ msg:String) {
        waitHUD().hideNow()
        
        let alert = CASAlertView()
            alert.appearance.blurEffect = .dark
            alert.appearance.showCloseButton = true
    
        let timeoutAction:CASAlertView.SCLTimeoutConfiguration.ActionType = { CASAlertView().hideView() }
        let timeout = CASAlertView.SCLTimeoutConfiguration(timeoutValue: 5.0, timeoutAction: timeoutAction)
    
        sharedFunc.THREAD().doNow {
            alert.showCustom(
                title: "CMS SERVER",
                subTitle: "\n\(msg)\n",
                color: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1),
                icon: #imageLiteral(resourceName: "CAS_Server").recolor(.white),
                closeButtonTitle: "OK".localizedCAS(),
                timeout: timeout,
                colorTextButton: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).convertToUInt()
            )
        }
    }
    
    func displayAlamoFireError(_ error:AFError, scriptTitle:String) {
        var errorReason:String = ""
        
        if let error = error as AFError? {
            switch error {
            case .invalidURL(let url): errorReason = "Invalid URL: \(url) - \(error.localizedDescription)"
            case .parameterEncodingFailed(let reason): errorReason = "Parameter encoding failed: \(error.localizedDescription)\n\nFailure Reason: \(reason)"
            case .multipartEncodingFailed(let reason): errorReason = "Multipart encoding failed: \(error.localizedDescription)\n\nFailure Reason: \(reason)"
            case .responseSerializationFailed(let reason): errorReason = "Response serialization failed: \(error.localizedDescription)\n\nFailure Reason: \(reason)"
            case .responseValidationFailed(let reason):
                switch reason {
                case .dataFileNil, .dataFileReadFailed: errorReason = "Downloaded file could not be read"
                case .missingContentType(let acceptableContentTypes): errorReason = "Content Type Missing: \(acceptableContentTypes)"
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType): errorReason =  "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                case .unacceptableStatusCode(let code):
                    switch error.responseCode! {
                    case 400: errorReason = "Bad Request: The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing)"
                    case 401: errorReason = "Unauthorized: Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided. The response must include a WWW-Authenticate header field containing a challenge applicable to the requested resource. See Basic access authentication and Digest access authentication.[33] 401 semantically means 'unauthenticated', i.e. the user does not have the necessary credentials.\n\nNote: Some sites issue HTTP 401 when an IP address is banned from the website (usually the website domain) and that specific address is refused permission to access a website."
                    case 403: errorReason = "Forbidden: The request was valid, but the server is refusing action. The user might not have the necessary permissions for a resource, or may need an account of some sort."
                    case 404: errorReason = "Not Found: File or Directory was not found."
                    case 405: errorReason = "Method Not Allowed: A request method is not supported for the requested resource; for example, a GET request on a form that requires data to be presented via POST, or a PUT request on a read-only resource."
                    case 406: errorReason = "Not Acceptable: The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request."
                    case 407: errorReason = "Proxy Authentication Required: The client must first authenticate itself with the proxy."
                    case 408: errorReason = "Request Timeout: The server timed out waiting for the request. According to HTTP specifications: 'The client did not produce a request within the time that the server was prepared to wait. The client MAY repeat the request without modifications at any later time.'"
                    case 409: errorReason = "Conflict: Indicates that the request could not be processed because of conflict in the request, such as an edit conflict between multiple simultaneous updates."
                    case 410: errorReason = "Gone: Indicates that the resource requested is no longer available and will not be available again. This should be used when a resource has been intentionally removed and the resource should be purged. Upon receiving a 410 status code, the client should not request the resource in the future. Clients such as search engines should remove the resource from their indices. Most use cases do not require clients and search engines to purge the resource, and a '404 Not Found' may be used instead."
                    case 411: errorReason = "Length Required: The request did not specify the length of its content, which is required by the requested resource."
                    case 412: errorReason = "Precondition Failed: The server does not meet one of the preconditions that the requester put on the request."
                    case 413: errorReason = "Payload Too Large: The request is larger than the server is willing or able to process. Previously called 'Request Entity Too Large'."
                    case 414: errorReason = "URI Too Long: The URI provided was too long for the server to process. Often the result of too much data being encoded as a query-string of a GET request, in which case it should be converted to a POST request. Called 'Request-URI Too Long' previously."
                    case 415: errorReason = "Unsupported Media Type: The request entity has a media type which the server or resource does not support. For example, the client uploads an image as image/svg+xml, but the server requires that images use a different format."
                    case 416: errorReason = "Range Not Satisfiable: The client has asked for a portion of the file (byte serving), but the server cannot supply that portion. For example, if the client asked for a part of the file that lies beyond the end of the file. Called 'Requested Range Not Satisfiable' previously."
                    case 417: errorReason = "Expectation Failed: The server cannot meet the requirements of the Expect request-header field."
                    case 418: errorReason = "I'm a teapot: This code was defined in 1998 as one of the traditional IETF April Fools' jokes, in RFC 2324, Hyper Text Coffee Pot Control Protocol, and is not expected to be implemented by actual HTTP servers. The RFC specifies this code should be returned by teapots requested to brew coffee. This HTTP status is used as an Easter egg in some websites, including Google.com."
                    case 421: errorReason = "Misdirected Request: The request was directed at a server that is not able to produce a response. (for example because of a connection reuse)"
                    case 422: errorReason = "Unprocessable Entity: The request was well-formed but was unable to be followed due to semantic errors."
                    case 423: errorReason = "Locked: The resource that is being accessed is locked."
                    case 424: errorReason = "Failed Dependency: The request failed due to failure of a previous request (e.g., a PROPPATCH)"
                    case 426: errorReason = "Upgrade Required: The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field."
                    case 428: errorReason = "Precondition Required: The origin server requires the request to be conditional. Intended to prevent the 'lost update' problem, where a client GETs a resource's state, modifies it, and PUTs it back to the server, when meanwhile a third party has modified the state on the server, leading to a conflict."
                    case 429: errorReason = "Too Many Requests: The user has sent too many requests in a given amount of time. Intended for use with rate-limiting schemes."
                    case 431: errorReason = "Request Header Fields Too Large: The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large."
                    case 451: errorReason = "Unavailable For Legal Reasons: A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource. The code 451 was chosen as a reference to the novel Fahrenheit 451 (see the Acknowledgements in the RFC)."
                    case 500: errorReason = "Internal Server Error: A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.\n\nThis could be a forgotten ; character in script."
                    case 501: errorReason = "Not Implemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request. Usually this implies future availability (e.g., a new feature of a web-service API)."
                    case 502: errorReason = "Bad Gateway: The server was acting as a gateway or proxy and received an invalid response from the upstream server."
                    case 503: errorReason = "Service Unavailable: The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state."
                    case 504: errorReason = "Gateway Timeout: The server was acting as a gateway or proxy and did not receive a timely response from the upstream server."
                    case 505: errorReason = "HTTP Version Not Supported: The server does not support the HTTP protocol version used in the request."
                    case 506: errorReason = "Variant Also Negotiates: Transparent content negotiation for the request results in a circular reference."
                    case 507: errorReason = "Insufficient Storage: The server is unable to store the representation needed to complete the request."
                    case 508: errorReason = "Loop Detected: The server detected an infinite loop while processing the request (sent in lieu of 208 Already Reported)."
                    case 510: errorReason = "Not Extended: Further extensions to the request are required for the server to fulfil it."
                    case 511: errorReason = "Network Authentication Required: The client needs to authenticate to gain network access. Intended for use by intercepting proxies used to control access to the network (e.g., 'captive portals' used to require agreement to Terms of Service before granting full Internet access via a Wi-Fi hotspot)."
                    default: errorReason = "Response status code was unacceptable: \(code)"
                    }
                }
            }
        } else {
            errorReason = "Unknown error: \(error)"
        }
        
        let errText = error.responseCode ?? 0
        
        simPrint().error(
             """
            \n\n
            /( "=".repeatNumTimes(50) )/n
            PhP SCRIPT ERROR #\( errText ) with '\( scriptTitle )' script.\n
            Reason: \(errorReason)/n
            /( "=".repeatNumTimes(50) )/n
            """,function:#function,line:#line
        )
        
        sharedFunc.ALERT().show(
            title:"error.PHP_Title".localizedCAS(),
            style:.error,
            msg:"\(scriptTitle)\n\n\( errorReason )"
        )
    }
    
    func dumpParams(_ params:Parameters, scriptName:String? = "n/a") {
        if isSimDevice.isFalse { return }
    
        let repeats:Int = 50
        var padding:Int = 0
        var charCount:Int = 0

        for item in params {
            let keyCount = String(describing: item.0).count
            if keyCount > padding { padding = keyCount }
            charCount += String(describing: item.0).length
            charCount += String(describing: item.1).length
        }

        print ("\n\("-".repeatNumTimes(repeats))")
        print ("*** Dump of Parameters ***")
        print ("*** \(scriptName!) ***")
        print ("character Count: \( charCount )")
        print ("\("-".repeatNumTimes(repeats))")
        for item in params {
            var val = String(describing: item.1)
            if val.isEmpty { val = "{␢ empty}" }
            var key = String(describing: item.0)
            key = " ".repeatNumTimes(padding - key.count) + key
            
            print ("\(key) = \(val)")
        }
        print ("\("-".repeatNumTimes(repeats))\n")
    }

    func dumpURLfromResponse(_ response:Alamofire.DataResponse<Any>) {
        simPrint().info("\nResponse URL (chars: \(response.request!.url!.absoluteString.length)):\n\(response.request!.url!)\n")
    }
    
    func dumpURLfromResponseString(_ response:Alamofire.DataResponse<String>) {
        simPrint().info("\nResponse URL (chars: \(response.request!.url!.absoluteString.length)):\n\(response.request!.url!)\n")
    }
    
    /// Server().dumpURLfromDecodableResponse(responseRequestURL: (response.request?.url?.absoluteString)!)
    func dumpURLfromDecodableResponse(responseRequestURL: String) {
        simPrint().info("\nResponse URL (chars: \(responseRequestURL.length)):\n\(responseRequestURL)\n")
    }
    
    func dumpStack(_ stack:[String],scriptName:String? = "",version:String? = "") {
        if isSimDevice {
            print ("\n\n\("=".repeatNumTimes(80))")
            print("📲📜 STACK DUMP for \( scriptName! ) 📜📲")
            if scriptName!.isNotEmpty { print("• script Name: \( scriptName! )") }
            if version!.isNotEmpty { print("• script version: \( version! )") }
            print ("\("=".repeatNumTimes(80))")
            var counter = 0
            for item in stack {
                counter += 1
                if counter < 10 {
                    print("📜  \(counter): \(item)")
                }else{
                    print("📜 \(counter): \(item)")
                }
            }
            print ("\("=".repeatNumTimes(80))")
            print ("\n\n")
        }
    }

    func showPasscodeLogin(
        vc:UIViewController,
        accessTo:String,
        msg:String? = "Enter the passcode for access to Administrative Functions.",
        completion: @escaping (Bool,cmsError) -> Void
    ) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }
        
        let alert = UIAlertController( title: "RESTRICTED ACCESS",message: msg!,preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Passcode"
            textField.text = ""
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.returnKeyType = .done
            textField.enablesReturnKeyAutomatically = false
            textField.addTarget(
                alert,
                action: #selector(alert.textDidChangeInPasscodeAlert),
                for: .editingChanged
            )
        }
        
        let okAction = UIAlertAction(title: "Login", style: .default) { (action) -> Void in
            if let firstTextField = alert.textFields![0] as UITextField? {
                let passcode:String = firstTextField.text!

                Server().validatePasscode(name:accessTo, passcode: passcode, showInvalidMsg: true, completion: { (success,error) in
                    completion(success,error)
                })
            }else{
                completion(false,.none)
            }
        }

        let dismissAction = UIAlertAction(title: "Cancel".localizedCAS(), style: .destructive) { (action) -> Void in
        }

        alert.addAction(dismissAction)
        alert.addAction(okAction)

        /* Appearance */
        alert.view.tintColor = gAppColor
        sharedFunc.DRAW().roundCorner(view: alert.view, radius: 16, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 2.25)

        if alert.isValidPassword("invalid entry to cause error on purpose to disable button").isTrue {
            okAction.isEnabled = true
            okAction.setValue("Login".localizedCAS(), forKey: "title")
            okAction.setValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: "titleTextColor")
        }else{
            okAction.isEnabled = false
            okAction.setValue("--", forKey: "title")
            okAction.setValue(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), forKey: "titleTextColor")
        }
        
        okAction.setValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: "titleTextColor")
        dismissAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        
        vc.present(alert, animated: true)
    }
    
    func validatePasscode(name:String,passcode:String, showInvalidMsg:Bool, completion: @escaping (Bool,cmsError) -> Void) {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return completion(false,.network_Unavailable) }

        URLCache.shared.removeAllCachedResponses()
        let scriptName = serverScriptNames.PASSCODES.validate
        let className = Passcodes().name
        guard let scriptURL = URL(string: "\(appInfo.COMPANY.SERVER.SCRIPTS.accounts!)/\(scriptName)")
        else { return completion(false,.script_CreationFailed(scriptname: scriptName)) }
        
        let params:Alamofire.Parameters = [
            "name":name,
            "passcode":passcode,
            "appVersion":Bundle.main.fullVer,
            "calledFromApp":appInfo.EDITION.appEdition!
        ]

        waitHUD().showNow(msg: "\( dbActions.VALIDATE.verb ) \( className )...") 
        Server().dumpParams(params,scriptName: scriptName)
        
        Alamofire.request(scriptURL, parameters: params)
        .validate(statusCode: 200..<300)
        .authenticate(user: appInfo.COMPANY.SERVER.LOGIN.name, password: appInfo.COMPANY.SERVER.LOGIN.password)
        .responseJSON(completionHandler: { response in
            waitHUD().hideNow()
        
            switch response.result {
            case .success:
                let results = Server().returnTupleForCAS_PhP_JSON(response, scriptTitle: scriptName)
                
                completion(results.success,results.success ?.none :.account_mismatch)
            case .failure(let error):
                completion(false,.alamoFire_failed(error: CMS().processError(error: error,scriptName: scriptName)))
            }
        })
    }
}

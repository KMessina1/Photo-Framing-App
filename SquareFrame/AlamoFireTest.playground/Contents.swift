////: Playground - noun: a place where people can play
//
//import UIKit
//import Alamofire
//import PlaygroundSupport
//
//var manager: Alamofire.SessionManager!
//
//func dirDocuments(fileName:String?=nil) -> String {
//    var docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//    if fileName != nil {
//        docDir = docDir.stringByAppendingPathComponent(fileName!)
//    }
//    
//    return docDir
//}
//
//public extension String {
//    func stringByAppendingPathComponent(_ path: String) -> String {
//        let nsSt = self as NSString
//        
//        return nsSt.appendingPathComponent(path)
//    }
//}
//
//class Test {
//    func uploadImageAndData(imgName: String, orderNumber: String, address: String){
//        let serverScriptsFolder:String! = "http://sqframe.com/client-tools/squareframe/SF_UploadFile.php"
//
//    //    let uploadURL = URL(string: "http://localhost:8888/SF_UploadFile.php")!
//        let filepath = Bundle.main.url(forResource: "Photo_999_1", withExtension: "png")!
//    //    let filepath = dirDocuments(fileName: imgName)
//    //    let imgURL:URL! = URL(string: filepath)!
//        let uploadURL = URL(string: serverScriptsFolder!)!
//        
//        print("\n\nUpload URL: \(uploadURL.absoluteString)\n\n")
//        print("Image URL: \(filepath.absoluteString)\n\n")
//        
//        let config = URLSessionConfiguration.default
//            config.timeoutIntervalForRequest = 100
//        
//        manager = Alamofire.SessionManager(configuration: config)
//        manager.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(filepath, withName: imgName)
////            multipartFormData.append(filepath, withName: "\(orderNumber)\(address)")
//        },to: uploadURL.absoluteString, encodingCompletion: { encodingResult in
//            print("\nEncoding completed")
//            switch encodingResult {
//                case .success(let upload, _, _): upload
//                        .uploadProgress { progress in
//                            print("\(imgName) Upload progress: \(progress.fractionCompleted * 100)%")
//                        }
//                        .responseData { JSON in
//                            print("\nFinished uploading.")
//                            print("\(JSON.data!)")
//                            PlaygroundPage.current.needsIndefiniteExecution = false
//                    }
//                case .failure(let encodingError):
//                    print("\nFailed uploading.")
//                    print(encodingError)
//                    PlaygroundPage.current.needsIndefiniteExecution = false
//            }
//        })
//    }
//}
//
//let test = Test()
//PlaygroundPage.current.needsIndefiniteExecution = true
//test.uploadImageAndData(imgName: "Photo_999_1.png", orderNumber: "12345", address: "123 Main Street")

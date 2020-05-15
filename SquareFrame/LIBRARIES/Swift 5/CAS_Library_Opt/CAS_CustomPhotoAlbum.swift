/*--------------------------------------------------------------------------------------------------------------------------
   File: CAS_CustomPhotoAlbum.swift
 Author: Kevin Messina
Created: March 4, 2017
 
©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Base on answer from https://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
--------------------------------------------------------------------------------------------------------------------------*/

import Photos  // Include Photos.framework in each target.

/// Set CustomPhotoAlbum.albumName = "{Your album name here}" before calling any functions.
class CustomPhotoAlbum: NSObject {
    var Version: String { return "1.02" }

    static var albumName = appInfo.PHOTOS.SF_Customer_Photos ?? "CAS Custom Album"
    static let sharedInstance = CustomPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted 
            // until after init was done.
            if isSim { print("trying again to create the custom album...") }
            self.createAlbum()
        } else {
            sharedFunc.ALERT().show(
                title: "PhotoLibrary_Title".localized(),
                style:.error,
                msg: "PhotoLibrary_NoAccess".localized()
            )
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            // create an asset collection with the album name
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                sharedFunc.ALERT().show(
                    title:"error.unkown_Title".localized(),
                    style:.error,
                    msg:"error.unkown_Msg".localized()
                )
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions:PHFetchOptions = PHFetchOptions.init()
            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album,
                                                              subtype: .any,
                                                              options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    func save(image: UIImage, filename:String, callback:String? = "") {
        if assetCollection == nil {
            return  // if there was an error upstream, skip the save
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
        }, completionHandler: { (response, error) in
            let success:Bool = (error == nil)
            
            if callback!.isNotEmpty {
                NotificationCenter.default.post(name: Notification.Name(callback!),
                                              object: nil,
                                            userInfo: ["success":success,"filename":filename])
            }
        })
    }

    func fetchLastImageURL() -> String {
        let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if (fetchResult.firstObject != nil) {
            let lastImageAsset: PHAsset = fetchResult.firstObject!
            
            return lastImageAsset.localIdentifier
        } else {
            return ""
        }
    }
}


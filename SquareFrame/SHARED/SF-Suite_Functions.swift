/*--------------------------------------------------------------------------------------------------------------------------
      File: SF-Suite_Functions.swift
    Author: Kevin Messina
   Created: Nov. 26, 2018
Modified:

©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: These are shared functions for all apps in the suite.

--------------------------------------------------------------------------------------------------------------------------*/


import Foundation
import UIKit

/// Determine if there is a selected photo either saved or in tempItem struct.
func isPhotoSelected() -> Bool {
    let photoFileFound = sharedFunc.FILES().exists(filePathAndName: selectedPhotoFilepath)
    let tempPhotoSet = ((tempItem.photo != nil) && (tempItem.photo.size != CGSize.zero))

    return (photoFileFound || tempPhotoSet)
}

/// Determine if there is a selected photo either saved or in tempItem struct.
/// Note: CMS Services need to be OFF for test user byoass to be possible otherwise not needed.
func showTestUserInfo(CMS_Services_Active isActive:Bool) {
    if (isActive.isFalse && isTestDeviceOrUser()) {
        let testuser = returnTestUserInfo()
        
        simPrint().info("xCode (Simulator) w/test User: \( testuser.displayName )",function:#function,line:#line)
        
        sharedFunc.ALERT().show(
            title: "CMS SERVER=OFF BYPASS",
            style: .warning,
            msg: "Bypassing the CMS Server Status = OFF for testing.\n\nID = \( testuser.displayName )",
            forceStyling: true,
            delay: 0.50
        )
    }
}

func returnTestUserInfo() -> testUsers {
    var testUserInfo:testUsers = testUsers.init()
    
    if isTestDevice() { 
        testUserInfo = returnTestUserWithID()
    }else{
        for tester in testers {
            if (customerInfo.ID == tester.id) {
                testUserInfo = tester
                break
            }
        }
    }
    
    return testUserInfo
}

func returnTestUserWithID(id:Int? = -1) -> testUsers {
    var testUserInfo:testUsers = testUsers.init()
    var userID = -1

    if isSimDevice { userID = 99998 }
    else if isAdhoc { userID = 99999 }
    else { userID = id! }
    
    testUserInfo = testers.filter({$0.id == userID}).first ?? testUsers.init()
    
    return testUserInfo
}

func isTestUser() -> Bool {
    var isTestUser:Bool = false
    
    for tester in testers {
        if (customerInfo.ID == tester.id) {
            isTestUser = true
            break
        }
    }
    
    return isTestUser
}

func isTestDevice() -> Bool  {
    return (isSimDevice || isAdhoc)
}

func isTestDeviceOrUser() -> Bool {
    return (isTestUser() || isTestDevice())
}





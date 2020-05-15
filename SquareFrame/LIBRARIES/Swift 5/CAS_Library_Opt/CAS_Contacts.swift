/*--------------------------------------------------------------------------------------------------------------------------
   File: Contacts.swift
 Author: Kevin Messina
Created: December 29, 2015

©2015-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import ContactsUI

public final class CAS_Contacts {
// MARK: - *** GLOBAL CONSTANTS ***
    var contactStore = CNContactStore()

// MARK: - *** FUNCTIONS ***
    func requestForAccess(completionHandler:@escaping (_ accessGranted: Bool) -> Void){
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completionHandler(true)
            case .denied, .notDetermined:
                self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                    if access {
                        completionHandler(access)
                    } else {
                        if authorizationStatus == CNAuthorizationStatus.denied {
                            DispatchQueue.main.async(execute: { () -> Void in
                                UIApplication.shared.open(
                                    URL(string: UIApplication.openSettingsURLString)!,
                                    options: [:],
                                    completionHandler: nil
                                )
                                UIApplication.shared.open(
                                    URL(string: UIApplication.openSettingsURLString)!,
                                    options: [:],
                                    completionHandler: nil
                                )
                            })
                        }
                    }
                })
            default: completionHandler(false)
        }
    }

    func authorizedAccess() -> Bool{
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
            case .authorized: return true
            case .denied, .notDetermined: return false
            default: return false
        }
    }
}

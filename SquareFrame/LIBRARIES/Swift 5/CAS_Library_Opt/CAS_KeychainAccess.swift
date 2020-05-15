/*--------------------------------------------------------------------------------------------------------------------------
   File: KeychainAccess.swift
 Author: Kevin Messina
Created: October 15, 2017

©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Requires Locksmith Cocoapod
 
--------------------------------------------------------------------------------------------------------------------------*/

import Locksmith

public final class CAS_KeychainAccess {
// MARK: - *** GLOBAL CONSTANTS ***

// MARK: - *** FUNCTIONS ***
    func get(key:String = appInfo.KEYCHAIN.key) -> String {
        // Load the existing variable from the users Keychain
        if let dict = Locksmith.loadDataForUserAccount(userAccount: appInfo.KEYCHAIN.ACCOUNT.app) {
            let value = dict[key] as? String ?? ""
            return value
        }
        
        return ""
    }

    func update(key:String = appInfo.KEYCHAIN.key,value:Any) {
        // This will store the new access token in Keychain
        try? Locksmith.updateData(data: [key: value], forUserAccount: appInfo.KEYCHAIN.ACCOUNT.app)
    }

    func deleteAll(key:String) {
        // If the access token is set to nil this will remove the entry in Keychain
        try? Locksmith.deleteDataForUserAccount(userAccount: appInfo.KEYCHAIN.ACCOUNT.app)
    }
}

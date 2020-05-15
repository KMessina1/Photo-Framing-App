/*--------------------------------------------------------------------------------------------------------------------------
    File: AppInfo.swift
  Author: Kevin Messina
 Created: Jul 25, 2018
Modified:
 
©2018-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
--------------------------------------------------------------------------------------------------------------------------*/

import Siren

class LookupResult: Decodable,Loopable {
    var results: [AppInfo_Details]
}

class AppInfo_Details: Decodable,Loopable {
    var version:String
}

class ApplicationInfo:NSObject {
    /* Siren App Store Update Delegates */
    func getAppStoreInfo(completion: @escaping (AppInfo_Details?,Bool,String,String,Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\( identifier )") else {

            DispatchQueue.main.async {
                completion(nil,false,"","",VersionError.invalidBundleInfo)
            }

            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error {
                    throw error
                }
                
                guard let data = data
                else { throw VersionError.invalidResponse }
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                
                guard let info = result.results.first
                else { throw VersionError.invalidResponse }
                
                let current_version:String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                let appstore_version:String = info.version
                let appstoreVersionErrorOccurred = (error != nil)
                let needsUpdating:Bool = appstoreVersionErrorOccurred
                    ?false
                    :(current_version != appstore_version)

                simPrint().info(
                    """
                    \nApp Store Version: \( appstore_version )/n
                    Current App Version: \( current_version )/n
                    Error: \( error?.localizedDescription ?? "unknown error" )/n
                    \( needsUpdating ?"App needs updating." :"App is current version.") )
                    """
                    ,function:#function,line:#line
                )

                completion(info,needsUpdating,appstore_version,current_version,nil)
            } catch {
                completion(nil,false,"","",error)
            }
        }
        
        task.resume()
        
        return task
    }
    
    enum VersionError: Error {
        case invalidBundleInfo, invalidResponse
    }
    
    func checkVersion() {
        let _ = ApplicationInfo().getAppStoreInfo { (appStoreInfo, needsUpdating, appStoreVer, currentVer, error) in
            if let error = error {
                print(error)
            } else if appStoreVer == currentVer {
                print("updated")
            } else {
                print("needs update")
            }
        }
    }

    func forceSirenUpdate(appStoreVersion:String,currentVersion:String) {
        let alertTitle = "Siren_Update_Title".localized(default: "UPDATE AVAILABLE")
        let updateButtonTitle = "Siren_Update_UpdateButton_Title".localized(default: "Update")
        let nextTimeButtonTitle = "Siren_Update_NextTimeButton_Title".localized(default: "Next Launch")
        let skipButtonTitle = "Siren_Update_SkipVersionButton_Title".localized(default: "Skip")
        var alertMessage = "Siren_Update_Msg".localized(default: "A newer version is available and is required to continue with purchase.")
            alertMessage += "\n\nUpgrade v\( currentVersion ) to v\( appStoreVersion )"

        let siren = Siren.shared
            siren.rulesManager = RulesManager(
                globalRules: .critical,
                showAlertAfterCurrentVersionHasBeenReleasedForDays: 0
            )
            siren.presentationManager = PresentationManager(
                alertTintColor: APPTHEME.colors().tint,
                appName: appInfo.EDITION.fullName,
                alertTitle: alertTitle,
                alertMessage: alertMessage,
                updateButtonTitle: updateButtonTitle,
                nextTimeButtonTitle: nextTimeButtonTitle,
                skipButtonTitle: skipButtonTitle,
                forceLanguageLocalization: (gAppLanguageCode == "es") ?.spanish :.english
            )

        siren.wail(performCheck: .onDemand) { results in
            switch results {
            case .success(let updateResults):
                var msg = "\n************ Appstore Version Check ************\n"
                    msg += "AlertAction: \( updateResults.alertAction )\n"
                    msg += "Localization: \( updateResults.localization )\n"
                    msg += "LookupModel: \( updateResults.model )\n"
                    msg += "UpdateType: \( updateResults.updateType )\n"
                    msg += "************ --------------------- ************\n\n"
                
                simPrint().info(msg, function: #function, line: #line)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


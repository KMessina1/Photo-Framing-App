source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.2'
use_frameworks!
inhibit_all_warnings!

# 🅒CocoaPods
def podList_Standard
    pod 'Siren', :inhibit_warnings => true
    pod 'RappleProgressHUD', :inhibit_warnings => true
    pod 'GRDB.swift', :inhibit_warnings => true
    pod 'KeepBackgroundCell', :inhibit_warnings => true
end

def podList_AppSpecific
    pod 'SlideMenuControllerSwift', :inhibit_warnings => true
    pod 'Stripe', :inhibit_warnings => true
    pod 'Locksmith', :inhibit_warnings => true

    podList_AlamoFire
end

def podList_AlamoFire
    pod 'Alamofire', '~> 4.5' , :inhibit_warnings => true
    pod 'AlamofireImage', :inhibit_warnings => true
    pod 'CodableAlamofire', :inhibit_warnings => true
    pod 'SwiftyJSON', :inhibit_warnings => true
end


# 🅧xCode Targets
abstract_target 'Builds' do
    podList_Standard
    podList_AppSpecific

    target 'SF-Beta' do end
    target 'SF-AppStore' do end
    
    # Suppress the -PIE warning in xCode
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['LD_NO_PIE'] = 'NO'
            end
        end
    end
end

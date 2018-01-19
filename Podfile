platform :ios, ’10.0’

inhibit_all_warnings!
use_frameworks!

def shared_pods
    
    # Promise
    pod 'PromiseKit'
    
    # Networking
    pod 'Alamofire'
    
    # Analytics
    pod 'Fabric'
    pod 'Crashlytics'
    
    # Keychain abstraction
    pod 'KeychainAccess'
    
    # Layout
    pod 'SnapKit', '~> 4.0.0'
    
    # Common
    pod 'Common', :git => 'git@github.com:ignotusverum/iOS-common.git'
    
    # Status bar view
    pod 'JDStatusBarNotification'
end

target ‘Prod’ do
    shared_pods
end

target ‘Stage’ do
    shared_pods
end

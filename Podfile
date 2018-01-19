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
    pod 'Common', :git => 'https://github.com/fevo-tech/iOS-common.git'
    
    # Status bar view
    pod 'JDStatusBarNotification'
end

target ‘QRCodeReader’ do
    shared_pods
end

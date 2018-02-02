platform :ios, ’10.0’

inhibit_all_warnings!
use_frameworks!

def shared_pods
    
    # Promise
    pod 'PromiseKit'
    
    # Analytics
    pod 'Fabric'
    pod 'Crashlytics'
    
    # JSON
    pod 'Marshal'
    
    # Empty state
    pod 'DZNEmptyDataSet'
    
    # Keyboard
    pod 'IQKeyboardManager'
    
    # Layout
    pod 'SnapKit', '~> 4.0.0'
    
    # Common
    pod 'Common', :git => 'https://github.com/fevo-tech/iOS-common.git'
    
    # Empty stat loading
    pod 'Windless'
    
    # Status bar view
    pod 'JDStatusBarNotification'
end

target ‘Prod’ do
    shared_pods
end

target ‘Stage’ do
    shared_pods
end


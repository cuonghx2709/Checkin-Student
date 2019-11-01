# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def pods
  # core RxSwift
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod "RxAppState"
  pod "RxGesture"
  
  # Clean Architecture
  pod 'MGArchitecture'
  pod 'MGAPIService' 
  pod 'MGLoadMore'
  
  # Community projects
  pod 'NSObject+Rx'
  
  # Realm database
  pod 'RealmSwift'
  pod 'RxRealm'
  pod 'Kingfisher'
  
  # Core
  pod 'Reusable'
  pod 'Then'
  
  #Mapping
  pod 'ObjectMapper'
  
  
  pod 'SVProgressHUD'
  pod 'Validator'
  
  pod 'OrderedSet'
  pod 'MBProgressHUD'
  pod 'SDWebImage'
  
  #support UI
  pod "ESTabBarController-swift"
  pod 'lottie-ios'
  pod 'Toaster'
  
  # Keychain
  pod 'SwiftKeychainWrapper', '3.2'
  
end

def test_pods
  pod 'RxBlocking', '4.5'
  pod 'Mockingjay', :git => 'https://github.com/anhnc55/Mockingjay.git', :branch => 'swift_5'
end

target 'Checkin-Student' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  pods

  target 'Checkin-StudentTests' do
    inherit! :search_paths
    test_pods
  end

end

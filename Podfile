platform :ios, '9.0'

target 'zamin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for zamin
    pod 'PagingMenuController'
    pod 'SVProgressHUD'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'Firebase/Core'
    pod 'Crashlytics', '~> 3.10.1'
    pod 'Fabric', '~> 1.7.5'

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '4.0'
end
end
end
end

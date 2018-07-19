# Uncomment the next line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'ShoppingLand' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShoppingLand
pod 'Kingfisher', '~> 4.0'
pod "KRProgressHUD"
pod 'SCLAlertView'
pod 'EFInternetIndicator'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
              end
          end
      end
  end

target 'MomCare' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Then'
  pod 'PopupDialog'
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'RealmSwift', '~> 10.28'
  pod 'Presentr'
  pod "ESPullToRefresh"
  # Pods for MomCare

end

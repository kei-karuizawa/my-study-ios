# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

install! 'cocoapods',
          deterministic_uuids: false,
          disable_input_output_paths: true,
          generate_multiple_pod_projects: true,
          warn_for_unused_master_specs_repo: false  # pod 1.10.0版本默认源指向CocoaPods，为了消除警告⚠️

inhibit_all_warnings!

source 'https://cdn.cocoapods.org/'

target 'MyStudyiOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyStudyiOS
  pod 'Alamofire'
  pod 'lottie-ios'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'KirihaCodeKit'
  pod 'FSPagerView'

  target 'MyStudyiOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyStudyiOSUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = "NO"
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
        config.build_settings['RELEASE_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
        config.build_settings['CODE_SIGN_IDENTITY'] = 'Don\'t Code Sign'
      end
    end
    
    installer.pod_target_subprojects.flat_map { |p| p.targets }.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = "NO"
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
        config.build_settings['RELEASE_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
      end
    end
  end
end

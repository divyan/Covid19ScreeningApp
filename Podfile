# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'naik5500_final' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for naik5500_final

  target 'naik5500_finalTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'naik5500_finalUITests' do
    # Pods for testing
  end
    
    post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
      
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
       end
    end


    
	#Install Pods 
	pod 'Firebase/Auth'
	pod 'Firebase/Analytics'
	pod 'Firebase/Core'
	pod 'Firebase/Firestore'
end

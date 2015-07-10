
use_frameworks!

pod 'TesseractOCRiOS'


post_install do |installer|
  installer.project.targets.each do |target|
    if target.name == 'Pods-TesseractOCRiOS'
      puts "Setting preprocessor macro for #{target.name}..."
      target.build_configurations.each do |config|
        puts "#{config} configuration..."
        config.build_settings['ENABLE_BITCODE'] = false
        puts "after: #{config.build_settings['ENABLE_BITCODE'].inspect}"
        puts '---'
      end
    end
  end
end

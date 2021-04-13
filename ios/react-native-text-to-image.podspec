require "json"

package = JSON.parse(File.read(File.join(__dir__, "../package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-text-to-image"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-text-to-image
                   DESC
  s.homepage     = "https://github.com/andresousa/react-native-text-to-image"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "André Sousa" => "andre.sousa07@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/andresousa/react-native-text-to-image.git", :tag => "#{s.version}" }
  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  #s.dependency "others"

end

  
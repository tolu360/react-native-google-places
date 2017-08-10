require 'json'
package = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|
  s.name                = "RNGooglePlaces"
  s.version             = package["version"]
  s.summary             = package["description"]
  s.license             = package['license']
  s.author              = "Tolu Olowu"
  s.homepage            = "https://github.com/tolu360/react-native-google-places"
  s.source              = { :git => "https://github.com/tolu360/react-native-google-places.git", :tag => "v#{s.version}" }
  s.platform            = :ios, "8.0"
  s.preserve_paths      = 'README.md', 'package.json', '*.js'
  s.source_files        = 'ios/**/*.{h,m}'
end

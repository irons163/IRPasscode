Pod::Spec.new do |spec|
  spec.name         = "IRPasscode"
  spec.version      = "0.1.0"
  spec.summary      = "A powerful passcode of iOS."
  spec.description  = "A powerful passcode of iOS."
  spec.homepage     = "https://github.com/irons163/IRPasscode.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/irons163/IRPasscode.git", :tag => spec.version.to_s }
  spec.source_files  = "IRPasscode/**/*.{h,m}"
  spec.resources = ["IRPasscode/**/*.xib", "IRPasscode/**/*.xcassets"]
  spec.resource_bundles = {
    'IRPasscodeBundle' => ["IRPasscode/**/IRDataPickerBundle/**/*"]
  }
end
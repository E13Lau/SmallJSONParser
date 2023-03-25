Pod::Spec.new do |s|
  s.name         = "SmallJSONParser"
  s.version      = "0.0.4"
  s.summary      = "A short description of SmallJSONParser."
  s.homepage     = "https://github.com/chn-lyzhi/SmallJSONParser"
  s.license      = "MIT"
  s.author       = { "J.Lau" => "commandzi@foxmail.com" }
  s.ios.deployment_target = "13.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "4.0"
  s.tvos.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/chn-lyzhi/SmallJSONParser.git", :tag => "0.0.4" }
  s.source_files  = "Source/*.swift"
  s.requires_arc = true
  s.swift_version = '5'
end

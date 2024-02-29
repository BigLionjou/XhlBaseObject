Pod::Spec.new do |s|

  s.name         = "XhlBaseObject"
  s.version      = '0.0.01'
  s.summary      = "新华龙初始化全局变量组件"
  s.description  = <<-DESC
                    关于新华龙初始化全局变量组件 公开发行版本
                   DESC

  s.homepage     = "http://www.newchongqing.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Rogue" => "xx408358831@qq.com" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source           = { :git => 'https://github.com/BigLionjou/XhlBaseObject.git', :tag => s.version.to_s }

  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

  s.source_files  = "XhlBaseObject/**/*"
  s.public_header_files = "XhlBaseObject/**/*.h"
  

end

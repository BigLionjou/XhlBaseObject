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


  s.source_files  = "XhlBaseObject/*"
  s.public_header_files = "XhlBaseObject/*.h"
  

  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

  s.default_subspec = 'source'

# 源码
	s.subspec 'source' do |a|
	  a.subspec 'XHlFoundation' do |ss|
	    ss.source_files = 'XhlBaseObject/XHlFoundation/*'
	    ss.public_header_files = 'XhlBaseObject/XHlFoundation/*.h'
		
		ss.subspec 'Categoryies' do |sss|
		    sss.source_files = 'XhlBaseObject/XHlFoundation/Categoryies/*'
		    sss.public_header_files = 'XhlBaseObject/XHlFoundation/Categoryies/*.h'

		    sss.subspec 'XHLRunTime' do |ssss|
		    	ssss.source_files = 'XhlBaseObject/XHlFoundation/Categoryies/XHLRunTime/*'
		   		ssss.public_header_files = 'XhlBaseObject/source/XHlFoundation/Categoryies/XHLRunTime*.h'
		    end
		end
		ss.subspec 'otherTool' do |sss|
		    sss.source_files = 'XhlBaseObject/XHlFoundation/otherTool/*'
		    sss.public_header_files = 'XhlBaseObject/XHlFoundation/otherTool/*.h'
		    sss.dependency "XhlBaseObject/source/XHlFoundation/Categoryies"
		end
	  end

	  a.subspec 'XHLUIKit' do |ss|
	    ss.source_files = 'XhlBaseObject/XHLUIKit/*'
	    ss.public_header_files = 'XhlBaseObject/source/XHLUIKit/*.h'

	    ss.subspec 'Categoryies' do |sss|
		    sss.source_files = 'XhlBaseObject/XHLUIKit/Categoryies/*'
		    sss.public_header_files = 'XhlBaseObject/XHLUIKit/Categoryies/*.h'
		    sss.dependency "XhlBaseObject/source/XHlFoundation/Categoryies"	    
		end
		 
		ss.subspec 'ToolUI' do |sss|
		    sss.source_files = 'XhlBaseObject/XHLUIKit/ToolUI/*'
		    sss.public_header_files = 'XhlBaseObject/XHLUIKit/ToolUI/*.h'
		    sss.dependency "XhlBaseObject/source/XHLUIKit/Categoryies"
		end
		
		ss.subspec 'CocoaUIStyle' do |sss|
		    sss.source_files = 'XhlBaseObject/XHLUIKit/CocoaUIStyle/*'
		    sss.public_header_files = 'XhlBaseObject/XHLUIKit/CocoaUIStyle/*.h'
		end
	  end
	end


end

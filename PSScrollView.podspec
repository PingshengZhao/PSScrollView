

Pod::Spec.new do |s|
  s.name         = "PSScrollView"
  s.version      = "0.0.1"
  s.summary      = "PSScrollView."
  s.description  = <<-DESC
  					私有PSScrollView
                   DESC

  s.homepage     = "https://github.com/PingshengZhao/PSScrollView.git"

  s.license      = "MIT"

  s.author             = { "zhaopingsheng" => "18610303170@163.com" }

  s.platform     = :ios, "7.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/PingshengZhao/PSScrollView.git"}

  s.source_files  = "PSScrollView", "PSScrollView/**/*.{h,m}"

  s.framework  = "UIKit"
  s.module_name = 'PSScrollView'

  s.dependency "SDWebImage", "~> 3.7.3"

end

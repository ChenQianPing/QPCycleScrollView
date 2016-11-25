Pod::Spec.new do |s|

  s.name         = "QPCycleScrollView"
  s.version      = "1.0.1"
  s.summary      = "CycleScrollView for Swift."
  s.description  = <<-DESC
  It is a CycleScrollView used on iOS, which implement by Swift.
                   DESC
  s.homepage     = "https://github.com/ChenQianPing/QPCycleScrollView"
  s.license      = "MIT"
  s.author             = { "QianPing Chen" => "pingkeke@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ChenQianPing/QPCycleScrollView.git", :tag => s.version.to_s }
  s.source_files  = "QPCycleScrollView/*.swift"
  s.framework  = "UIKit"
  s.module_name = 'QPCycleScrollView'

end

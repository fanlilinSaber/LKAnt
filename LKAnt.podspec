Pod::Spec.new do |s|
  s.name = 'LKAnt'
  s.version = '1.0.1'
  s.summary = '启动项维护方式可插拔，启动项之间、业务模块之间不耦合，且一次实现可在多端复用'
  s.homepage = 'https://github.com/fanlilinSaber/LKAnt'
  s.license = { type: 'MIT', file: 'LICENSE' }
  s.authors = { 'Fan Li Lin' => '824589131.com' }
  s.platform = :ios, '9.0'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.source = { :git => 'https://github.com/fanlilinSaber/LKAnt.git', :tag => 'v#{s.version}' }
  s.source_files = 'LKAnt/*.{h,m}'
  s.static_framework = true
end

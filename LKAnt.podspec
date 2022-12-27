Pod::Spec.new do |spec|
  spec.name = 'LKAnt'
  spec.version = '1.0.1'
  spec.summary = '启动项维护方式可插拔，启动项之间、业务模块之间不耦合，且一次实现可在多端复用'
  spec.homepage = 'https://github.com/fanlilinSaber/LKAnt'
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { 'Fan Li Lin' => '824589131.com' }
  spec.platform = :ios, '9.0'
  spec.frameworks = 'Foundation', 'UIKit'
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/fanlilinSaber/LKAnt.git', :tag => 'v#{s.version}' }
  spec.source_files = 'LKAnt/*.{h,m}'
  spec.static_framework = true
end

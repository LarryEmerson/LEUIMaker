Pod::Spec.new do |s|
  s.name             = 'LEUIMaker'
  s.version          = '0.1.0'
  s.summary          = 'LEUIFramework与LEUIFrameworkExtra的融合与升级，使用更简单、功能更强大。不喜欢使用约束，Masonry也觉得复杂，那么LEUIMaker可以成为替代方案。LEUIMakerUI开发神器的宗旨是简洁、轻便、智能，虽不能实现约束的所有功能，但是98%的UI开发模块，LEUIMaker已完全能够满足。'
  s.homepage         = 'https://github.com/LarryEmerson/LEUIMaker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LarryEmerson' => 'larryemerson@163.com' }
  s.source           = { :git => 'https://github.com/LarryEmerson/LEUIMaker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'LEUIMaker/Classes/*.{h,m}'
  s.dependency 'LEFoundation'
end

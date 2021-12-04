#
# Be sure to run `pod lib lint KTDecimal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KTDecimal'
  s.version          = '1.0.0'
  s.summary          = 'Make NSDecimalNumber easy to use!'

  s.description      = 'Make NSDecimalNumber easy to use!'
  s.homepage         = 'https://github.com/yjling2019/KTDecimal'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KOTU' => 'yjling2019@gmail.com' }
  s.source           = { :git => 'https://github.com/yjling2019/KTDecimal.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'KTDecimal/Classes/**/*'
    
end

Pod::Spec.new do |s|
  s.name             = 'URN'
  s.version          = '0.1.3'
  s.summary          = 'A URN type'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
  A URN type.
                       DESC

  s.homepage         = 'https://github.com/anconaesselmann/URN'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'anconaesselmann' => 'axel@anconaesselmann.com' }
  s.source           = { :git => 'https://github.com/anconaesselmann/URN.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'URN/Classes/**/*'
  s.dependency 'ValueTypeRepresentable'
end

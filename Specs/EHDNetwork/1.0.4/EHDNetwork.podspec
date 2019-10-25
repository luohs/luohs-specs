#
# Be sure to run `pod lib lint EHDNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EHDNetwork'
  s.version          = '1.0.4'
  s.summary          = 'A short description of EHDNetwork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luohs/EHDNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luohs' => 'luohuasheng0225@gmail.com' }
  s.source           = { :svn => 'https://10.7.12.91/repo/EHDiOS/trunk/EHDComponentRepo/EHDNetwork', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  # s.source_files = 'EHDNetwork/Classes/**/*.{m,mm,h}'

  httpdns = { :spec_name => "HttpDNS", :dependency => "EHDHttpDNS" }
  crypt = { :spec_name => "crypt", :dependency => "EHDCryptCipherService" }
  all_enables = [httpdns,crypt]

  s.subspec "Core" do |ss|
    ss.source_files = ['EHDNetwork/Classes/*.h', 'EHDNetwork/Classes/Network/protocol/**/*.{m,mm,h}', 'EHDNetwork/Classes/Network/proxy/**/*.{m,mm,h}', 'EHDNetwork/Classes/Network/request/**/*.{m,mm,h}']
    ss.resource_bundles = {
      'EHDNetwork' => ['EHDNetwork/Assets/**/*.{en,cer,p12}']
    }
    ss.ios.dependency 'AFNetworking/NSURLSession'
    ss.ios.dependency 'AFNetworking/Security'
    ss.ios.dependency 'AFNetworking/Serialization'
  end

  s.subspec "TFSupport" do |ss|
    ss.source_files = ['EHDNetwork/Classes/Network/response/**/*.{m,mm,h}']
    ss.dependency 'EHDNetwork/Core'
    ss.ios.dependency 'MJExtension'
    #ss.prefix_header_contents = "#define NET_TFSUPPORT_ENABLE 1" //只能本组件生效，组件之外则无法生效
    ss.xcconfig = {
        "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) NET_TFSUPPORT_ENABLE=1'
    }
  end

  all_enables.each do |enable_spec|
    s.subspec enable_spec[:spec_name] do |ss|
      if enable_spec[:ios_deployment_target]
        ss.ios.deployment_target = enable_spec[:ios_deployment_target]
      end
      providername = enable_spec[:provider]? enable_spec[:provider] : enable_spec[:spec_name]
      # Each subspec adds a compiler flag saying that the spec was included
      ss.prefix_header_contents = "#define NET_#{providername.upcase}_ENABLE 1"
      ss.ios.dependency 'EHDNetwork/Core'
      # If there's a podspec dependency include it
      Array(enable_spec[:dependency]).each do |dep|
          ss.dependency *dep
      end
    end
  end

  # s.resource_bundles = {
  #   'EHDNetwork' => ['EHDNetwork/Assets/**/*.{en,cer,p12}']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.ios.dependency 'AFNetworking/NSURLSession'
  # s.ios.dependency 'AFNetworking/Security'
  # s.ios.dependency 'AFNetworking/Serialization'
  # s.ios.dependency 'SAMKeychain'
end

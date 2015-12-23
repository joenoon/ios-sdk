Pod::Spec.new do |s|

  s.name                      = "YesGraph-iOS-SDK"
  s.version                   = "0.9.6"
  s.summary                   = "Official YesGraph SDK for iOS to access YesGraph API and integrate YesGraph Invite Flow"

  s.description               = <<-DESC
                                The YesGraph SDK for iOS allows you to use YesGraph Platform to:
                                - Invite users using YesGraph invite flow.
                                - Display suggestions based on user's previous choices.
                                - Use stylable sharing sheet for common social services.
                                DESC

  s.homepage                  = "https://docs.yesgraph.com"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = 'YesGraph'

  s.documentation_url         = "https://docs.yesgraph.com/docs/ios-sdk"
  s.social_media_url          = "https://twitter.com/yesgraph"
  s.platform                  = :ios, "9.0"

  s.ios.deployment_target     = '8.0'
  s.requires_arc              = true

  s.source                    = { :git => "https://github.com/yesgraph/ios-sdk.git", :tag => "#{s.version}" }

  s.source_files              = "YesGraph/YesGraphSDK/YesGraphSDK/**/*.{h,m}"
  #s.public_header_files       = "YesGraph/YesGraphSDK/YesGraphSDK/**/*.{h,m}"
  #s.header_dir                = "YesGraph/YesGraphSDK/YesGraphSDK/**/*.{h,m}"

end

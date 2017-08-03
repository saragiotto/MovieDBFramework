Pod::Spec.new do |s|
  s.name         = "TMDbFramework"
  s.version      = "0.0.1"
  s.summary      = "A short description of TMDbFramework."
  s.description  = <<-DESC
        Pod framework for fetch movie information from TMDb https://www.themoviedb.org
                   DESC

  s.homepage     = "http://EXAMPLE/TMDbFramework"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Leonardo Saragiotto" => "leonardo.saragiotto@gmail.com" }
  # s.social_media_url   = "http://twitter.com/"

  s.platform = :ios, "10.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source  = { :git => "https://github.com/saragiotto/MovieDBFramework.git", :branch => "master" }

  s.source_files  = "TMDbFramework/Classes", "Classes/**/*.{swift}"
  s.exclude_files = "TMDbFramework/Classes/Exclude"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.dependency "Alamofire", "~> 4.3"
  s.dependency "SwiftyJSON"
  s.dependency "ChameleonFramework"
end

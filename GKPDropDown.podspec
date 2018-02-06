
Pod::Spec.new do |s|

  s.name         = "GKPDropDown"
  s.version      = "1.0.1"
  s.summary      = "Simple dropdown framework."
  s.description  = "A simple dropdown component framework."
  s.homepage     = "https://github.com/devgokhan/GKPDropDown"
  s.license      = "MIT"
  s.author             = { "Gokhan Alp" => "dev.gokhan@hotmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/devgokhan/GKPDropDown.git", :tag => "#{s.version}" }
  s.source_files  = "GKPDropDown"

end

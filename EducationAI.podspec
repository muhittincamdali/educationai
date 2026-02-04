Pod::Spec.new do |s|
  s.name             = 'EducationAI'
  s.version          = '1.0.0'
  s.summary          = 'AI-powered education platform for personalized learning.'
  s.description      = <<-DESC
    EducationAI provides an AI-powered education platform for iOS. Features include
    personalized learning paths, adaptive assessments, progress tracking, content
    recommendations, and machine learning-based tutoring assistance.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/educationai'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/educationai.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'SwiftUI', 'CoreML'
end

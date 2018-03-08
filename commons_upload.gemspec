lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'commons_upload/version'

Gem::Specification.new do |spec|
  spec.name          = 'commons_upload'
  spec.version       = CommonsUpload::VERSION
  spec.authors       = ['Vikas Yaligar', 'Željko Filipin', 'Amir E. Aharoni']
  spec.email         = ['amir.aharoni@mail.huji.ac.il']
  spec.description   = 'Upload images to Wikimedia Commons. '\
    'This is intended for uploading auto-translated screenshots for MediaWiki documentation.'
  spec.summary       = 'Upload images to Wikimedia Commons.'
  spec.homepage      = 'https://github.com/amire80/commons_upload'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '~> 2.0'

  spec.add_runtime_dependency 'mediawiki_api', '~> 0.7.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sumdown/version'

Gem::Specification.new do |spec|
  spec.name          = "sumdown"
  spec.version       = Sumdown::VERSION
  spec.authors       = ["jjy"]
  spec.email         = ["jjyruby@gmail.com"]
  spec.description   = %q{Yet another simple & light weight pure ruby markdown parser}
  spec.summary       = %q{sumdown mean [s]how yo[u] [m]ark[down]}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.6.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end

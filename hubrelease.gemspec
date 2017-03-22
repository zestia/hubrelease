lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hubrelease/version'

Gem::Specification.new do |spec|
  spec.name          = "hubrelease"
  spec.version       = HubRelease::VERSION
  spec.authors       = ["Tom Bell"]
  spec.email         = ["tomb@tomb.io"]

  spec.summary       = %q{Generate a new release on GitHub.}
  spec.description   = %q{Generate a new release on GitHub containing closed issues and pull requests.}
  spec.homepage      = "https://github.com/zestia/hubrelease"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit", "~> 4.2"
  spec.add_dependency "mime-types", "~> 3.1"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end

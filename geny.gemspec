lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "geny/version"

Gem::Specification.new do |spec|
  spec.name          = "geny"
  spec.version       = Geny::VERSION
  spec.authors       = ["Ray Zane"]
  spec.email         = ["raymondzane@gmail.com"]

  spec.summary       = %q{The only tool you need to build a code generator.}
  spec.homepage      = "https://github.com/rzane/geny"
  spec.license       = "MIT"

  spec.metadata["source_code_uri"] = "https://github.com/rzane/geny"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/github/rzane/geny"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "argy", "~> 0.2.2"
  spec.add_dependency "pastel", "~> 0.7.3"
  spec.add_dependency "tty-file", "~> 0.8.0"
  spec.add_dependency "tty-prompt", "~> 0.21.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.18.5"
  spec.add_development_dependency "file_spec", "~> 0.1.0"
end

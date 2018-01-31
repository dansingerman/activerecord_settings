
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activerecord_settings/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord_settings"
  spec.version       = ActiverecordSettings::VERSION
  spec.authors       = ["Dan Singerman"]
  spec.email         = ["dan@reasonfactory.com"]

  spec.summary       = "A simple active record based key value store"
  spec.description   = "Store settings in your relational database as a simple key value store. Can be used as a low performance cache if you want to store some things, and either want them reliably persisted past a cache server restart, or you just don't want a full cache."
  spec.homepage      = "https://github.com/dansingerman/activerecord_settings"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", [">= 4.0", "< 5.2"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_development_dependency "generator_spec", "~> 0"
  spec.add_development_dependency "timecop", "~> 0.9"
end

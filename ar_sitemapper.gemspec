# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "sitemapper/version"

Gem::Specification.new do |spec|
  spec.name          = "ar_sitemapper"
  spec.version       = AegisNet::Sitemapper::VERSION
  spec.authors       = ["Carsten Zimmermann"]
  spec.email         = ["cz@aegisnet.de"]
  spec.description   = %q{Faciliates generating static sitemap XML files from ActiveRecord}
  spec.summary       = %q{Faciliates generating static sitemap XML files from ActiveRecord}
  spec.homepage      = ""
  spec.license       = "BSD 3-Clause"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 3.0', '< 5.0'

  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rails', '>= 3.0', '< 5.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end

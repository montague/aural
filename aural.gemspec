# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "aural/version"

Gem::Specification.new do |s|
  s.name        = "aural"
  s.version     = Aural::VERSION
  s.authors     = ["ian asaff"]
  s.email       = ["ian.asaff@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{flv to music}
  s.description = %q{flv to music}

  s.rubyforge_project = "aural"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "mechanize"
end

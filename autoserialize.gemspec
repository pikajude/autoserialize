# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autoserialize/version"

Gem::Specification.new do |s|
  s.name        = "autoserialize"
  s.version     = Autoserialize::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Trae Robrock"]
  s.email       = ["trobrock@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Autoserialize AR attributes, dont use this. It's old}
  s.description = %q{Autoserialize AR attributes, dont use this. It's old}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", ">= 4.0.0.beta1"
end

$:.push File.expand_path("../lib", __FILE__)
require 'facility/version'

Gem::Specification.new do |s|
  s.name = 'facility'
  s.version = Facility::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = '2011-12-14'
  s.authors = ['Derek Kastner']
  s.email = 'dkastner@gmail.com'
  s.homepage = 'http://github.com/dkastner/facility'
  s.summary = %Q{Brighter Planet's impact model for facilities}
  s.description = %Q{Calculates the environmental impact of a facility}
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'earth',     '~>0.11.0'
  s.add_runtime_dependency 'emitter',   '~>0.11.0'
  s.add_development_dependency 'sniff', '~>0.11.3'
end


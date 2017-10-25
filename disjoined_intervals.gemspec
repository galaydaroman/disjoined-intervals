$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'disjoined_intervals/version'

Gem::Specification.new do |s|
  s.name        = 'disjoined_intervals'
  s.version     = DisjoinedIntervals::VERSION
  s.authors     = ['Roman Halaida']
  s.email       = ['galayda.roman@gmail.com']
  s.homepage    = ''
  s.summary     = 'Disjoined intervals solution'
  s.description = 'Disjoined intervals solution'
  s.files       = `git ls-files`.split("\n")
  s.test_files  = s.files.grep %r{^(test/spec)/}

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rubocop'
end

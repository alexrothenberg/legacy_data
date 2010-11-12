Gem::Specification.new do |s|
  s.name              = 'legacy_data'
  s.version           = File.read(File.expand_path('../VERSION', __FILE__)).strip
  s.authors           = ["Alex Rothenberg"]
  s.description       = 'Create ActiveRecord models from an existing database'
  s.summary           = 'Create ActiveRecord models from an existing database'
  s.email             = 'alex@alexrothenberg.com'
  s.homepage          = 'http://github.com/alexrothenberg/legacy_data'
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_path      = 'lib'
  s.rubygems_version  = '1.3.7'
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec,features,examples/generated}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files  = ["LICENSE", "README.md", "History.txt"]
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_path      = "lib"

  s.add_dependency             'activerecord',  '~> 2.3.5'
  s.add_dependency             'foreigner',     '~> 0.9.1'

  s.add_development_dependency 'rake',          '~> 0.8.7'
  s.add_development_dependency 'rspec',         '~> 1.3.1'
  s.add_development_dependency 'jeweler',       '~> 1.4.0'
  s.add_development_dependency 'sqlite3-ruby',  '~> 1.3.1'
  s.add_development_dependency 'rails',         '~> 2.3.5'
end

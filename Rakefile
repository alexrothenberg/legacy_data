require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "legacy_data"
    gem.summary = %Q{Create ActiveRecord models from an existing database}
    gem.description = %Q{Create ActiveRecord models from an existing database}
    gem.email = "alex@alexrothenberg.com"
    gem.homepage = "http://github.com/alexrothenberg/legacy_data"
    gem.authors = ["Alex Rothenberg"]
    gem.add_development_dependency "rspec"
    gem.add_dependency('activerecord')
    gem.add_dependency('matthuhiggins-foreigner', '>= 0.2.1')
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

def run_without_aborting(*tasks)
  errors = []

  tasks.each do |task|
    begin
      puts "Running #{task} specs"
      Rake::Task[task].invoke
      puts ''
    rescue Exception
      errors << task
    end
  end

  abort "Errors running #{errors.join(', ')}" if errors.any?
end

for adapter in %w( mysql postgresql sqlite sqlite3 firebird db2 oracle sybase openbase frontbase jdbcmysql jdbcpostgresql jdbcsqlite3 jdbcderby jdbch2 jdbchsqldb )
  Spec::Rake::SpecTask.new("spec_#{adapter}") do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList["spec/**/*_#{adapter}spec.rb"]
  end

  namespace adapter do
    task :spec => "spec_#{adapter}" 
  end
end

desc 'Run unit, mysql, sqlite, and oracle tests'
task :spec_all do
  tasks = %w(spec spec_mysql spec_sqlite3 spec_oracle)
  run_without_aborting(*tasks)
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude spec,gems', '--sort coverage']
end

task :spec => :check_dependencies

task :default => :spec_all

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "legacy_data #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

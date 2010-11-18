require 'rubygems'
require 'bundler'
require 'rake/gempackagetask'

begin
  Bundler.setup(:default, :development)
  Bundler::GemHelper.install_tasks
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

task :default => :spec_all
task :spec => :check_dependencies


# GEM Tasks --------------------------------------------------------
spec = eval(File.read('legacy_data.gemspec'))
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
#           --------------------------------------------------------

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

def print_msg msg
  border = '-'*(msg.size+10)
  puts border, "---  #{msg}  ---", border
end

def run_functional_without_aborting(*adapters)
  errors = []

  adapters.each do |adapter|
    if ENV[adapter.upcase] || (adapter == 'sqlite3')
      begin
        print_msg "Running #{adapter.upcase} specs"
        ENV['ADAPTER'] = adapter
        Rake::Task["#{adapter}:spec"].invoke
        puts ''
      rescue Exception
        errors << "#{adapter}:spec"
      end
    else
      print_msg "Skipping #{adapter.upcase} specs because the environment variable '#{adapter.upcase}' is not set"
      puts
    end
  end

  abort "Errors running #{errors.join(', ')}" if errors.any?
end

def adapters
  %w( mysql sqlite3 oracle)
end

for adapter in adapters
  namespace adapter do
    Spec::Rake::SpecTask.new(:spec) do |spec|
      spec.libs << 'lib' << 'spec'
      spec.spec_files = FileList["spec/**/*_adapterspec.rb"]
    end
  end
end

desc 'Run unit + adapter specific specs (mysql, sqlite, and oracle)'
task :spec_all => :spec do
  run_functional_without_aborting(*adapters)
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude spec,gems', '--sort coverage']
end


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

source 'http://rubygems.org'
gemspec :path => '.'

group :development do
  if ENV['MYSQL']
    gem 'mysql',                                '~> 2.8.1'
  end
  if ENV['ORACLE']
    gem "activerecord-oracle_enhanced-adapter", '~> 1.3.0'
    gem 'ruby-oci8',                            '~> 2.0.4'
  end

  gem 'rspec-rails', :git => 'https://github.com/alexrothenberg/rspec-rails.git', :branch => 'generator_example_group'
end
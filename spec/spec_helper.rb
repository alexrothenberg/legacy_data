require 'rubygems'
# gem 'rspec'
# require 'spec'
# require 'spec/autorun'

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'active_record'
# Since Legacy Data depends on Foreigner we need to have an ActiveRecord connection established
ActiveRecord::Base.establish_connection({:adapter=>'sqlite3', :database=> ":memory:"})


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'legacy_data'

# require 'spec'
# require 'spec/autorun'

### Load the rails generator code
# require 'rails_generator'
# require 'rails_generator/scripts'
# require 'rails_generator/scripts/generate'

require 'active_support'
require 'rails/all'
require 'rails/generators'
require 'rspec/rails'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
gem 'activerecord'
gem 'activerecord-oracle_enhanced-adapter'
require 'activerecord'
require 'active_record/connection_adapters/oracle_enhanced_adapter'

require 'legacy_data'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

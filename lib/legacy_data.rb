require 'foreigner' #matthuhiggens-foreigner

require 'legacy_data/table_definition'
require 'legacy_data/schema'
require 'legacy_data/table_class_name_mapper'

module ActiveRecord  
  Base.class_eval do
    if ['OracleEnhanced'].include? connection.adapter_name
      # require "#{File.dirname(__FILE__)}/active_record/connection_adapters/#{connection.adapter_name.underscore}_adapter"
      require "#{File.dirname(__FILE__)}/active_record/connection_adapters/#{connection.adapter_name.downcase}_adapter"
    end
  end
end


require 'foreigner' #matthuhiggens-foreigner

require 'legacy_data/table_definition'
require 'legacy_data/schema'
require 'legacy_data/table_class_name_mapper'

Foreigner.register 'oracle_enhanced', 'foreigner/connection_adapters/oracle_enhanced_adapter'

module LegacyData
  # In Rails 2.3 this was ActiveRecord::Base.class_name but it no longer exists in Rails 3
  def self.conventional_class_name table_name
    table_name.underscore.downcase.pluralize.camelize.singularize
  end
end

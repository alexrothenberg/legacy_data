class <%= class_name -%> < ActiveRecord::Base
  <%= "set_table_name  #{table_name.downcase.to_sym.inspect}" unless table_name == class_name.underscore.pluralize %>
  <%= "set_primary_key #{primary_key.to_sym.inspect}" if primary_key && primary_key != 'id' %>
  
  # Relationships
  <%= model.relationships_to_s %>

  # Constraints
  <%= model.constraints_to_s %>
end


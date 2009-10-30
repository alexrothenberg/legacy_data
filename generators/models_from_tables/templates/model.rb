class <%= definition.class_name -%> < ActiveRecord::Base
<%= "  set_table_name  #{definition.table_name.downcase.to_sym.inspect}\n" if definition.unconventional_table_name?  -%>
<%= "  set_primary_key #{definition.primary_key.to_sym.inspect}\n"         if definition.unconventional_primary_key? -%>

  # Relationships
  <%= definition.relationships_to_s %>

  # Constraints
  <%= definition.constraints_to_s   %>
end


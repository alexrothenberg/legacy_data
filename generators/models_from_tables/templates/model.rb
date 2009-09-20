class <%= class_name -%> < ActiveRecord::Base
  set_table_name :<%= table_name %>
  <%= "set_primary_key #{primary_key.inspect}" if primary_key %>
  
  # Relationships
  <%- relations[:has_some].each do |table_name, foreign_key| 
  -%>  has_many   <%= LegacyData::TableClassNameMapper.class_name_for(table_name).underscore.pluralize.to_sym.inspect %>, :foreign_key => <%= foreign_key.inspect %>
  <%- end -%>
  <%- relations[:belongs_to].each do |table_name, foreign_key| 
  -%>  belongs_to <%= LegacyData::TableClassNameMapper.class_name_for(table_name).underscore.to_sym.inspect %>, :foreign_key => <%= foreign_key.inspect %>
  <%- end -%>

  # Constraints
  <%= "validates_uniqueness_of #{constraints[:unique    ].map {|cols| cols.first.downcase.to_sym.inspect}.join(', ')}" unless constraints[:unique].blank? %>
  <%- constraints[:multi_column_unique].each do |cols| 
  -%>  #validates_uniqueness_of_multiple_column_constraint :<%= cols.inspect %>
  <%- end -%>
  <%= "validates_presence_of #{constraints[:non_nullable].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:non_nullable].blank? %>
  <%- constraints[:custom].each do |name, sql_rule| 
  -%>  validate <%= "validate_#{name}".to_sym.inspect %>
  def <%= "validate_#{name}" %>
    # TODO: validate this SQL constraint 
    "<%= sql_rule %>"
  end
  <%- end %>
end

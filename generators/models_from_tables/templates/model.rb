class <%= class_name -%> < ActiveRecord::Base
  set_table_name <%= table_name.to_sym.inspect %>
  <%= "set_primary_key #{primary_key.to_sym.inspect}" if primary_key %>
  
  # Relationships
  <%- [:has_many, :has_one, :belongs_to, :has_and_belongs_to_many].each do |relation_type|
        relations[relation_type].each do |table_name, options| 
          class_for_table = LegacyData::TableClassNameMapper.class_name_for(table_name)
          is_singular_association = [:has_one, :belongs_to].include?(relation_type)
          association_name = class_for_table.underscore
          association_name = association_name.pluralize unless is_singular_association
          needs_class_name = (ActiveRecord::Base.class_name(association_name.pluralize) != class_for_table)
        -%>  <%= relation_type %> <%= association_name.to_sym.inspect %>, <%=options.keys.map {|key| "#{key.to_sym.inspect} => #{options[key].to_sym.inspect}"}.join(', ')%><%= ", :class_name=>'#{class_for_table}'" if needs_class_name %>
  <%-   end unless relations[relation_type].nil?
      end 
  -%>

  # Constraints
  <%= "validates_uniqueness_of #{constraints[:unique    ].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:unique].blank? %>
  <%- constraints[:multi_column_unique].each do |cols| 
  -%>  #validates_uniqueness_of_multiple_column_constraint :<%= cols.inspect %>
  <%- end -%>
  <%= "validates_presence_of #{constraints[:presence_of].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:presence_of].blank? %>
  <%- constraints[:boolean_presence].each do |col| 
      -%>  validates_inclusion_of    <%= col %>,       :in => %w(true false)
  <%- end -%>
  <%= "validates_numericality_of #{constraints[:numericality_of].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:numericality_of].blank? %>
  <%- constraints[:custom].each do |name, sql_rule| 
  -%>  validate <%= "validate_#{name}".to_sym.inspect %>
  def <%= "validate_#{name}" %>
    # TODO: validate this SQL constraint 
    "<%= sql_rule %>"
  end
  <%- end %>
end


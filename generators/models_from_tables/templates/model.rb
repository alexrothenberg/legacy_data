class <%= class_name -%> < ActiveRecord::Base
  set_table_name <%= table_name.to_sym.inspect %>
  <%= "set_primary_key #{primary_key.to_sym.inspect}" if primary_key %>
  
  # Relationships
  <%- [:has_many, :has_one, :belongs_to, :has_and_belongs_to_many].each do |relation_type|
        is_singular_association = [:has_one, :belongs_to].include?(relation_type)
        unless relations[relation_type].nil?
          association_names = relations[relation_type].keys.map do |assoc| 
            association_name = LegacyData::TableClassNameMapper.class_name_for(assoc).underscore
            association_name = association_name.pluralize unless is_singular_association
            association_name
          end
          association_with_longest_name = association_names.max { |a,b| a.length <=> b.length }
          relations[relation_type].each do |table_name, options| 
            class_for_table = LegacyData::TableClassNameMapper.class_name_for(table_name)
            association_name = class_for_table.underscore
            association_name = association_name.pluralize unless is_singular_association
            needs_class_name = (ActiveRecord::Base.class_name(association_name.pluralize) != class_for_table)
            spaces = association_with_longest_name.size - association_name.size
            -%>  <%= relation_type %> <%= association_name.to_sym.inspect %>,<%=' ' * spaces%> <%=options.keys.map {|key| "#{key.to_sym.inspect} => #{options[key].to_sym.inspect}"}.join(', ')%><%= ", :class_name=>'#{class_for_table}'" if needs_class_name %>
  <%-     end
        end
      end 
  -%>

  # Constraints
  <%= "validates_uniqueness_of #{constraints[:unique    ].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:unique].blank? %>
  <%- constraints[:multi_column_unique].each do |cols| 
  -%>  #validates_uniqueness_of_multiple_column_constraint :<%= cols.inspect %>
  <%- end -%>
  <%= "validates_presence_of #{constraints[:presence_of].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:presence_of].blank? %>
  <%- constraints[:inclusion_of].each do |col, possible_values| 
      -%>  def self.possible_values_for_<%= col %>
    [ <%= possible_values %> ]
  end
  validates_inclusion_of <%= col.to_sym.inspect %>,
                         :in      => possible_values_for_<%= col %>, 
                         :message => "is not one of (#{possible_values_for_<%= col %>.join(', ')})"
  <%- end if constraints[:inclusion_of] -%>
  <%- [:allow_nil, :do_not_allow_nil].each do |nullable| 
        unless constraints[:numericality_of][nullable].blank? 
    -%>  <%= "validates_numericality_of #{constraints[:numericality_of][nullable].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" %><%= ", {:allow_nil=>true}" if nullable == :allow_nil %>
  <%-   end
      end unless constraints[:numericality_of].blank? -%>
  <%- constraints[:custom].each do |name, sql_rule| 
  -%>  validate <%= "validate_#{name}".to_sym.inspect %>
  def <%= "validate_#{name}" %>
    # TODO: validate this SQL constraint 
    <<-SQL
    <%= sql_rule %>
    SQL
  end
  <%- end if constraints[:custom] -%>
end


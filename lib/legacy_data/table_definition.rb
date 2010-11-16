module LegacyData
  class TableDefinition
    attr_accessor :class_name, :table_name, :columns, :primary_key, :relations, :constraints

    def initialize(options)
      options.each {|key, value| self.send("#{key}=", value) }
    end
    
    def [] key
      self.send(key)
    end
    
    def unconventional_table_name?
      table_name != class_name.underscore.pluralize
    end

    def unconventional_primary_key?
      primary_key != 'id'
    end

    def relationships_to_s
      relationships_text = []
      [:has_many, :has_one, :belongs_to, :has_and_belongs_to_many].each do |relation_type|
        is_singular_association = [:has_one, :belongs_to].include?(relation_type)
        unless relations[relation_type].nil?
          association_with_longest_name = longest_association_name(relations[relation_type], is_singular_association)
          
          relations[relation_type].keys.sort.each do |table_name|
            options =  relations[relation_type][table_name]
            class_for_table = TableDefinition.class_name_for(table_name)
            association_name = class_for_table.underscore
            association_name = association_name.pluralize unless is_singular_association
            needs_class_name = (LegacyData.conventional_class_name(association_name) != class_for_table)
            options[:class_name] = class_for_table if needs_class_name

            spaces = association_with_longest_name.size - association_name.size
            relationships_text << "#{relation_type} #{association_name.to_sym.inspect},#{' ' * spaces} #{options_to_s(options)}"
          end
        end
      end
      relationships_text.join "\n  "
    end

    def class_name
      TableDefinition.class_name_for table_name
    end
    
    def self.class_name_for table_name
      LegacyData::TableClassNameMapper.class_name_for(table_name)
    end
    
    def longest_association_name(associations, is_singular_association)
      association_names = associations.keys.map do |assoc| 
        association_name = TableDefinition.class_name_for(assoc).underscore
        association_name = association_name.pluralize unless is_singular_association
        association_name
      end
      association_with_longest_name = association_names.max { |a,b| a.length <=> b.length }
    end

    def options_to_s options
      alphabetized_option_keys = options.keys.map(&:to_s).sort
      alphabetized_option_keys.map do |key|
        "#{key.to_sym.inspect} => #{options[key.to_sym].inspect}"
      end.join(', ')
    end
    
    def constraints_to_s
      alphabetized_constraints_types = constraints.keys.map(&:to_s).sort
      constraints_text = alphabetized_constraints_types.map do |constraint_type|
        self.send("#{constraint_type}_constraints_to_s") unless constraints[constraint_type.to_sym].blank?
      end
      constraints_text.flatten.reject(&:nil?).join("\n  ")
    end
    
    def unique_constraints_to_s
      cols_list = constraints[:unique].map {|cols| cols.downcase.to_sym.inspect}.join(', ')
      "validates_uniqueness_of #{cols_list}" 
    end

    def multi_column_unique_constraints_to_s
      constraints[:multi_column_unique].map do |cols| 
        "#validates_uniqueness_of_multiple_column_constraint #{cols.inspect}"
      end
    end

    def presence_of_constraints_to_s
      cols_list = constraints[:presence_of].map {|cols| cols.downcase.to_sym.inspect}.join(', ')
      "validates_presence_of #{cols_list}"
    end

    def inclusion_of_constraints_to_s
      constraints[:inclusion_of].keys.map do |col|
        <<-OUTPUT
  def self.possible_values_for_#{col}
    #{constraints[:inclusion_of][col].inspect}
  end
  validates_inclusion_of #{col.to_sym.inspect},
                         :in      => possible_values_for_#{col}, 
                         :message => "is not one of (\#{possible_values_for_#{col}.join(', ')})"
        OUTPUT
      end
    end

    def numericality_of_constraints_to_s
      [:allow_nil, :do_not_allow_nil].map do |nullable| 
        if constraints[:numericality_of][nullable].blank? 
          []
        else
          cols_list = constraints[:numericality_of][nullable].map {|cols| cols.downcase.to_sym.inspect}.join(', ')
          "validates_numericality_of #{cols_list}#{", {:allow_nil=>true}" if nullable == :allow_nil }"
        end
      end unless constraints[:numericality_of].blank? 
    end

    def custom_constraints_to_s
      constraints[:custom].keys.map do |name|
        <<-OUTPUT
  validate #{"validate_#{name}".to_sym.inspect }
  def validate_#{name}
    # TODO: validate this SQL constraint
    <<-SQL
      #{constraints[:custom][name]}
    SQL
  end
        OUTPUT
      end
    end
    
    def join_table?
      return false unless (columns.size == 2) and relations[:belongs_to] and (relations[:belongs_to].values.size == 2)
      column_names      = columns.map(&:name)
      foreign_key_names = relations[:belongs_to].values.map {|value| value[:foreign_key]}.map(&:to_s) 
      return column_names.sort == foreign_key_names.sort
    end
    
    def belongs_to_relations
      return {} if relations.nil? or relations[:belongs_to].nil?
      relations[:belongs_to]
    end

    def belongs_to_tables
      return [] if belongs_to_relations == {}
      belongs_to_relations.keys
    end
    
    def convert_has_many_to_habtm(join_table)
      other_table_name = join_table.belongs_to_tables.detect {|table_name| table_name != self.table_name}
      relations[:has_and_belongs_to_many][other_table_name] = { :foreign_key            =>join_table.belongs_to_relations[table_name][:foreign_key], 
                                                                :association_foreign_key=>join_table.belongs_to_relations[other_table_name][:foreign_key],
                                                                :join_table             =>join_table.table_name.to_sym }
      relations[:has_many].delete(join_table.table_name)                                                          
    end
  end
end
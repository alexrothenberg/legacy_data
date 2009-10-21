module LegacyData
  class TableDefinition
    attr_accessor :class_name, :table_name, :columns, :primary_key, :relations, :constraints

    def initialize(options)
      options.each {|key, value| self.send("#{key}=", value) }
    end
    
    def [] key
      self.send(key)
    end
    
    def to_hash
      hash = {:model => self }
      [:class_name, :table_name, :columns, :primary_key, :relations, :constraints].each {|field| hash[field] = self.send(field) }
      hash
    end

    def unconventional_table_name?
      table_name != class_name.underscore.pluralize
    end

    def unconventional_primary_key?
      puts self.inspect if primary_key.nil?
      primary_key != 'id'
    end

    def relationships_to_s
      s = []
      [:has_many, :has_one, :belongs_to, :has_and_belongs_to_many].each do |relation_type|
        is_singular_association = [:has_one, :belongs_to].include?(relation_type)
        unless relations[relation_type].nil?
          association_names = relations[relation_type].keys.map do |assoc| 
            association_name = LegacyData::TableClassNameMapper.class_name_for(assoc).underscore
            association_name = association_name.pluralize unless is_singular_association
            association_name
          end
          association_with_longest_name = association_names.max { |a,b| a.length <=> b.length }
          relations[relation_type].keys.sort.each do |table_name|
            options =  relations[relation_type][table_name]
            class_for_table = LegacyData::TableClassNameMapper.class_name_for(table_name)
            association_name = class_for_table.underscore
            association_name = association_name.pluralize unless is_singular_association
            needs_class_name = (ActiveRecord::Base.class_name(association_name.pluralize) != class_for_table)
            spaces = association_with_longest_name.size - association_name.size
            option_keys = options.keys.map(&:to_s).sort
            options[:class_name] = class_for_table if needs_class_name
            options_to_display = options.inspect
            options_to_display = options.inspect
            s << "#{relation_type} #{association_name.to_sym.inspect},#{' ' * spaces} #{option_keys.map {|key| "#{key.to_sym.inspect} => #{options[key.to_sym].to_sym.inspect}"}.join(', ')}#{", :class_name=>'#{class_for_table}'" if needs_class_name }"
          end
        end
      end
      s.join "\n  "
    end
    
    def constraints_to_s
      s = []
      s << "validates_uniqueness_of #{constraints[:unique    ].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:unique].blank?
      constraints[:multi_column_unique].each do |cols| 
        s << "#validates_uniqueness_of_multiple_column_constraint #{cols.inspect}"
      end
      s << "validates_presence_of #{constraints[:presence_of].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}" unless constraints[:presence_of].blank?
      constraints[:inclusion_of].each do |col, possible_values| 
        s << <<-OUTPUT
  def self.possible_values_for_#{col}
    [ #{possible_values} ]
  end
  validates_inclusion_of #{col.to_sym.inspect},
                         :in      => possible_values_for_#{col}, 
                         :message => "is not one of (\#{possible_values_for_#{col}.join(', ')})"
        OUTPUT
      end if constraints[:inclusion_of]
      [:allow_nil, :do_not_allow_nil].each do |nullable| 
        unless constraints[:numericality_of][nullable].blank? 
          s << "validates_numericality_of #{constraints[:numericality_of][nullable].map {|cols| cols.downcase.to_sym.inspect}.join(', ')}#{", {:allow_nil=>true}" if nullable == :allow_nil }"
        end
      end unless constraints[:numericality_of].blank? 
      constraints[:custom].each do |name, sql_rule| 
        s << <<-OUTPUT
  validate #{"validate_#{name}".to_sym.inspect }
  def validate_#{name}
    # TODO: validate this SQL constraint 
    <<-SQL
      sql_rule
    SQL
  end
        OUTPUT
      end if constraints[:custom]
      s.join "\n  "
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
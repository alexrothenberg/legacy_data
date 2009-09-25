module LegacyData
  class Schema
    attr_reader :table_name
    
    def self.analyze(options={})
      initialize_tables(options[:table_name])

      while table_name = next_table_to_process
        table_definitions[table_name] = analyze_table(table_name)

        [:has_many, :belongs_to].each do |relation_type| 
          associated_tables = table_definitions[table_name][:relations][relation_type].keys.map(&:to_s) 
          associated_tables.each {|associated_table| add_pending_table(associated_table) }
        end
      end

      remove_join_tables
    end
    def self.analyze_table table_name
      new(table_name).analyze_table
    end
    
    
    def self.initialize_tables(table_name)
      clear_table_definitions
      if table_name
        add_pending_table(table_name)
      else
        LegacyData::Schema.tables.each {|table| add_pending_table(table) }
      end
    end
    def self.add_pending_table table_name
      table_definitions[table_name] = :pending if table_definitions[table_name].nil?
    end
    def self.next_table_to_process
      table_definitions.keys.detect {|table_name| table_definitions[table_name] == :pending }
    end
    def self.clear_table_definitions
      @tables = {}
    end
    def self.table_definitions
      @tables ||= {}
    end
    def self.next_join_table
      table_definitions.keys.detect {|table_name| table_definitions[table_name].join_table? }
    end
    def self.remove_join_tables
      join_tables, other_tables = table_definitions.values.partition &:join_table?

      join_tables.each { |join_table| convert_to_habtm(join_table) }

      other_tables
    end
    def self.convert_to_habtm join_table
      join_table.belongs_to_tables.each do |table|
        table_definitions[table].convert_has_many_to_habtm(join_table)
      end
    end
    
    def initialize(table_name)
      @table_name = table_name
    end
    
    def analyze_table
      puts "analyzing #{table_name} => #{class_name}"
      TableDefinition.new(:table_name   => table_name,
                          :columns      => column_names,
                          :primary_key  => primary_key,
                          :relations    => relations,
                          :constraints  => constraints
                          )
    end
    
    def self.tables 
      connection.tables.sort
    end
    
    def class_name
      TableClassNameMapper.class_name_for(self.table_name)
    end

    def primary_key
      pk_and_sequence_for = connection.pk_and_sequence_for(table_name)
      pk_and_sequence_for.first if pk_and_sequence_for.respond_to? :first
    end

    def relations
      { :belongs_to               => belongs_to_relations,
        :has_many                 => has_some_relations,
        :has_and_belongs_to_many  => {}
      }
    end
    
    def belongs_to_relations
      return [] unless connection.respond_to? :foreign_keys_for
      
      belongs_to = {}
      connection.foreign_keys_for(table_name).each do |relation|
        belongs_to[relation.first.downcase] = {:foreign_key=>relation.second.downcase.to_sym}
      end
      belongs_to
    end
    def has_some_relations
      return [] unless connection.respond_to? :foreign_keys_of

      has_some = {}
      connection.foreign_keys_of(table_name).each do |relation|
        has_some[relation.delete(:to_table).downcase] = relation
      end
      has_some
    end

    def constraints
      unique, multi_column_unique = unique_constraints.partition {|columns| columns.size == 1}
      { :unique              => unique,
        :multi_column_unique => multi_column_unique,
        :non_nullable        => non_nullable_constraints,
        :custom              => custom_constraints
      }
    end
    
    def columns
      @columns ||= connection.columns(table_name, "#{table_name} Columns")
    end
    def column_names
      columns.map(&:name)
    end
    def non_nullable_constraints
      non_nullable_constraints = columns.reject(&:null).map(&:name)
      non_nullable_constraints.reject {|col| col == primary_key}
    end

    def unique_constraints
      connection.indexes(table_name).select(&:unique).map(&:columns)
    end
    
    def custom_constraints
      return [] unless connection.respond_to? :constraints
      user_constraints = {}
      connection.constraints(table_name).each do |constraint|
        user_constraints[constraint.first.underscore.to_sym] = constraint.second
      end
      user_constraints
    end    
    private
    def self.connection 
      @conn ||= ActiveRecord::Base.connection
    end
    def connection
      self.class.connection
    end


  end
end

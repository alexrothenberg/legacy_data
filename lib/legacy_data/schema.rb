module LegacyData
  class Schema
    attr_reader :table_name
    
    def self.analyze(options={})
      analyzed_schema = []

      @tables = {}
      if options[:table_name]
        @tables[options[:table_name]] = :pending
      else
        LegacyData::Schema.tables.each {|table| @tables[table] = :pending }
      end
      
      while table_name = next_table_to_process
        # puts "      Tables: #{@tables.inspect}"
        @tables[table_name] = analyze_table(table_name)

        [:has_some, :belongs_to].each do |relation_type| 
          associated_tables = @tables[table_name][:relations][relation_type].keys.map(&:to_s) 
          associated_tables.each {|associated_table| @tables[associated_table] = :pending if @tables[associated_table].nil? }
        end
      end
      @tables.values
    end
    def self.analyze_table table_name
      new(table_name).analyze_table
    end
    
    def self.next_table_to_process
      @tables.keys.detect {|table_name| @tables[table_name] == :pending }
    end
    
    def initialize(table_name)
      @table_name        = table_name
    end
    
    def analyze_table
      puts "analyzing #{table_name} => #{class_name}"
      { :table_name   => table_name,
        :class_name   => class_name,
        :primary_key  => primary_key,
        :relations    => relations,
        :constraints  => constraints
      }
    end
    
    def self.tables name_pattern=/.*/
      connection.tables.select {|table_name| table_name =~ name_pattern }.sort
    end
    
    def class_name
      TableClassNameMapper.class_name_for(self.table_name)
    end

    def primary_key
      pk_and_sequence_for = connection.pk_and_sequence_for(table_name)
      pk_and_sequence_for.first if pk_and_sequence_for.respond_to? :first
    end

    def relations
      { :belongs_to   => belongs_to_relations,
        :has_some     => has_some_relations
      }
    end
    
    def belongs_to_relations
      return [] unless connection.respond_to? :foreign_keys_for
      
      belongs_to = {}
      connection.foreign_keys_for(table_name).each do |relation|
        belongs_to[relation.first.downcase] = relation.second.downcase.to_sym
      end
      belongs_to
    end
    def has_some_relations
      return [] unless connection.respond_to? :foreign_keys_of

      has_some = {}
      connection.foreign_keys_of(table_name).each do |relation|
        has_some[relation.first.downcase] = relation.second.downcase.to_sym
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
    
    def non_nullable_constraints
      non_nullable_constraints = connection.columns(table_name, "#{table_name} Columns").reject(&:null).map(&:name)
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

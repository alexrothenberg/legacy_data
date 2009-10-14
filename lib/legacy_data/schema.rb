module LegacyData
  class Schema
    attr_reader :table_name
    
    def self.analyze(options={})
      initialize_tables(options[:table_name])

      while table_name = next_table_to_process
        table_definitions[table_name] = analyze_table(table_name)

        unless options[:skip_associated]
          [:has_many, :belongs_to].each do |relation_type| 
            associated_tables = table_definitions[table_name][:relations][relation_type].keys.map(&:to_s) 
            associated_tables.each {|associated_table| add_pending_table(associated_table) }
          end
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
      log "analyzing #{table_name} => #{class_name}"
      TableDefinition.new(:table_name   => table_name,
                          :columns      => columns,
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
      if @pk.nil?
        if connection.respond_to?(:pk_and_sequence_for)
          @pk, seq = connection.pk_and_sequence_for(table_name)
        elsif connection.respond_to?(:primary_key)
          @pk = connection.primary_key(table_name)
        end
      end
      @pk
    end

    def relations
      { :belongs_to               => belongs_to_relations,
        :has_many                 => has_some_relations,
        :has_and_belongs_to_many  => {}
      }
    end
    
    def belongs_to_relations
      return {} unless connection.respond_to? :foreign_keys_for
      
      belongs_to = {}
      connection.foreign_keys_for(table_name).each do |relation|
        belongs_to[relation.first.downcase] = {:foreign_key=>relation.second.downcase.to_sym}
      end
      belongs_to
    end
    def has_some_relations
      return {} unless connection.respond_to? :foreign_keys_of

      has_some = {}
      connection.foreign_keys_of(table_name).each do |relation|
        has_some[relation.delete(:to_table).downcase] = relation
      end
      has_some
    end

    def constraints
      if @constraints.nil?
        @constraints = {}
      
        @constraints[:unique],           @constraints[:multi_column_unique] = uniqueness_constraints
        boolean_presence_columns,        @constraints[:presence_of]         = presence_constraints
        @constraints[:numericality_of]                                      = numericality_constraints
        @constraints[:custom],           @constraints[:inclusion_of]        = custom_constraints
        
        boolean_presence_columns.each {|col| @constraints[:inclusion_of][col] = "true, false" }
      end
      @constraints
      ##### TO DO
      # presence_of schoolparentid => school_parent     - FOREIGN KEY
    end
    
    def numericality_constraints
      allow_nil, do_not_allow_nil = integer_columns.partition do |column| 
        column.null
      end
      {:allow_nil=>allow_nil.map(&:name), :do_not_allow_nil=>do_not_allow_nil.map(&:name)}
    end

    def uniqueness_constraints
      unique, multi_column_unique = unique_constraints.partition do |columns| 
        columns.size == 1
      end
      [unique.map(&:first), multi_column_unique] 
    end

    def presence_constraints
      boolean_presence, presence_of = non_nullable_constraints.partition do |column_name| 
        column_by_name(column_name).type == :boolean 
      end
    end

    def column_by_name name
      columns.detect {|column| column.name == name }
    end
    
    def integer_columns
      columns.select {|column| column.type == :integer }.reject {|column| column.name == primary_key}
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
      custom_constraints, inclusion_constraints = {}, {}
      connection.constraints(table_name).each do |constraint|
        constraint_sql = constraint.second
        if constraint_sql =~ /\s*\"*(\w*)\"*\s*IN\s*\((.*)\)/i
          inclusion_constraints[$1.downcase.to_sym] = $2
        else
          custom_constraints[constraint.first.underscore.to_sym] = constraint_sql
        end
      end
      [custom_constraints, inclusion_constraints]
    end    

    def log msg
      self.class.log msg
    end
    def self.log msg
      puts msg
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

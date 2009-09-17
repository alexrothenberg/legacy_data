module LegacyData
  class Schema
    attr_reader :table_name
    
    def initialize(table_name, naming_convention=nil)
      @table_name        = table_name
      @naming_convention = naming_convention
      @naming_convention = /^#{naming_convention.gsub('*', '(.*)')}$/i if @naming_convention.is_a? String
    end
    
    def analyze_table
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
      class_name_for(self.table_name)
    end

    def class_name_for table
      table =~ @naming_convention
      stripped_table_name = $1 || table
      ActiveRecord::Base.class_name(stripped_table_name.downcase.pluralize)
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
        class_name = class_name_for(relation.first).underscore.to_sym
        belongs_to[class_name] = relation.second.downcase.to_sym
      end
      belongs_to
    end
    def has_some_relations
      return [] unless connection.respond_to? :foreign_keys_of

      has_some = {}
      connection.foreign_keys_of(table_name).each do |relation|
        class_name = class_name_for(relation.first).underscore.pluralize.to_sym
        has_some[class_name] = relation.second.downcase.to_sym
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

module LegacyData
  class TableClassNameMapper
    include Singleton
    
    attr_accessor :naming_convention, :dictionary
    def naming_convention= naming_convention
      @naming_convention = (naming_convention || '*').gsub('*', '(.*)')
    end
    
    def dictionary
      @dictionary ||= load_dictionary
    end

    def self.naming_convention= value
      instance.naming_convention = value
    end
    def self.load_dictionary
      instance.load_dictionary
    end
    def self.save_dictionary
      instance.save_dictionary
    end
    def self.dictionary_file_name
      instance.dictionary_file_name
    end

    def load_dictionary
      @dictionary = nil
      YAML.load_file(dictionary_file_name) || {}
    end

    def save_dictionary
      File.open(dictionary_file_name, 'w') do |out|
        YAML.dump(dictionary, out)
      end
    end
    
    def dictionary_file_name
      File.join(RAILS_ROOT, 'app', 'models', 'table_mappings.yaml')
    end
    
    def self.class_name_for table_name
      instance.lookup_class_name(table_name) || instance.compute_class_name(table_name)
    end

    def lookup_class_name table_name
      dictionary[table_name]
    end
    
    def compute_class_name table_name
      table_name =~ /#{naming_convention}/i
      stripped_table_name = $1 || table_name
      dictionary[table_name] = ActiveRecord::Base.class_name(stripped_table_name.downcase.pluralize)
    end
  end

end

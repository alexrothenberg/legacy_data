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

    def self.method_missing(method_id, *arguments, &block)
      instance.send(method_id, *arguments, &block)
    end

    def clear_dictionary
      @dictionary = nil
    end

    def load_dictionary
      clear_dictionary
      File.exists?(dictionary_file_name) ? YAML.load_file(dictionary_file_name) : {}
    end

    def save_dictionary
      File.open(dictionary_file_name, 'w') do |out|
        YAML.dump(dictionary, out)
      end
    end
    
    def dictionary_file_name
      File.join(RAILS_ROOT, 'app', 'models', 'table_mappings.yml')
    end
    
    def class_name_for table_name
      lookup_class_name(table_name) || compute_class_name(table_name)
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

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

    def let_user_validate_dictionary
      save_dictionary
      self.class.log <<-MSG
Done analyzing the tables.  
  Automatic class names written to '#{LegacyData::TableClassNameMapper.dictionary_file_name}'
  Since the database probably does not follow Rails naming conventions you should take a look at the class names and update them in that file. 
  Once you're done hit <enter> to continue generating the models"
      MSG
      gets
      load_dictionary
    end
    
    def dictionary_file_name
      File.join(Rails.root, 'app', 'models', 'table_mappings.yml')
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
      dictionary[table_name] = LegacyData.conventional_class_name stripped_table_name
    end
    
    def self.log msg
      puts msg
    end
  end

end

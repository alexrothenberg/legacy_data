require File.dirname(__FILE__) + '/../../lib/legacy_data/schema'
require File.dirname(__FILE__) + '/../../lib/legacy_data/table_class_name_mapper'
require File.dirname(__FILE__) + '/../../lib/active_record/connection_adapters/oracle_enhanced_adapter'

class ModelsFromTablesGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.directory File.join('app/models')

      LegacyData::TableClassNameMapper.naming_convention = options[:table_naming_convention]
      
      analyzed_tables = LegacyData::Schema.analyze(:table_name=>options[:table_name])
      LegacyData::TableClassNameMapper.save_dictionary
      puts "Please look at #{LegacyData::TableClassNameMapper.dictionary_file_name} [hit <enter> to continue]"
      gets
      LegacyData::TableClassNameMapper.load_dictionary

      analyzed_tables.each do |analyzed_table|
        analyzed_table[:class_name] = LegacyData::TableClassNameMapper.class_name_for(analyzed_table[:table_name])
        m.class_collisions :class_path, analyzed_table[:class_name]
        m.template           'model.rb',      
                             File.join('app/models', "#{analyzed_table[:class_name].underscore}.rb"), 
                             :assigns => analyzed_table
      end
    end
  end

protected
  def add_options!(opt)
    opt.on('--table-name [ARG]', 
          'Only generate models for given table') { |value| options[:table_name] = value }
    opt.on('--table-naming-convention [ARG]', 
          'Naming convention for tables in the database - will not be used when generating naming the models') { |value| options[:table_naming_convention] = value }
  end
  
end

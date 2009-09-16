require File.dirname(__FILE__) + '/../../lib/legacy_data/schema'
require File.dirname(__FILE__) + '/../../lib/active_record/connection_adapters/oracle_enhanced_adapter'

class LegacyModelsGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.directory File.join('app/models')

      LegacyData::Schema.tables(Regexp.new("^#{options[:tables_starting_with]}")).each do |table_name|
        puts "analyzing #{table_name}"
        analysis = LegacyData::Schema.new(table_name, options[:table_prefix_naming_convention]).analyze_table

        file_name = analysis[:class_name].underscore
        m.template           'model.rb',      
                             File.join('app/models', "#{file_name}.rb"), 
                             :assigns => analysis
      end
    end
  end

protected
  def add_options!(opt)
    opt.on('--tables-starting-with [ARG]', 
          'Only generate models for tables starting with') { |value| options[:tables_starting_with] = value }
    opt.on('--table-prefix-naming-convention [ARG]', 
          'Naming convention for tables in the database - will not be used when generating naming the models') { |value| options[:table_prefix_naming_convention] = value }
  end
  
end

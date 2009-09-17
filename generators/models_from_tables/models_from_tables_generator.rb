require File.dirname(__FILE__) + '/../../lib/legacy_data/schema'
require File.dirname(__FILE__) + '/../../lib/active_record/connection_adapters/oracle_enhanced_adapter'

class ModelsFromTablesGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.directory File.join('app/models')

      if options[:table_name]
        tables = [options[:table_name] ] 
      else
        naming_convention = options[:table_naming_convention] || '*'
        tables = LegacyData::Schema.tables(/^#{naming_convention.gsub('*', '.*')}$/)
      end
      tables.each do |table_name|
        puts "analyzing #{table_name}"
        analysis = LegacyData::Schema.new(table_name, options[:table_naming_convention]).analyze_table

        file_name = analysis[:class_name].underscore
        m.template           'model.rb',      
                             File.join('app/models', "#{file_name}.rb"), 
                             :assigns => analysis
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

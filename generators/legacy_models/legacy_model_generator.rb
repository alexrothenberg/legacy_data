require File.dirname(__FILE__) + '/../../lib/legacy_data/schema'

class LegacyModelsGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.directory File.join('app/models')

      LegacyData::Schema.tables.each do |table_name|
        puts "analyzing #{table_name}"
        analysis = LegacyData::Schema.new(table_name).analyze_table

        file_name = analysis[:class_name].underscore
        m.template           'model.rb',      
                             File.join('app/models', "#{file_name}.rb"), 
                             :assigns => analysis
      end
    end
  end

  
end

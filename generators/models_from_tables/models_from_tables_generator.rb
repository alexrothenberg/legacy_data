require File.dirname(__FILE__) + '/../../lib/legacy_data'
# require File.dirname(__FILE__) + '/../../lib/legacy_data/table_definition'
# require File.dirname(__FILE__) + '/../../lib/legacy_data/schema'
# require File.dirname(__FILE__) + '/../../lib/legacy_data/table_class_name_mapper'
# require File.dirname(__FILE__) + '/../../lib/active_record/connection_adapters/oracle_enhanced_adapter'

class ModelsFromTablesGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.directory File.join('app/models')

      LegacyData::TableClassNameMapper.naming_convention = options[:table_naming_convention]
      
      analyzed_tables = LegacyData::Schema.analyze(options)

      LegacyData::TableClassNameMapper.let_user_validate_dictionary

      analyzed_tables.each do |analyzed_table|
        analyzed_table.class_name = LegacyData::TableClassNameMapper.class_name_for(analyzed_table[:table_name])

        m.class_collisions :class_path, analyzed_table[:class_name]
        m.template           'model.rb',      
                             File.join('app/models', "#{analyzed_table[:class_name].underscore}.rb"), 
                             :assigns => analyzed_table.to_hash

        add_factory_girl_factory analyzed_table.to_hash
                             
        # #                      puts m.source_root
        # # factory_template = m.source_path('factory.rb')
        # 
        # factory_template = File.dirname(__FILE__) + '/templates/factory.rb'
        # puts "factory_template #{factory_template}"
        # new_factory =          m.send(:render_file, factory_template) do |file|
        # #             vars = analyzed_table.to_hash
        # #             b = binding
        # #             vars.each { |k,v| eval "#{k} = vars[:#{k}] || vars['#{k}']", b }
        # # puts 'in block'
        #           "in block"
        #            # Render the source file with the temporary binding.
        #            # ERB.new(file.read, nil, '-').result(b)
        #          end
        # puts 'after new_factory'
        # puts "    its... #{new_factory}"
# 
#         m.gsub_file 'spec/factories.rb', /\Z/ do |match|
# # #           # puts match
# # #           puts 'BEFORE'
# # #           # puts m.source_path('factory.rb')
# # #           # puts analyzed_table.to_hash.inspect
# # #           puts 'BEFORE'
# puts 'before'
# puts new_factory
#           puts "DONE"
#           "#{match}\n  #{new_factory}\n"
#           # "#{match}\n ok \n"
#         end
      end
    end
  rescue => e
    # for debugging...
    puts e.backtrace
  end

protected
  def add_options!(opt)
    opt.on('--table-name [ARG]', 
          'Only generate models for given table') { |value| options[:table_name] = value }
    opt.on('--table-naming-convention [ARG]', 
          'Naming convention for tables in the database - will not be used when generating naming the models') { |value| options[:table_naming_convention] = value }
    opt.on('--skip-associated', 
          'Do not follow foreign keys to model associated tables') { |value| options[:skip_associated] = true }
  end
  

  def add_factory_girl_factory analyzed_schema
    factory_name = analyzed_schema[:class_name].underscore
    columns      = analyzed_schema[:columns]

    File.open("#{RAILS_ROOT}/spec/factories.rb", 'a+') do |file| 
      file.write "Factory.define :#{factory_name} do |#{factory_name.to_s.first}|\n"
      columns.each do |c|
        if c.null == false && c.name != analyzed_schema[:primary_key]
          value = case c.type
          when :integer
            "7"
          when :string
            "'hi'"
          when :boolean
            'false'
          when :date
            '{Time.now}'
          when :datetime
            '{Time.now}'
          when :decimal
            '12.3'
          else
            raise "the generator forgot to handle columns of type #{c.type}"
          end
          file.write "  #{factory_name.to_s.first}.#{c.name} #{value}\n"
        end
      end
      file.write "end\n\n"
    end
  end

end

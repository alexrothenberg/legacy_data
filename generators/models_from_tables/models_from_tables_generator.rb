require File.dirname(__FILE__) + '/../../lib/legacy_data'

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
                             :assigns => {:definition => analyzed_table}

        add_factory_girl_factory analyzed_table if options[:with_factories]

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
    opt.on('--with-factories', 
          'Add factory-girl factories for all created models') { |value| options[:with_factories] = true }
  end
  

  def add_factory_girl_factory analyzed_schema
    factory_name = analyzed_schema[:class_name].underscore
    columns      = analyzed_schema[:columns]

    File.open("#{RAILS_ROOT}/spec/factories.rb", 'a+') do |file| 
      file.write "Factory.define :#{factory_name} do |#{factory_name.to_s.first}|\n"
      column_with_longest_name = columns.max {|a,b| a.name.length <=> b.name.length }
      columns.each do |c|
        if c.null == false && c.name != analyzed_schema[:primary_key]
          value = case c.type
          when :integer       then %[7]
          when :float         then %[12.3]
          when :decimal       then %[12.3]
          when :datetime      then %[{Time.now}]
          when :date          then %[{Time.now}]
          when :timestamp     then %[{Time.now}]
          when :time          then %[{Time.now}]
          when :text          then %['some text value']
          when :string        then %['some string']
          when :binary        then %['some binary stuff']
          when :boolean       then %[false]
          else
            "'Sorry the models_to_tables_generator is not sure how to default columns of type #{c.type}'"
          end
          spaces = column_with_longest_name.name.size - c.name.size
          file.write "  #{factory_name.to_s.first}.#{c.name}#{' ' * spaces} #{value}\n"
        end
      end
      file.write "end\n\n"
    end
  end

end

class ModelsFromTablesGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  argument :table_name,              :type => :string,  :required=>false, :default => nil

  class_option :table_naming_convention, :type => :string,  :default => '*',
                                         :desc => 'Is there a prefix and/or suffix in the table names to strip when creating class names'
  class_option :with_factories,          :type => :boolean, :default => true,
                                         :desc => 'Generate a FactoryGirl factory for each model'
  class_option :skip_associated,         :type => :boolean, :default => false,
                                         :desc => "Do not follow database relations to other tables"

  # check_class_collision #:suffix => "ControllerTest"

  def generate_models_from_tables
    LegacyData::TableClassNameMapper.naming_convention = options[:table_naming_convention]
    
    analyzed_tables = LegacyData::Schema.analyze(:table_name=>table_name, :skip_associated=>options[:skip_associated])

    unless analyzed_tables.blank?
      # m.directory File.join('app/models')

      LegacyData::TableClassNameMapper.let_user_validate_dictionary

      analyzed_tables.each do |analyzed_table|
        analyzed_table.class_name = LegacyData::TableClassNameMapper.class_name_for(analyzed_table[:table_name])

        # m.class_collisions :class_path, analyzed_table[:class_name]
        @definition = analyzed_table
        template 'model.rb', File.join('app/models', "#{analyzed_table[:class_name].underscore}.rb")

        add_factory_girl_factory analyzed_table if options[:with_factories]
      end
    end
  end

  private
  def add_factory_girl_factory analyzed_schema
    factory_name = analyzed_schema[:class_name].underscore
    columns      = analyzed_schema[:columns]

    File.open("#{Rails.root}/spec/factories.rb", 'a+') do |file| 
      file.write "Factory.define :#{factory_name} do |#{factory_name}|\n"
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
          file.write "  #{factory_name}.#{c.name}#{' ' * spaces} #{value}\n"
        end
      end
      file.write "end\n\n"
    end
  end
  
end

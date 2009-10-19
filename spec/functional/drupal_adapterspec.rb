require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

if ENV['ADAPTER'] == 'mysql'

  def create_drupal_schema
    sql = File.read File.expand_path(File.dirname(__FILE__) + '/../../examples/drupal_6_14.sql')
    sql.split(';').each do |sql_statement|
      ActiveRecord::Base.connection.execute(sql_statement) unless sql_statement.blank?
    end
  end

  describe 'Generating models from the mysql drupal 6.14 database' do
    before :all do
      adapter = 'mysql'
      example = :drupal
      
      connection_info = connection_info_for(example, adapter) 
      pending("The #{example} spec does not run for #{adapter}") if connection_info.nil?
      initialize_connection connection_info
      create_drupal_schema
        
      silence_warnings { RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../../output/functional/#{example}_#{adapter}") } 
      FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
      FileUtils.mkdir_p(RAILS_ROOT + '/spec')
    
      LegacyData::Schema.stub!(:log)    

      @expected_directory = File.expand_path("#{File.dirname(__FILE__)}/../../examples/generated/#{example}_#{adapter}") 
      
      LegacyData::TableClassNameMapper.dictionary['files'] = 'UploadedFiles'  #to avoid collision with Ruby File class
      LegacyData::TableClassNameMapper.dictionary['cache'] = 'Cache'          #don't strip the e to make it cach

      FileUtils.rm(RAILS_ROOT + '/spec/factories.rb', :force => true)
      invoke_generator('models_from_tables', ["--with-factories"], :create)

    end
    after :all do
      Object.send(:remove_const, :RAILS_ROOT)
    end
  
    %w( access       action        actions_aid  authmap        batch                  block        blocks_role 
        box          cache         cache_block  cache_filter   cache_form             cache_menu   cache_page 
        cache_update comment       filter       filter_format  flood                  history      menu_custom 
        menu_link    menu_router   node         node_access    node_comment_statistic node_counter node_revision 
        node_type    permission    role         session        system                 term_data    term_hierarchy 
        term_node    term_relation term_synonym uploaded_files url_alias              user         users_role 
        variable     vocabulary    vocabulary_node_type        watchdog ).each do |model|
      it "should generate the expected #{model} model" do
        File.read(RAILS_ROOT + "/app/models/#{model}.rb").should == File.read("#{@expected_directory}/#{model}.rb")
      end
    end
    
    it "should  generated the expected factories" do
      File.read(RAILS_ROOT + '/spec/factories.rb').should == File.read("#{@expected_directory}/factories.rb")
    end
  end
end

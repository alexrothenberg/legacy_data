require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

def create_j2ee_petstore_schema
  execute_sql_script(File.expand_path(File.dirname(__FILE__) + '/../../examples/delete_j2ee_petstore.sql') ) unless ENV['ADAPTER'] == 'sqlite3'
  execute_sql_script(File.expand_path(File.dirname(__FILE__) + '/../../examples/create_j2ee_petstore.sql') )
end

describe 'Generating models from the j2ee petstore database' do
  before :all do
    adapter = ENV['ADAPTER']
    example = :j2ee_petstore
    
    connection_info = connection_info_for(example, adapter) 
    pending("The #{example} spec does not run for #{adapter}") if connection_info.nil?
    initialize_connection connection_info
    create_j2ee_petstore_schema
      
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

  models =  %w( address   category             id_gen       item           
                product   tag          ziplocation )
  
  if ENV['ADAPTER'] == 'oracle'              
    models + %w( sellercontactinfo   ) 
  else
    models + %w( seller_contact_info tag_info) 
  end
                
  models.each do |model|
    it "should generate the expected #{model} model" do
      File.read(RAILS_ROOT + "/app/models/#{model}.rb").should == File.read("#{@expected_directory}/#{model}.rb")
    end
  end
  
  it "should  generated the expected factories" do
    File.read(RAILS_ROOT + '/spec/factories.rb').should == File.read("#{@expected_directory}/factories.rb")
  end
end

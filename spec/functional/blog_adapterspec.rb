require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

describe 'Models From Tables generator' do
  before :all do
    adapter = ENV['ADAPTER']
    abort('No adapter specified') if adapter.nil?
    
    create_blog_tables(connection_info_for(adapter) )
        
    silence_warnings { RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../../output/functional/blog_#{adapter}") } 
    FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
    FileUtils.mkdir_p(RAILS_ROOT + '/spec')
    
    LegacyData::Schema.stub!(:log)    

    @expected_directory = File.expand_path("#{File.dirname(__FILE__)}/../../examples/generated/blog_#{adapter}") 
  end
  after :all do
    Object.send(:remove_const, :RAILS_ROOT)
  end

  it 'should generate a posts model' do
    
    invoke_generator('models_from_tables', [], :create)
    
    File.read(RAILS_ROOT + '/app/models/post.rb'   ).should == File.read("#{@expected_directory}/post.rb"     )
  end

  it 'should generate all models in database' do
    FileUtils.rm(RAILS_ROOT + '/spec/factories.rb', :force => true)
    invoke_generator('models_from_tables', ["--with-factories"], :create)
    
    File.read(RAILS_ROOT + '/app/models/post.rb'   ).should == File.read("#{@expected_directory}/post.rb"     )
    File.read(RAILS_ROOT + '/app/models/comment.rb').should == File.read("#{@expected_directory}/comment.rb"  )
  
    File.read(RAILS_ROOT + '/spec/factories.rb'    ).should == File.read("#{@expected_directory}/factories.rb")
  end
  
end

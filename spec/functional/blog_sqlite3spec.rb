require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

describe 'Models From Tables generator' do
  before :all do
    create_blog_tables(:adapter=>'sqlite3', :database=> ":memory:")

    silence_warnings { RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../../output/functional/sqlite3_blog') } 
    FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
    FileUtils.mkdir_p(RAILS_ROOT + '/spec')
    
    LegacyData::Schema.stub!(:log)    
  end
  after :all do
    Object.send(:remove_const, :RAILS_ROOT)
  end

  it 'should generate a posts model' do
    invoke_generator('models_from_tables', ["--table-name", "posts"], :create)
    
    File.read(RAILS_ROOT + '/app/models/post.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/sqlite3_blog/post.rb'))
  end

  it 'should generate all models in database' do
    FileUtils.rm(RAILS_ROOT + '/spec/factories.rb', :force=>true)
    invoke_generator('models_from_tables', ["--with-factories"], :create)
    
    File.read(RAILS_ROOT + '/app/models/post.rb').should    == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/sqlite3_blog/post.rb'))
    File.read(RAILS_ROOT + '/app/models/comment.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/sqlite3_blog/comment.rb'))
  
    File.read(RAILS_ROOT + '/spec/factories.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/sqlite3_blog/factories.rb'))
  end
  
end

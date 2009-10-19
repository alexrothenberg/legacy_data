require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

def create_blog_tables 
  connection = ActiveRecord::Base.connection
  
  [:post_tags, :comments, :posts, :tags].each do |table|
    connection.drop_table table  if connection.table_exists? table
  end

  connection.create_table :posts do |t|
    t.string :title
    t.text   :body
  end
  connection.create_table :comments do |t|
    t.integer     :post_id
    t.foreign_key :posts,    :dependent => :delete
    t.text        :body
  end
  connection.create_table :tags do |t|
    t.string     :name
  end
  connection.create_table :post_tags, :id=>false do |t|
    t.integer     :post_id
    t.foreign_key :posts
    t.integer     :tag_id
    t.foreign_key :tags
  end
end


describe 'Generating models from a blog database' do
  before :all do
    adapter = ENV['ADAPTER']
    abort('No adapter specified') if adapter.nil?
    connection_info = connection_info_for(:blog, adapter) 
    pending("The #{:blog} spec does not run for #{adapter}") if connection_info.nil?
    initialize_connection connection_info
    create_blog_tables
        
    silence_warnings { RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../../output/functional/blog_#{adapter}") } 
    FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
    FileUtils.mkdir_p(RAILS_ROOT + '/spec')
    
    LegacyData::Schema.stub!(:log)    

    @expected_directory = File.expand_path("#{File.dirname(__FILE__)}/../../examples/generated/blog_#{adapter}") 
  end
  after :all do
    Object.send(:remove_const, :RAILS_ROOT)
  end
  
  before :each do #
    pending("oracle does not yet work with t.foreign_key table creation") if ENV['ADAPTER'] == 'oracle'
    FileUtils.rm(RAILS_ROOT + '/spec/factories.rb', :force => true)
    invoke_generator('models_from_tables', ["--with-factories"], :create)
  end

  %w( post comment tag ).each do |model|
    it "should generate the expected #{model} model" do
      File.read(RAILS_ROOT + "/app/models/#{model}.rb").should == File.read("#{@expected_directory}/#{model}.rb")
    end
  end

  it "should  generated the expected factories" do
    File.read(RAILS_ROOT + '/spec/factories.rb').should == File.read("#{@expected_directory}/factories.rb")
  end
  
end


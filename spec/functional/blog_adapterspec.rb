require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')


describe "Generating models from a blog #{ENV['ADAPTER']} database" do
  before :all do
    @adapter = ENV['ADAPTER']
    @example = :blog

    connection_info = connection_info_for(@example, @adapter) 
    pending("The #{@example} spec does not run for #{@adapter}") if connection_info.nil?
    initialize_connection connection_info

    require File.expand_path(File.dirname(__FILE__) + '/../../examples/blog_migration')
    create_blog_tables
        
    silence_warnings { RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../../output/functional/#{@example}_#{@adapter}") } 
    FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
    FileUtils.mkdir_p(RAILS_ROOT + '/spec')
    
    LegacyData::Schema.stub!(:log)    

    @expected_directory = File.expand_path("#{File.dirname(__FILE__)}/../../examples/generated/#{@example}_#{@adapter}") 
  end
  after :all do
    Object.send(:remove_const, :RAILS_ROOT)
  end
  
  before :each do #
    pending("oracle does not yet work with t.foreign_key table creation") if @adapter == 'oracle'
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


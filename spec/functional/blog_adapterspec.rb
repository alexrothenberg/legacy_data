require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')


describe ModelsFromTablesGenerator, "Generating models from a blog #{ENV['ADAPTER']} database" do
  include GeneratorSpecHelper

  before :all do
    @adapter = ENV['ADAPTER']
    @example = :blog

    connection_info = connection_info_for(@example, @adapter) 
    pending("The #{@example} spec does not run for #{@adapter}") if connection_info.nil?
    initialize_connection connection_info

    require File.expand_path(File.dirname(__FILE__) + '/../../examples/blog_migration')
    create_blog_tables
        
    self.destination_root = File.expand_path("#{File.dirname(__FILE__)}/../../output/functional/#{@example}_#{@adapter}")
    FileUtils.mkdir_p(destination_root + '/app/models')
    FileUtils.mkdir_p(destination_root + '/spec')
    
    @expected_directory = File.expand_path("#{File.dirname(__FILE__)}/../../examples/generated/#{@example}_#{@adapter}") 
  end
  
  before :each do #
    pending("oracle does not yet work with t.foreign_key table creation") if @adapter == 'oracle'

    Rails.stub!(:root).and_return(destination_root)

    FileUtils.rm(destination_root + '/spec/factories.rb', :force => true)
    run_generator []
  end

  %w( post comment tag ).each do |model|
    it "should generate the expected #{model} model" do
      File.read(destination_root + "/app/models/#{model}.rb").should == File.read("#{@expected_directory}/#{model}.rb")
    end
  end

  it "should  generated the expected factories" do
    File.read(destination_root + '/spec/factories.rb'       ).should == File.read("#{@expected_directory}/factories.rb")
  end
  
end


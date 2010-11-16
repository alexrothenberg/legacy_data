require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

require 'generators/models_from_tables/models_from_tables_generator'

describe ModelsFromTablesGenerator do
  include GeneratorSpecHelper

  before :all do
    self.destination_root = File.expand_path(File.dirname(__FILE__) + '/../output')
    FileUtils.mkdir_p(destination_root + '/app/models')
    FileUtils.mkdir_p(destination_root + '/spec')
  end
  
  before :each do
    Rails.stub!(:root).and_return(destination_root)
    FileUtils.rm(destination_root + '/spec/factories.rb', :force => true)
    
    @posts = LegacyData::TableDefinition.new( :class_name   => 'Posts',
                                              :table_name   => 'posts',
                                              :columns      => [stub(:name=>'title', :null=>false, :type=>:string), 
                                                                stub(:name=>'body',  :null=>false, :type=>:string)],
                                              :primary_key  => 'id',
                                              :relations    => { :has_many               =>{'comments'=>{:foreign_key=>:comment_id}}, 
                                                                 :belongs_to             =>{}, 
                                                                 :has_and_belongs_to_many=>{}
                                                               },
                                              :constraints  => { :unique             =>['title'],
                                                                 :multi_column_unique=>[],
                                                                 :inclusion_of       =>[],
                                                                 :presence_of        =>['body'],
                                                                 :numericality_of    =>[],
                                                                 :custom             =>[]
                                                                }
                                              )
                    

    LegacyData::TableClassNameMapper.should_receive(:let_user_validate_dictionary)
    LegacyData::TableClassNameMapper.stub!(:class_name_for).with('posts'   ).and_return('Post')
    LegacyData::TableClassNameMapper.stub!(:class_name_for).with('comments').and_return('Comment')
  end
  
  describe 'with factories' do
    before :each do
      LegacyData::Schema.should_receive(:analyze).with(hash_including(:table_name=>'posts')).and_return([@posts])
      run_generator %w(posts)
    end

    it 'should generate a posts model' do
      File.read(destination_root + '/app/models/post.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/post.rb'))
    end
    it 'should generate factories' do
      File.read(destination_root + '/spec/factories.rb' ).should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/factories.rb'))
    end
  end
  
  it 'should not generate factories when asked not to' do
    LegacyData::Schema.should_receive(:analyze).with(hash_including(:table_name=>'posts')).and_return([@posts])
    gen = generator %w(posts), %w(--with-factories false)
    gen.should_not_receive(:add_factory_girl_factory)
    capture(:stdout) { gen.invoke_all }
  end

end


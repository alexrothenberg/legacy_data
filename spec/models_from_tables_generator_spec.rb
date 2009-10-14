require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Models From Tables generator' do
  before :all do
    silence_warnings { RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../output') } 
    FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
    FileUtils.mkdir_p(RAILS_ROOT + '/spec')
  end
  after :all do
    Object.send(:remove_const, :RAILS_ROOT)
  end
  
  before :each do
    FileUtils.rm(RAILS_ROOT + '/spec/factories.rb')
    
    @posts = LegacyData::TableDefinition.new( :class_name   => 'Posts',
                                              :table_name   => 'posts',
                                              :columns      => [stub(:name=>'title', :null=>false, :type=>:string), 
                                                                stub(:name=>'body',  :null=>false, :type=>:string)],
                                              :primary_key  => 'id',
                                              :relations    => { :has_many               =>{'comments'=>{:foreign_key=>'comment_id'}}, 
                                                                 :belongs_to             =>{}, 
                                                                 :has_and_belongs_to_many=>[]
                                                               },
                                              :constraints  => { :unique             =>['title'],
                                                                 :multi_column_unique=>[],
                                                                 :inclusion_of       =>[],
                                                                 :presence_of        =>['body'],
                                                                 :numericality_of    =>[],
                                                                 :custom             =>[]
                                                                }
                                              )
                    

    LegacyData::Schema.should_receive(:analyze).with(hash_including(:table_name=>'posts')).and_return([@posts])
    LegacyData::TableClassNameMapper.should_receive(:let_user_validate_dictionary)
    LegacyData::TableClassNameMapper.stub!(:class_name_for).with('posts'   ).and_return('Post')
    LegacyData::TableClassNameMapper.stub!(:class_name_for).with('comments').and_return('Comment')

    cmd = command_for_generator('models_from_tables', ["--table-name", "posts"], :create)
    cmd.invoke!
  end
  
  it 'should generate a posts model' do
    File.read(RAILS_ROOT + '/app/models/post.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/post.rb'))
  end
  
  it 'should generate a :posts factory' do
    
    File.read(RAILS_ROOT + '/spec/factories.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/factories.rb'))
  end
end

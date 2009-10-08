require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Models From Tables generator' do
  before :all do
    silence_warnings { RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../../output') } 
    FileUtils.mkdir_p(RAILS_ROOT + '/app/models')
  end
  after :all do
    Object.send(:remove_const, :RAILS_ROOT)
  end
  
  before :each do
    @posts = LegacyData::TableDefinition.new( :class_name   => 'Posts',
                                              :table_name   => 'posts',
                                              :columns      => ['title', 'body'],
                                              :primary_key  => 'id',
                                              :relations    => { :has_many               =>{'comments'=>{:foreign_key=>'comment_id'}}, 
                                                                 :belongs_to             =>{}, 
                                                                 :has_and_belongs_to_many=>[]
                                                               },
                                              :constraints  => { :unique             =>['title'],
                                                                 :multi_column_unique=>[],
                                                                 :boolean_presence   =>[],
                                                                 :presence_of        =>['body'],
                                                                 :numericality_of    =>[],
                                                                 :custom             =>[]
                                                                }
                                              )
                    
  end
  
  it 'should generate a posts model' do
    LegacyData::Schema.should_receive(:analyze).with(hash_including(:table_name=>'posts')).and_return([@posts])
    LegacyData::TableClassNameMapper.should_receive(:let_user_validate_dictionary)
    LegacyData::TableClassNameMapper.stub!(:class_name_for).with('posts'   ).and_return('Post')
    LegacyData::TableClassNameMapper.stub!(:class_name_for).with('comments').and_return('Comment')

    invoke_generator('models_from_tables', ["--table-name", "posts"], :create)
    
    File.read(RAILS_ROOT + '/app/models/post.rb').should == File.read(File.expand_path(File.dirname(__FILE__) + '/expected/post.rb'))
  end
end

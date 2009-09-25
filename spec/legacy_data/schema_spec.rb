require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyData::Schema do
  describe 'following associations' do
    before :each do
      LegacyData::Schema.stub!(:analyze_table).with('posts'   ).and_return(@posts_analysis   =mock(:posts,    {:join_table? =>false}))
      LegacyData::Schema.stub!(:analyze_table).with('comments').and_return(@comments_analysis=mock(:comments, {:join_table? =>false}))
      @posts_analysis.stub!(   :[]).with(:relations).and_return({:belongs_to=>{                                 }, :has_many=>{:comments=>{:foreign_key=>:posts_id}}})
      @comments_analysis.stub!(:[]).with(:relations).and_return({:belongs_to=>{:posts=>{:foreign_key=>:posts_id}}, :has_many=>{                                    }})
    end
    
    it 'should analyze all tables when not given a table to start with' do
      LegacyData::Schema.should_receive(:tables).and_return(['posts', 'comments'])
      
      LegacyData::Schema.analyze.should include(@posts_analysis, @comments_analysis)
    end

    it 'should find the associated comments when starting with posts' do
      LegacyData::Schema.analyze(:table_name=>'posts').should include(@posts_analysis, @comments_analysis)
    end
  end
    
  it 'should analyze a single table' do
    LegacyData::Schema.should_receive(:new).with('some_table').and_return(schema=mock)
    schema.should_receive(:analyze_table).and_return(analysis=mock)

    LegacyData::Schema.analyze_table('some_table').should == analysis
  end
  
  before :each do
    LegacyData::Schema.instance_variable_set('@conn', nil)
    ActiveRecord::Base.stub(:connection).and_return(@connection=stub(:connection))
  end

  it "should get a list of the tables from the database" do
    @connection.should_receive(:tables).and_return(['comments', 'people', 'posts'])
    LegacyData::Schema.tables.should == ['comments', 'people', 'posts']
  end

  describe 'analyzing a table' do
    before :each do
      @schema = LegacyData::Schema.new('some_table')
      @schema.stub!(:puts)
    end
    
    it 'should have all the information about the table' do  
      @schema.stub!(:class_name  ).and_return(class_name =mock)
      @schema.stub!(:column_names).and_return(columns    =mock)
      @schema.stub!(:primary_key ).and_return(primary_key=mock)
      @schema.stub!(:relations   ).and_return(relations  =mock)
      @schema.stub!(:constraints ).and_return(constraints=mock)
      @schema.analyze_table[:table_name ].should == 'some_table'
      @schema.analyze_table[:columns    ].should == columns
      @schema.analyze_table[:primary_key].should == primary_key
      @schema.analyze_table[:relations  ].should == relations
      @schema.analyze_table[:constraints].should == constraints
    end
    
    it 'should have the correct table name' do
      @schema.table_name.should == 'some_table'
    end
  
    it 'should have the correct class name' do
      LegacyData::TableClassNameMapper.should_receive(:class_name_for).with('some_table').and_return('SomeClass')
      @schema.class_name.should == 'SomeClass'
    end
  
    it 'should have the correct primary_key' do
      @connection.should_receive(:pk_and_sequence_for).with('some_table').and_return(['PK', 'SEQ'])
      @schema.primary_key.should == 'PK'
    end
  
    it 'should have the names of all columns' do
      @schema.should_receive(:columns).and_return([col1=mock(:col1, :name=>'Col1'), col2=mock(:col2, :name=>'Col2')])
      @schema.column_names.sort.should == ['Col1', 'Col2'] 
    end
  
    describe 'relations' do
      it 'should have the different types of relations' do
        @schema.stub!(:belongs_to_relations).and_return([belongs_to=mock])
        @schema.stub!(:has_some_relations  ).and_return([has_some  =mock])

        @schema.relations.should == {:belongs_to=>[belongs_to], :has_many=>[has_some], :has_and_belongs_to_many=>{}}
      end

      
      it 'should give no "has_some" (has_many and has_one) relationships when the adapter does not support foreign keys' do
        @connection.should_receive(:respond_to?).with(:foreign_keys_of).and_return(false)
        @schema.has_some_relations.should == []
      end
  
      it 'should get all "has_some" (has_many and has_one) relationships when my primary key is the foreign key in another table ' do
        @connection.should_receive(:respond_to?).with(:foreign_keys_of).and_return(true)
        @connection.should_receive(:foreign_keys_of).and_return([ {:to_table=>'other_table', :foreign_key=>:pk, :dependent=>:destroy}, 
                                                                  {:to_table=>'the_table',   :foreign_key=>:pk, :dependent=>:destroy} ])
        @schema.has_some_relations.should == {'other_table' => {:foreign_key=>:pk, :dependent=>:destroy}, 
                                              'the_table' => {:foreign_key=>:pk, :dependent=>:destroy}}
      end
  
      it 'should give no "belongs_to" when the adapter does not support foreign keys' do
        @connection.should_receive(:respond_to?).with(:foreign_keys_for).and_return(false)
        @schema.belongs_to_relations.should == []
      end
  
      it 'should get all "belongs_to" relationships when a foreign key is in my table' do
        @connection.should_receive(:respond_to?).with(:foreign_keys_for).and_return(true)
        @connection.should_receive(:foreign_keys_for).and_return([['OTHER_TABLE', 'FK_1'], ['THE_TABLE', 'the_table_id']])
        @schema.belongs_to_relations.should == {'other_table' => {:foreign_key=>:fk_1        }, 
                                                'the_table'   => {:foreign_key=>:the_table_id} }
      end
    end

    describe 'constraints' do
      it 'should have the different types of constraints' do
        @schema.stub!(:unique_constraints      ).and_return([['unique_col'], ['col1', 'col2']])
        @schema.stub!(:non_nullable_constraints).and_return([non_nullable=mock               ])
        @schema.stub!(:custom_constraints      ).and_return([custom      =mock               ])

        @schema.constraints.should == {:unique=>[['unique_col']], :multi_column_unique=>[['col1', 'col2']], :non_nullable=>[non_nullable], :custom=>[custom]}
      end

      it 'should get non-nullable constraints as all columns that do not allow null except the primary key' do
        @schema.stub(:primary_key).and_return('col1')   
        @connection.should_receive(:columns).with('some_table', 'some_table Columns').and_return([col1=stub(:null=>false, :name=>'col1'), 
                                                                                                  col2=stub(:null=>false, :name=>'col2'),
                                                                                                  col3=stub(:null=>true,  :name=>'col3'),
                                                                                                  col3=stub(:null=>false, :name=>'col4')])
        @schema.non_nullable_constraints.should == ['col2', 'col4']
      end
  
      it 'should get uniqueness constraints' do
        @connection.should_receive(:indexes).with('some_table').and_return([idx1=stub(:unique=>true,  :columns=>['col1']), 
                                                                            idx2=stub(:unique=>false, :columns=>['col2']), 
                                                                            idx3=stub(:unique=>true,  :columns=>['col3', 'col4'])])
        @schema.unique_constraints.should == [['col1'], ['col3', 'col4']]
      end
    
      it 'should give no custom constraints when the adapter does not support it' do
        @connection.should_receive(:respond_to?).with(:constraints).and_return(false)
        @schema.custom_constraints.should == []
      end
  
      it 'should get all "belongs_to" relationships when a foreign key is in my table' do
        @connection.should_receive(:respond_to?).with(:constraints).and_return(true)
        @connection.should_receive(:constraints).and_return([['SomeConstraint', 'custom sql 1'], ['anotherconstraint', 'more custom sql']])
        @schema.custom_constraints.should == {:some_constraint => 'custom sql 1', :anotherconstraint => 'more custom sql'}
      end
    end  
  end
  
  describe 'convert join tables into HABTM relations' do
    before :each do
      LegacyData::Schema.clear_table_definitions
      LegacyData::Schema.table_definitions['posts'    ] = @posts_table         =mock(:posts,     :join_table? => false)
      LegacyData::Schema.table_definitions['tags'     ] = @tags_table          =mock(:tags,      :join_table? => false)
      LegacyData::Schema.table_definitions['tag_posts'] = @tag_posts_join_table=mock(:tag_posts, :join_table? => true )
    end

    it 'should remove the join table from the list of tables' do
      @tag_posts_join_table.stub!(:belongs_to_tables).and_return(['posts', 'tags'])
      @posts_table.should_receive(:convert_has_many_to_habtm).with(@tag_posts_join_table)
      @tags_table.should_receive( :convert_has_many_to_habtm).with(@tag_posts_join_table)

      analyzed_tables = LegacyData::Schema.remove_join_tables

      analyzed_tables.should      include(@posts_table, @tags_table)
      analyzed_tables.size.should == 2
    end
    
    it 'should find the next join table' do
      LegacyData::Schema.next_join_table.should == 'tag_posts'
    end

    it 'should know when there are no join tables' do
      LegacyData::Schema.table_definitions.delete('tag_posts')
      LegacyData::Schema.next_join_table.should == nil
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LegacyData::Schema do
  before :each do
    LegacyData::Schema.instance_variable_set('@conn', nil)
    ActiveRecord::Base.stub(:connection).and_return(@connection=stub(:connection))
  end

  it "should get a list of the tables from the database" do
    @connection.should_receive(:tables).and_return(['comments', 'people', 'posts'])
    LegacyData::Schema.tables.should == ['comments', 'people', 'posts']
  end

  it "should get a filtered list of the tables from the database" do
    @connection.should_receive(:tables).and_return(['comments', 'people', 'posts'])
    LegacyData::Schema.tables(/^p/).should == ['people', 'posts']
  end
  
  describe 'analyzing a table' do
    before :each do
      @schema = LegacyData::Schema.new('some_table')
    end
    
    it 'should have all the information about the table' do
      @schema.should_receive(:class_name)
      @schema.should_receive(:primary_key)
      @schema.should_receive(:relations)
      @schema.should_receive(:constraints)
  
      @schema.analyze_table.keys.should include(:table_name, :class_name, :primary_key, :relations, :constraints)
    end
    
    it 'should have the correct table name' do
      @schema.class_name[:table_name].should == 'some_table'
    end
  
    it 'should have the correct class name' do
      @schema.class_name.should == 'SomeClass'
    end
  
    it 'should have the correct primary_key' do
      @connection.should_receive(:pk_and_sequence_for).with('some_table').and_return(['PK', 'SEQ'])
      @schema.primary_key.should == 'PK'
    end
  
    it 'should give no "has_some" (has_many and has_one) relationships when the adapter does not support foreign keys' do
      @connection.should_receive(:respond_to?).with(:foreign_keys_of).and_return(false)
      @schema.has_some_relations.should == []
    end
  
    it 'should get all "has_some" (has_many and has_one) relationships when my primary key is the foreign key in another table ' do
      @connection.should_receive(:respond_to?).with(:foreign_keys_of).and_return(true)
      @connection.should_receive(:foreign_keys_of).and_return([['OTHER_TABLE', 'PK'], ['THE_TABLE', 'PK']])
      @schema.has_some_relations.should == {:othertables => :pk, :thetables => :pk}
    end
  
    it 'should give no "belongs_to" when the adapter does not support foreign keys' do
      @connection.should_receive(:respond_to?).with(:foreign_keys_for).and_return(false)
      @schema.belongs_to_relations.should == []
    end
  
    it 'should get all "belongs_to" relationships when a foreign key is in my table' do
      @connection.should_receive(:respond_to?).with(:foreign_keys_for).and_return(true)
      @connection.should_receive(:foreign_keys_for).and_return([['OTHER_TABLE', 'FK_1'], ['THE_TABLE', 'the_table_id']])
      @schema.belongs_to_relations.should == {:othertables => :fk_1, :thetables => :the_table_id}
    end
  
    it 'should have the correct constraints'

    it 'should get non-nullable constraints' do
      @connection.should_receive(:columns).with('some_table').and_return([col1=stub(:null=>false, :name=>'col1'), 
                                                                          col2=stub(:null=>true,  :name=>'col2'),
                                                                          col3=stub(:null=>false, :name=>'col3')])
      @schema.non_nullable_constraints.should == ['col1', 'col3']
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
      @connection.should_receive(:constraints).and_return([['Some Constraint', 'custom sql 1'], ['another constraint', 'more custom sql']])
      @schema.custom_constraints.should == {:some_constraint => 'custom sql 1', :another_constraint => 'more custom sql'}
    end
  
  end
end

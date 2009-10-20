require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyData::TableDefinition do
  [:table_name, :columns, :primary_key, :relations, :constraints].each do |option|
    it "should save the #{option} on initialization" do
      LegacyData::TableDefinition.new({option=>'some value'})[option].should == 'some value'
    end
    
    it 'should allow you to set class_name' do
      table_definition = LegacyData::TableDefinition.new({})
      table_definition.class_name = 'NewClassName'
      table_definition[:class_name].should == 'NewClassName'
    end
    
    it 'should reveal itself as a hash' do
      params = {}
      [:class_name, :table_name, :columns, :primary_key, :relations, :constraints].each { |field| params[field] = "#{field}_value" } 
      table_definition = LegacyData::TableDefinition.new(params)

      table_definition.to_hash.should == params.merge(:model => table_definition)
    end
  end
  
  describe 'join table' do
    before :each do
      @foreign_key_columns = [mock(:name=>'one_table_id'),  mock(:name=>'another_table_id') ]
      @belongs_to_relation = {'one_table'     => {:foreign_key=>:one_table_id    }, 
                              'another_table' => {:foreign_key=>:another_table_id} }
    end
    it 'should be a join table when it has only 2 columns and both are foreign keys' do
      table_definition = LegacyData::TableDefinition.new(:columns=>@foreign_key_columns,                       :relations=> {:belongs_to=>@belongs_to_relation})
      table_definition.should be_join_table
    end

    it 'should not be a join table when it has additional columns' do
      table_definition = LegacyData::TableDefinition.new(:columns=>@foreign_key_columns.push(:another_column), :relations=> {:belongs_to=>@belongs_to_relation})
      table_definition.should_not be_join_table
    end

    it 'should not be a join table when it does not have the belongs_to relation' do
      table_definition = LegacyData::TableDefinition.new(:columns=>@foreign_key_columns,                       :relations=> {})
      table_definition.should_not be_join_table
    end
    
    describe 'creating habtm' do
      before :each do
        @posts     = LegacyData::TableDefinition.new(:table_name=>'posts',     
                                                     :relations=>{:has_many               =>{'tag_posts' => {:foreign_key=>:posts_id} },
                                                                  :has_and_belongs_to_many=>{                                         } })
        @tags      = LegacyData::TableDefinition.new(:table_name=>'tags',      
                                                     :relations=>{:has_many               =>{'tag_posts' => {:foreign_key=>:tags_id } }, 
                                                                  :has_and_belongs_to_many=>{                                         } })
        @tag_posts = LegacyData::TableDefinition.new(:table_name=>'tag_posts', 
                                                     :relations=>{:belongs_to             =>{'posts'     => {:foreign_key=>:posts_id}, 
                                                                                             'tags'      => {:foreign_key=>:tags_id } } })
      end

      describe 'belonging to tables' do
        it 'should tell you when it does not' do
          @posts.belongs_to_tables.should == []
        end
        it 'should tell you when it belongs to 2 tables' do
          @tag_posts.belongs_to_tables.sort.should == ['posts', 'tags']
        end
      end
      it 'should convert a has_many into a habtm' do
        @posts.convert_has_many_to_habtm(@tag_posts)
        
        @posts.relations[:has_many               ].should == {}
        @posts.relations[:has_and_belongs_to_many].should == {'tags' => {:foreign_key=>:posts_id, :association_foreign_key=>:tags_id, :join_table=>:tag_posts} }
      end
    end
  end
end

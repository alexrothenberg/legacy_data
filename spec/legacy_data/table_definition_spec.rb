require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyData::TableDefinition do
  [:table_name, :columns, :primary_key, :relations, :constraints].each do |option|
    it "should save the #{option} on initialization" do
      LegacyData::TableDefinition.new({option=>'some value'})[option].should == 'some value'
    end
    
  end
  
  describe 'formatting for model' do
    describe 'relationships' do
      before :each do
        @table_definition = LegacyData::TableDefinition.new({})
      end
      
      it 'should format a hash for a has_many or belongs_to list' do
        @table_definition.options_to_s({:foreign_key=>:posts_id, :class_name=>'SomeClass'}).should == ':class_name => "SomeClass", :foreign_key => :posts_id'
      end
    end
    
    describe 'constraints' do
      it 'should generate  commented lines for multi column unique constraints' do
        table_definition = LegacyData::TableDefinition.new(:constraints => {:multi_column_unique => [[:author, :title], 
                                                                                                     [:address, :phone]]
                                                                      })
        table_definition.multi_column_unique_constraints_to_s.should == ["#validates_uniqueness_of_multiple_column_constraint [:author, :title]",
                                                                         "#validates_uniqueness_of_multiple_column_constraint [:address, :phone]"]
      end

      it 'should generate inclusion of constraints with a method returning possible values' do
        table_definition = LegacyData::TableDefinition.new(:constraints => {:inclusion_of => {:flag  => ['Y', 'N'],
                                                                                              :state => ['MA', 'NY']}
                                                                      })
        state_validation = <<-RB
  def self.possible_values_for_state
    ["MA", "NY"]
  end
  validates_inclusion_of :state,
                         :in      => possible_values_for_state, 
                         :message => "is not one of (\#{possible_values_for_state.join(', ')})"
        RB
        flag_validation = <<-RB
  def self.possible_values_for_flag
    ["Y", "N"]
  end
  validates_inclusion_of :flag,
                         :in      => possible_values_for_flag, 
                         :message => "is not one of (\#{possible_values_for_flag.join(', ')})"
        RB
        table_definition.inclusion_of_constraints_to_s.should include(state_validation, flag_validation)
        table_definition.inclusion_of_constraints_to_s.size.should == 2
      end

      it 'should generate inclusion of constraints with a method returning possible values' do
        table_definition = LegacyData::TableDefinition.new(:constraints => {:custom => {:my_constraint => "some plsql logic",
                                                                                        :another_one   => "multi\nline\n  plsql logic"}
                                                                      })
        table_definition.custom_constraints_to_s.should include(<<-RB )
  validate :validate_my_constraint
  def validate_my_constraint
    # TODO: validate this SQL constraint
    <<-SQL
      some plsql logic
    SQL
  end
        RB
        table_definition.custom_constraints_to_s.should include(<<-RB)
  validate :validate_another_one
  def validate_another_one
    # TODO: validate this SQL constraint
    <<-SQL
      multi
line
  plsql logic
    SQL
  end
        RB
      end

      describe 'numericality constraints' do
        before :each do
          @table_definition = LegacyData::TableDefinition.new(:constraints => {:numericality_of => {:allow_nil        => ['col1', 'col2'],
                                                                                                   :do_not_allow_nil => ['col3', 'col4']}
                                                                               }
                                                              )
        end
        it 'should generate numericality constraints for those that allow nil and those that do not' do
          @table_definition.numericality_of_constraints_to_s.should == ["validates_numericality_of :col1, :col2, {:allow_nil=>true}", 
                                                                        "validates_numericality_of :col3, :col4"]
        end

        it 'should not fail when there are no nullable constraints' do
          @table_definition.constraints[:numericality_of][:allow_nil] = nil
          @table_definition.numericality_of_constraints_to_s.should == [[], 
                                                                        "validates_numericality_of :col3, :col4"]
        end

        it 'should not fail when there are no non-nullable constraints' do
          @table_definition.constraints[:numericality_of][:do_not_allow_nil] = nil
          @table_definition.numericality_of_constraints_to_s.should == ["validates_numericality_of :col1, :col2, {:allow_nil=>true}", 
                                                                        []]
        end

        it 'should not fail when there are no nullable or non-nullable constraints' do
          @table_definition.constraints[:numericality_of][:allow_nil]        = nil
          @table_definition.constraints[:numericality_of][:do_not_allow_nil] = nil
          @table_definition.numericality_of_constraints_to_s.should == [[], 
                                                                        []]
        end
      end
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

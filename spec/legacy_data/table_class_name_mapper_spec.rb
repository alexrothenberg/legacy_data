require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyData::TableClassNameMapper do
  before :each do
    LegacyData::TableClassNameMapper.clear_dictionary 
  end

  describe 'without an input dictionary' do
    before :each do
      LegacyData::TableClassNameMapper.instance.stub!(:load_dictionary).and_return({})
    end
    
    describe 'without any naming convention' do
      before :each do
        LegacyData::TableClassNameMapper.naming_convention = nil
      end

      it 'should handle tables with a singular name that ends with s' do
        LegacyData::TableClassNameMapper.class_name_for('ADDRESS').should == 'Address'
      end

      it 'should handle tables with an irregular pluralization name' do
        LegacyData::TableClassNameMapper.class_name_for('TBPERSON').should == 'Tbperson'
      end

      it 'should work on tables that do not have the prefix' do
        LegacyData::TableClassNameMapper.class_name_for('PERSON').should == 'Person'
      end
    end
    
    describe "with a 'tables start with TB' naming convention" do
      before :each do
        LegacyData::TableClassNameMapper.naming_convention = 'TB*'
      end

      it 'should use the wildcard portion when the naming convention applied' do
        LegacyData::TableClassNameMapper.class_name_for('TBPERSON').should == 'Person'
      end

      it 'should use the full table name when the naming convention does not match' do
        LegacyData::TableClassNameMapper.class_name_for('PERSON').should == 'Person'
      end
    end
  end
  
  describe 'with an input dictionary' do
    before :each do
      LegacyData::TableClassNameMapper.instance.stub!(:load_dictionary).and_return({'some_table' => 'CustomClassName'})
    end

    it 'should use the dictionary mapping when one exists' do
      LegacyData::TableClassNameMapper.class_name_for('some_table').should == 'CustomClassName'
    end

    it 'should use the algorithm when no dictionary mapping  exists' do
      LegacyData::TableClassNameMapper.class_name_for('ANOTHER_TABLE').should == 'AnotherTable'
    end
  end
  
  describe 'persisting the dictionary' do
    before :each do
      silence_warnings { RAILS_ROOT = 'test_rails_root' }
      @dictionary_file_name = LegacyData::TableClassNameMapper.dictionary_file_name
    end
    after :each do
      Object.send(:remove_const, :RAILS_ROOT) if RAILS_ROOT=='test_rails_root'
    end

    it 'should load the dictionary from a file' do
      File.should_receive(:exists?  ).with(@dictionary_file_name).and_return(true)
      YAML.should_receive(:load_file).with(@dictionary_file_name).and_return(dictionary_from_file=mock)
      
      LegacyData::TableClassNameMapper.dictionary.should == dictionary_from_file
    end

    it 'should give empty dictionary when file does not exist' do
      File.should_receive(:exists?  ).with(@dictionary_file_name).and_return(false)
      
      LegacyData::TableClassNameMapper.dictionary.should == {}
    end

    it 'should save the dictionary to a file' do
      File.should_receive(:open).with(@dictionary_file_name, 'w').and_yield(file=mock) 
      LegacyData::TableClassNameMapper.instance.should_receive(:dictionary).and_return(dictionary=mock)
      YAML.should_receive(:dump).with(dictionary, file).and_return(yaml_dictionary=mock)
      
      LegacyData::TableClassNameMapper.save_dictionary
    end

  end
end    

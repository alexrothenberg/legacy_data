require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyData::TableClassNameMapper do
  describe 'computing class names without an input dictionary' do
    before :each do
      LegacyData::TableClassNameMapper.instance.stub!(:load_dictionary).and_return({})
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
end    

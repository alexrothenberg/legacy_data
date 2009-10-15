class FilterFormat < ActiveRecord::Base
  set_table_name :filter_formats
  set_primary_key :format
  
  # Relationships

  # Constraints
  validates_uniqueness_of :name
  validates_presence_of :name, :roles, :cache
  validates_numericality_of :cache
end

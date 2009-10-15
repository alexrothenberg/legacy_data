class Filter < ActiveRecord::Base
  set_table_name :filters
  set_primary_key :fid
  
  # Relationships

  # Constraints
  
  #validates_uniqueness_of_multiple_column_constraint :["format", "module", "delta"]
  validates_presence_of :format, :module, :delta, :weight
  validates_numericality_of :format, :delta, :weight
end


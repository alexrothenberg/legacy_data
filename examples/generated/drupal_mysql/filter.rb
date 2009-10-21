class Filter < ActiveRecord::Base
  
  set_primary_key :fid
  
  # Relationships
  

  # Constraints
  #validates_uniqueness_of_multiple_column_constraint ["format", "module", "delta"]
  validates_numericality_of :format, :delta, :weight
  validates_presence_of :format, :module, :delta, :weight
end


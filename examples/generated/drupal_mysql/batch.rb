class Batch < ActiveRecord::Base
  set_table_name  :batch
  set_primary_key :bid
  
  # Relationships
  

  # Constraints
  validates_presence_of :token, :timestamp
  validates_numericality_of :timestamp
end


class Batch < ActiveRecord::Base
  set_table_name  :batch
  set_primary_key :bid
  
  # Relationships
  

  # Constraints
  validates_numericality_of :timestamp
  validates_presence_of :token, :timestamp
end


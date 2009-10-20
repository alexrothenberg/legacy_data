class Box < ActiveRecord::Base
  
  set_primary_key :bid
  
  # Relationships
  

  # Constraints
  validates_uniqueness_of :info
  validates_presence_of :info, :format
  validates_numericality_of :format
end


class Box < ActiveRecord::Base
  set_primary_key :bid

  # Relationships
  

  # Constraints
  validates_numericality_of :format
  validates_presence_of :info, :format
  validates_uniqueness_of :info
end


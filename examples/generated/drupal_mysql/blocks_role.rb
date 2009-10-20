class BlocksRole < ActiveRecord::Base
  
  
  
  # Relationships
  

  # Constraints
  validates_presence_of :module, :delta, :rid
  validates_numericality_of :rid
end


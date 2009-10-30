class BlocksRole < ActiveRecord::Base
  set_primary_key :no_primary_key

  # Relationships
  

  # Constraints
  validates_numericality_of :rid
  validates_presence_of :module, :delta, :rid
end


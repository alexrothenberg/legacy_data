class BlocksRole < ActiveRecord::Base
  set_table_name :blocks_roles
  
  
  # Relationships

  # Constraints
  
  validates_presence_of :module, :delta, :rid
  validates_numericality_of :rid
end


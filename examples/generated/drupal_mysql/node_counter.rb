class NodeCounter < ActiveRecord::Base
  set_table_name  :node_counter
  set_primary_key :nid
  
  # Relationships
  

  # Constraints
  validates_presence_of :totalcount, :daycount, :timestamp
  validates_numericality_of :totalcount, :daycount, :timestamp
end


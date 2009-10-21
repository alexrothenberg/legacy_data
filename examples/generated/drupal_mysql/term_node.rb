class TermNode < ActiveRecord::Base
  set_table_name  :term_node
  set_primary_key :no_primary_key
  
  # Relationships
  

  # Constraints
  validates_numericality_of :nid, :vid, :tid
  validates_presence_of :nid, :vid, :tid
end


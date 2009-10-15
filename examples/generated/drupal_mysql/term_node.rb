class TermNode < ActiveRecord::Base
  set_table_name :term_node
  
  
  # Relationships

  # Constraints
  
  validates_presence_of :nid, :vid, :tid
  validates_numericality_of :nid, :vid, :tid
end


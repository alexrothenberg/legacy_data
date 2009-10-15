class TermHierarchy < ActiveRecord::Base
  set_table_name :term_hierarchy
  
  
  # Relationships

  # Constraints
  
  validates_presence_of :tid, :parent
  validates_numericality_of :tid, :parent
end


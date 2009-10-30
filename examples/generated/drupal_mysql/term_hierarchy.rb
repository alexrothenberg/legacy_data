class TermHierarchy < ActiveRecord::Base
  set_table_name  :term_hierarchy
  set_primary_key :no_primary_key

  # Relationships
  

  # Constraints
  validates_numericality_of :tid, :parent
  validates_presence_of :tid, :parent
end


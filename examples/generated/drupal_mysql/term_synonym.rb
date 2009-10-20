class TermSynonym < ActiveRecord::Base
  set_table_name  :term_synonym
  set_primary_key :tsid
  
  # Relationships
  

  # Constraints
  validates_presence_of :tid, :name
  validates_numericality_of :tid
end


class TermSynonym < ActiveRecord::Base
  set_table_name  :term_synonym
  set_primary_key :tsid
  
  # Relationships
  

  # Constraints
  validates_numericality_of :tid
  validates_presence_of :tid, :name
end


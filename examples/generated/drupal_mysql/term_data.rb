class TermData < ActiveRecord::Base
  set_table_name  :term_data
  set_primary_key :tid
  
  # Relationships
  

  # Constraints
  validates_presence_of :vid, :name, :weight
  validates_numericality_of :vid, :weight
end


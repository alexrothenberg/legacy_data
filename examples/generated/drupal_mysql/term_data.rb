class TermData < ActiveRecord::Base
  set_table_name  :term_data
  set_primary_key :tid

  # Relationships
  

  # Constraints
  validates_numericality_of :vid, :weight
  validates_presence_of :vid, :name, :weight
end


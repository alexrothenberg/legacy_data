class TermRelation < ActiveRecord::Base
  set_table_name  :term_relation
  set_primary_key :trid

  # Relationships
  

  # Constraints
  #validates_uniqueness_of_multiple_column_constraint ["tid1", "tid2"]
  validates_numericality_of :tid1, :tid2
  validates_presence_of :tid1, :tid2
end


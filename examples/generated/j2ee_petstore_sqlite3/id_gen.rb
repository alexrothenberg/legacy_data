class IdGen < ActiveRecord::Base
  set_table_name  :id_gen
  set_primary_key :gen_key

  # Relationships
  

  # Constraints
  validates_numericality_of :gen_value
  validates_presence_of :gen_value
  validates_uniqueness_of :gen_key
end


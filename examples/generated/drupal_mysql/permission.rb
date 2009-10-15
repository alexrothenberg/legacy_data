class Permission < ActiveRecord::Base
  set_table_name :permission
  set_primary_key :pid
  
  # Relationships

  # Constraints
  
  validates_presence_of :rid, :tid
  validates_numericality_of :rid, :tid
end


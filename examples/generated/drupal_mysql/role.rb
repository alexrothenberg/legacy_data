class Role < ActiveRecord::Base
  set_table_name :role
  set_primary_key :rid
  
  # Relationships

  # Constraints
  validates_uniqueness_of :name
  validates_presence_of :name
end


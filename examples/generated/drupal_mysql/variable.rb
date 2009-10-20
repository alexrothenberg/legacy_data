class Variable < ActiveRecord::Base
  set_table_name  :variable
  set_primary_key :name
  
  # Relationships
  

  # Constraints
  validates_presence_of :value
end


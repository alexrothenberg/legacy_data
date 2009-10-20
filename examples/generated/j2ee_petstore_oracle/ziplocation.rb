class Ziplocation < ActiveRecord::Base
  set_table_name  :ziplocation
  set_primary_key :zipcode
  
  # Relationships
  

  # Constraints
  validates_presence_of :city, :state
end


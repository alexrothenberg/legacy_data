class Product < ActiveRecord::Base
  set_table_name  :product
  set_primary_key :productid
  
  # Relationships
  

  # Constraints
  validates_presence_of :categoryid, :name, :description
  validates_uniqueness_of :productid
end


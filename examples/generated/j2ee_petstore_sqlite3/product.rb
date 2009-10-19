class Product < ActiveRecord::Base
  set_table_name :product
  set_primary_key :productid
  
  # Relationships

  # Constraints
  validates_uniqueness_of :productid
  validates_presence_of :categoryid, :name, :description
end


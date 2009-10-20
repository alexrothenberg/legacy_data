class Category < ActiveRecord::Base
  set_table_name  :category
  set_primary_key :categoryid
  
  # Relationships
  

  # Constraints
  validates_uniqueness_of :categoryid
  validates_presence_of :name, :description
end


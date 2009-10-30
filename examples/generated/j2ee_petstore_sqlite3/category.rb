class Category < ActiveRecord::Base
  set_table_name  :category
  set_primary_key :categoryid

  # Relationships
  

  # Constraints
  validates_presence_of :name, :description
  validates_uniqueness_of :categoryid
end


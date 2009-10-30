class Category < ActiveRecord::Base
  set_table_name  :category
  set_primary_key :categoryid

  # Relationships
  has_many :products, :foreign_key => :categoryid

  # Constraints
  validates_presence_of :name, :description
end


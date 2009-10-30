class Product < ActiveRecord::Base
  set_table_name  :product
  set_primary_key :productid

  # Relationships
  has_many :items, :foreign_key => :productid
  belongs_to :category, :foreign_key => :categoryid

  # Constraints
  validates_presence_of :categoryid, :name, :description
end


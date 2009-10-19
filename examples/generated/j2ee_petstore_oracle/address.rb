class Address < ActiveRecord::Base
  set_table_name :address
  set_primary_key :addressid
  
  # Relationships
  has_many :items, :foreign_key => :address_addressid

  # Constraints
  
  validates_presence_of :street1, :city, :state, :zip, :latitude, :longitude
end


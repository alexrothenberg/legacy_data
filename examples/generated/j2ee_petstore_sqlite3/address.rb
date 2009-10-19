class Address < ActiveRecord::Base
  set_table_name :address
  set_primary_key :addressid
  
  # Relationships

  # Constraints
  validates_uniqueness_of :addressid
  validates_presence_of :street1, :city, :state, :zip, :latitude, :longitude
end


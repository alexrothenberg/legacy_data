class Item < ActiveRecord::Base
  set_table_name  :item
  set_primary_key :itemid
  
  # Relationships
  

  # Constraints
  validates_presence_of :productid, :name, :description, :price, :address_addressid, :contactinfo_contactinfoid, :totalscore, :numberofvotes, :disabled
  validates_numericality_of :totalscore, :numberofvotes, :disabled
end


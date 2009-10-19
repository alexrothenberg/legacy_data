class SellerContactInfo < ActiveRecord::Base
  set_table_name :sellercontactinfo
  set_primary_key :contactinfoid
  
  # Relationships

  # Constraints
  
  validates_presence_of :lastname, :firstname, :email
end


class Sellercontactinfo < ActiveRecord::Base
  set_table_name  :sellercontactinfo
  set_primary_key :contactinfoid

  # Relationships
  has_many :items, :foreign_key => :contactinfo_contactinfoid

  # Constraints
  validates_presence_of :lastname, :firstname, :email
end


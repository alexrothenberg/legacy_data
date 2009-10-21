class Item < ActiveRecord::Base
  set_table_name  :item
  set_primary_key :itemid
  
  # Relationships
  belongs_to :address,           :foreign_key => :address_addressid
  belongs_to :product,           :foreign_key => :productid
  belongs_to :sellercontactinfo, :foreign_key => :contactinfo_contactinfoid
  has_and_belongs_to_many :tags, :association_foreign_key => :tagid, :foreign_key => :itemid, :join_table => :tag_item

  # Constraints
  validates_numericality_of :totalscore, :numberofvotes, :disabled
  validates_presence_of :productid, :name, :description, :price, :address_addressid, :contactinfo_contactinfoid, :totalscore, :numberofvotes, :disabled
end


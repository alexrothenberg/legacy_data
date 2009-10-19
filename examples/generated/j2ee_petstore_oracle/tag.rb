class Tag < ActiveRecord::Base
  set_table_name :tag
  set_primary_key :tagid
  
  # Relationships
  has_and_belongs_to_many :items, :association_foreign_key => :itemid, :foreign_key => :tagid, :join_table => :tag_item

  # Constraints
  validates_uniqueness_of :tag
  validates_presence_of :tag, :refcount
  validates_numericality_of :refcount
end


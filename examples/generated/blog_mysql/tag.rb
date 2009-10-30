class Tag < ActiveRecord::Base

  # Relationships
  has_and_belongs_to_many :posts, :association_foreign_key => :post_id, :foreign_key => :tag_id, :join_table => :post_tags

  # Constraints
  
end


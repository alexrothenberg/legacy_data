class Tag < ActiveRecord::Base
  set_table_name :tags
  set_primary_key :id
  
  # Relationships
  has_and_belongs_to_many :posts, :association_foreign_key => :post_id, :foreign_key => :tag_id, :join_table => :post_tags

  # Constraints
  
  
end


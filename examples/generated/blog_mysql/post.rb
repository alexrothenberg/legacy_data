class Post < ActiveRecord::Base
  set_table_name :posts
  set_primary_key :id
  
  # Relationships
  has_and_belongs_to_many :tags, :join_table => :post_tags, :association_foreign_key => :tag_id, :foreign_key => :post_id

  # Constraints
  
  
end


class Post < ActiveRecord::Base
  set_table_name :posts
  set_primary_key :id
  
  # Relationships
  has_many :comments, :foreign_key => :comment_id

  # Constraints
  validates_uniqueness_of :title
  validates_presence_of :body
end


class Post < ActiveRecord::Base
  
  
  
  # Relationships
  has_many :comments, :foreign_key => :comment_id

  # Constraints
  validates_uniqueness_of :title
  validates_presence_of :body
end


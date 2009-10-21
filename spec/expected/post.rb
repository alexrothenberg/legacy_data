class Post < ActiveRecord::Base
  
  
  
  # Relationships
  has_many :comments, :foreign_key => :comment_id

  # Constraints
  validates_presence_of :body
  validates_uniqueness_of :title
end


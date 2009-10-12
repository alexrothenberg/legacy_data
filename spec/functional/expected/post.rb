class Post < ActiveRecord::Base
  set_table_name :posts
  set_primary_key :id
  
  # Relationships

  # Constraints
  
  
  validates_numericality_of :id
end


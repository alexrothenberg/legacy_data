class Comment < ActiveRecord::Base
  set_table_name :comments
  set_primary_key :id
  
  # Relationships

  # Constraints
  
  
  validates_numericality_of :id, :post_id

end


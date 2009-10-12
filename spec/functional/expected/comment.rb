class Comment < ActiveRecord::Base
  set_table_name :comments
  set_primary_key :id
  
  # Relationships

  # Constraints
  
  
  validates_numericality_of :post_id, {:allow_nil=>true}
  validates_numericality_of :id
end


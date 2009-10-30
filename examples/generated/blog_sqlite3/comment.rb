class Comment < ActiveRecord::Base

  # Relationships
  

  # Constraints
  validates_numericality_of :post_id, {:allow_nil=>true}
end


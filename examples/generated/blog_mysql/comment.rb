class Comment < ActiveRecord::Base
  
  
  
  # Relationships
  belongs_to :post, :dependent => :destroy, :foreign_key => :post_id

  # Constraints
  validates_numericality_of :post_id, {:allow_nil=>true}
end


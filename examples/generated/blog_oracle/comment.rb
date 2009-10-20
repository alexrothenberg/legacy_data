class Comment < ActiveRecord::Base
  set_table_name  :comments
  set_primary_key :id
  
  # Relationships
  belongs_to :post, :dependent => :destroy, :foreign_key => :post_id

  # Constraints
  
  
  validates_numericality_of :post_id, {:allow_nil=>true}
end


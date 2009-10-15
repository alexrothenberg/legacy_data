class Comment < ActiveRecord::Base
  set_table_name :comments
  set_primary_key :id
  
  # Relationships
  belongs_to :post, :foreign_key => :post_id, :dependent => :destroy

  # Constraints
  
  
  validates_numericality_of :post_id, {:allow_nil=>true}
end


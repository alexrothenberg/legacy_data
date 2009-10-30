class TagItem < ActiveRecord::Base
  set_table_name  :tag_item
  
  # Relationships
  

  # Constraints
  #validates_uniqueness_of_multiple_column_constraint ["tagid", "itemid"]
  validates_presence_of :tagid, :itemid
  validates_numericality_of :tagid
end


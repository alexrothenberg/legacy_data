class Tag < ActiveRecord::Base
  set_table_name :tag
  set_primary_key :tagid
  
  # Relationships

  # Constraints
  validates_uniqueness_of :tag
  validates_presence_of :tag, :refcount
  validates_numericality_of :refcount
end


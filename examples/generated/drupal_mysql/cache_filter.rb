class CacheFilter < ActiveRecord::Base
  set_table_name  :cache_filter
  set_primary_key :cid
  
  # Relationships
  

  # Constraints
  validates_presence_of :expire, :created, :serialized
  validates_numericality_of :expire, :created, :serialized
end


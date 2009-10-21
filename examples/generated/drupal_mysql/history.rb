class History < ActiveRecord::Base
  set_table_name  :history
  set_primary_key :no_primary_key
  
  # Relationships
  

  # Constraints
  validates_numericality_of :uid, :nid, :timestamp
  validates_presence_of :uid, :nid, :timestamp
end


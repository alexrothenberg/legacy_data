class History < ActiveRecord::Base
  set_table_name :history
  
  
  # Relationships

  # Constraints
  
  validates_presence_of :uid, :nid, :timestamp
  validates_numericality_of :uid, :nid, :timestamp
end


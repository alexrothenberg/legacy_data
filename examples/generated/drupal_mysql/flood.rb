class Flood < ActiveRecord::Base
  set_table_name :flood
  set_primary_key :fid
  
  # Relationships

  # Constraints
  
  validates_presence_of :event, :hostname, :timestamp
  validates_numericality_of :timestamp
end


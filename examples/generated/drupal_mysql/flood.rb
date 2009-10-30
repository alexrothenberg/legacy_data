class Flood < ActiveRecord::Base
  set_table_name  :flood
  set_primary_key :fid

  # Relationships
  

  # Constraints
  validates_numericality_of :timestamp
  validates_presence_of :event, :hostname, :timestamp
end


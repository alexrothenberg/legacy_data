class Watchdog < ActiveRecord::Base
  set_table_name  :watchdog
  set_primary_key :wid
  
  # Relationships
  

  # Constraints
  validates_presence_of :uid, :type, :message, :variables, :severity, :link, :location, :hostname, :timestamp
  validates_numericality_of :uid, :severity, :timestamp
end


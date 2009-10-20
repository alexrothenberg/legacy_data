class Session < ActiveRecord::Base
  
  set_primary_key :sid
  
  # Relationships
  

  # Constraints
  validates_presence_of :uid, :hostname, :timestamp, :cache
  validates_numericality_of :uid, :timestamp, :cache
end


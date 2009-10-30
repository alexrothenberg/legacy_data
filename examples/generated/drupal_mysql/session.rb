class Session < ActiveRecord::Base
  set_primary_key :sid

  # Relationships
  

  # Constraints
  validates_numericality_of :uid, :timestamp, :cache
  validates_presence_of :uid, :hostname, :timestamp, :cache
end


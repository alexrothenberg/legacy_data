class Comment < ActiveRecord::Base
  set_primary_key :cid

  # Relationships
  

  # Constraints
  validates_numericality_of :pid, :nid, :uid, :timestamp, :status, :format
  validates_presence_of :pid, :nid, :uid, :subject, :comment, :hostname, :timestamp, :status, :format, :thread
end


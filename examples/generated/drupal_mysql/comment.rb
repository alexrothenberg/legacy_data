class Comment < ActiveRecord::Base
  set_table_name :comments
  set_primary_key :cid
  
  # Relationships

  # Constraints
  
  validates_presence_of :pid, :nid, :uid, :subject, :comment, :hostname, :timestamp, :status, :format, :thread
  validates_numericality_of :pid, :nid, :uid, :timestamp, :status, :format
end


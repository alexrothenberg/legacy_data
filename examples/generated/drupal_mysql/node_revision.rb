class NodeRevision < ActiveRecord::Base
  
  set_primary_key :vid
  
  # Relationships
  

  # Constraints
  validates_numericality_of :nid, :uid, :timestamp, :format
  validates_presence_of :nid, :uid, :title, :body, :teaser, :log, :timestamp, :format
end


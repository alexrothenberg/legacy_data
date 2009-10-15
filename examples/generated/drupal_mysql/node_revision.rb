class NodeRevision < ActiveRecord::Base
  set_table_name :node_revisions
  set_primary_key :vid
  
  # Relationships

  # Constraints
  
  validates_presence_of :nid, :uid, :title, :body, :teaser, :log, :timestamp, :format
  validates_numericality_of :nid, :uid, :timestamp, :format
end


class NodeAccess < ActiveRecord::Base
  set_table_name  :node_access
  
  
  # Relationships
  

  # Constraints
  validates_presence_of :nid, :gid, :realm, :grant_view, :grant_update, :grant_delete
  validates_numericality_of :nid, :gid, :grant_view, :grant_update, :grant_delete
end


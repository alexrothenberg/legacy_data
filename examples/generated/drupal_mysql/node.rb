class Node < ActiveRecord::Base
  set_table_name  :node
  set_primary_key :nid

  # Relationships
  

  # Constraints
  validates_numericality_of :vid, :uid, :status, :created, :changed, :comment, :promote, :moderate, :sticky, :tnid, :translate
  validates_presence_of :vid, :type, :language, :title, :uid, :status, :created, :changed, :comment, :promote, :moderate, :sticky, :tnid, :translate
  validates_uniqueness_of :vid
end


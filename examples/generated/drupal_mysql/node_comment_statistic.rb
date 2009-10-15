class NodeCommentStatistic < ActiveRecord::Base
  set_table_name :node_comment_statistics
  set_primary_key :nid
  
  # Relationships

  # Constraints
  
  validates_presence_of :last_comment_timestamp, :last_comment_uid, :comment_count
  validates_numericality_of :last_comment_timestamp, :last_comment_uid, :comment_count
end


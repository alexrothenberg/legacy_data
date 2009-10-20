class NodeType < ActiveRecord::Base
  set_table_name  :node_type
  set_primary_key :type
  
  # Relationships
  

  # Constraints
  validates_presence_of :name, :module, :description, :help, :has_title, :title_label, :has_body, :body_label, :min_word_count, :custom, :modified, :locked, :orig_type
  validates_numericality_of :has_title, :has_body, :min_word_count, :custom, :modified, :locked
end


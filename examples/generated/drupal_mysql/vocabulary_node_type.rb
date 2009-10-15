class VocabularyNodeType < ActiveRecord::Base
  set_table_name :vocabulary_node_types
  
  
  # Relationships

  # Constraints
  
  validates_presence_of :vid, :type
  validates_numericality_of :vid
end


class VocabularyNodeType < ActiveRecord::Base
  
  
  
  # Relationships
  

  # Constraints
  validates_presence_of :vid, :type
  validates_numericality_of :vid
end


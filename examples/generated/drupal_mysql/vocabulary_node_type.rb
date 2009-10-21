class VocabularyNodeType < ActiveRecord::Base
  
  set_primary_key :no_primary_key
  
  # Relationships
  

  # Constraints
  validates_presence_of :vid, :type
  validates_numericality_of :vid
end


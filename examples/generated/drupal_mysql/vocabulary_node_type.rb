class VocabularyNodeType < ActiveRecord::Base
  
  set_primary_key :no_primary_key
  
  # Relationships
  

  # Constraints
  validates_numericality_of :vid
  validates_presence_of :vid, :type
end


class Vocabulary < ActiveRecord::Base
  set_table_name  :vocabulary
  set_primary_key :vid
  
  # Relationships
  

  # Constraints
  validates_numericality_of :relations, :hierarchy, :multiple, :required, :tags, :weight
  validates_presence_of :name, :help, :relations, :hierarchy, :multiple, :required, :tags, :module, :weight
end


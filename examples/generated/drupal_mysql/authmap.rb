class Authmap < ActiveRecord::Base
  set_table_name  :authmap
  set_primary_key :aid
  
  # Relationships
  

  # Constraints
  validates_uniqueness_of :authname
  validates_presence_of :uid, :authname, :module
  validates_numericality_of :uid
end


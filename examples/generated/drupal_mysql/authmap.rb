class Authmap < ActiveRecord::Base
  set_table_name  :authmap
  set_primary_key :aid
  
  # Relationships
  

  # Constraints
  validates_numericality_of :uid
  validates_presence_of :uid, :authname, :module
  validates_uniqueness_of :authname
end


class UsersRole < ActiveRecord::Base
  
  set_primary_key :no_primary_key
  
  # Relationships
  

  # Constraints
  validates_presence_of :uid, :rid
  validates_numericality_of :uid, :rid
end


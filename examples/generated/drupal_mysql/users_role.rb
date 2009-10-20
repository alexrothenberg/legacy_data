class UsersRole < ActiveRecord::Base
  
  
  
  # Relationships
  

  # Constraints
  validates_presence_of :uid, :rid
  validates_numericality_of :uid, :rid
end


class UsersRole < ActiveRecord::Base
  set_table_name :users_roles
  
  
  # Relationships

  # Constraints
  
  validates_presence_of :uid, :rid
  validates_numericality_of :uid, :rid
end


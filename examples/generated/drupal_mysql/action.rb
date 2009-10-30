class Action < ActiveRecord::Base
  set_primary_key :aid

  # Relationships
  

  # Constraints
  validates_presence_of :type, :callback, :parameters, :description
end


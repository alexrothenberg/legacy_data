class FilterFormat < ActiveRecord::Base
  set_primary_key :format

  # Relationships
  

  # Constraints
  validates_numericality_of :cache
  validates_presence_of :name, :roles, :cache
  validates_uniqueness_of :name
end


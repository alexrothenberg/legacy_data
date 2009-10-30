class Access < ActiveRecord::Base
  set_table_name  :access
  set_primary_key :aid

  # Relationships
  

  # Constraints
  validates_numericality_of :status
  validates_presence_of :mask, :type, :status
end


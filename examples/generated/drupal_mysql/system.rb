class System < ActiveRecord::Base
  set_table_name :system
  set_primary_key :filename
  
  # Relationships

  # Constraints
  
  validates_presence_of :name, :type, :owner, :status, :throttle, :bootstrap, :schema_version, :weight
  validates_numericality_of :status, :throttle, :bootstrap, :schema_version, :weight
end


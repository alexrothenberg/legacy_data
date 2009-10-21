class Block < ActiveRecord::Base
  
  set_primary_key :bid
  
  # Relationships
  

  # Constraints
  #validates_uniqueness_of_multiple_column_constraint ["theme", "module", "delta"]
  validates_numericality_of :status, :weight, :custom, :throttle, :visibility, :cache
  validates_presence_of :module, :delta, :theme, :status, :weight, :region, :custom, :throttle, :visibility, :pages, :title, :cache
end


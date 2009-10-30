class MenuCustom < ActiveRecord::Base
  set_table_name  :menu_custom
  set_primary_key :menu_name

  # Relationships
  

  # Constraints
  validates_presence_of :title
end


class MenuRouter < ActiveRecord::Base
  set_table_name :menu_router
  set_primary_key :path
  
  # Relationships

  # Constraints
  
  validates_presence_of :load_functions, :to_arg_functions, :access_callback, :page_callback, :fit, :number_parts, :tab_parent, :tab_root, :title, :title_callback, :title_arguments, :type, :block_callback, :description, :position, :weight
  validates_numericality_of :fit, :number_parts, :type, :weight
end


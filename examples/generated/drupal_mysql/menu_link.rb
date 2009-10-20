class MenuLink < ActiveRecord::Base
  
  set_primary_key :mlid
  
  # Relationships
  

  # Constraints
  validates_presence_of :menu_name, :plid, :link_path, :router_path, :link_title, :module, :hidden, :external, :has_children, :expanded, :weight, :depth, :customized, :p1, :p2, :p3, :p4, :p5, :p6, :p7, :p8, :p9, :updated
  validates_numericality_of :plid, :hidden, :external, :has_children, :expanded, :weight, :depth, :customized, :p1, :p2, :p3, :p4, :p5, :p6, :p7, :p8, :p9, :updated
end


class UrlAlias < ActiveRecord::Base
  set_table_name :url_alias
  set_primary_key :pid
  
  # Relationships

  # Constraints
  
  #validates_uniqueness_of_multiple_column_constraint :["dst", "language"]
  validates_presence_of :src, :dst, :language
end


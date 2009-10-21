class UploadedFiles < ActiveRecord::Base
  set_table_name  :files
  set_primary_key :fid
  
  # Relationships
  

  # Constraints
  validates_numericality_of :uid, :filesize, :status, :timestamp
  validates_presence_of :uid, :filename, :filepath, :filemime, :filesize, :status, :timestamp
end


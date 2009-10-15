require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def initialize_connection connection_info
  ActiveRecord::Base.clear_all_connections!
  ActiveRecord::Base.establish_connection(connection_info)

  begin
    require "foreigner/connection_adapters/#{ActiveRecord::Base.connection.adapter_name.downcase}_adapter"
  rescue LoadError
    #foreigner does not support all adapters (i.e. sqlite3)
  end
  
end
  

def create_blog_tables connection_info
  initialize_connection connection_info

  connection = ActiveRecord::Base.connection
  
  connection.drop_table :comments  if connection.table_exists? :comments
  connection.drop_table :posts     if connection.table_exists? :posts

  connection.create_table :posts do |t|
    t.string :title
    t.text   :body
  end
  connection.create_table :comments do |t|
    t.integer     :post_id
    t.foreign_key :posts,    :dependent => :delete
    t.text        :body
  end
  
  puts "createing blog tables for #{connection}"
end


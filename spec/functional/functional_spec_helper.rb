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
  
  [:post_tags, :comments, :posts, :tags].each do |table|
    connection.drop_table table  if connection.table_exists? table
  end

  connection.create_table :posts do |t|
    t.string :title
    t.text   :body
  end
  connection.create_table :comments do |t|
    t.integer     :post_id
    t.foreign_key :posts,    :dependent => :delete
    t.text        :body
  end
  connection.create_table :tags do |t|
    t.string     :name
  end
  connection.create_table :post_tags, :id=>false do |t|
    t.integer     :post_id
    t.foreign_key :posts
    t.integer     :tag_id
    t.foreign_key :tags
  end
end


def connection_info_for adapter
  connections =
    {'mysql'   => {:adapter=>'mysql',           :database=> "blog_test", :username=>'root', :password=>''},
     'sqlite3' => {:adapter=>'sqlite3',         :database=> ":memory:"                                   },
     'oracle'  => {:adapter=>'oracle_enhanced', :database=> "",          :username=>'root', :password=>''}
    }

  connections[adapter]
end


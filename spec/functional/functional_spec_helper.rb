require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

ActiveRecord::Base.establish_connection({:adapter=>'sqlite3', :database=> ":memory:"})

ActiveRecord::Base.connection.create_table :posts do |t|
  t.string :title
  t.text   :body
end
ActiveRecord::Base.connection.create_table :comments do |t|
  t.integer :post_id
  t.text    :body
end


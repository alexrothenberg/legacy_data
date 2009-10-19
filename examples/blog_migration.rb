def create_blog_tables 
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

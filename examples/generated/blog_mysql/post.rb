class Post < ActiveRecord::Base

  # Relationships
  has_and_belongs_to_many :tags, :association_foreign_key => :tag_id, :foreign_key => :post_id, :join_table => :post_tags

  # Constraints
    def self.possible_values_for_published
    "true, false"
  end
  validates_inclusion_of :published,
                         :in      => possible_values_for_published, 
                         :message => "is not one of (#{possible_values_for_published.join(', ')})"

end


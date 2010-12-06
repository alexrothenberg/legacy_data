class Post < ActiveRecord::Base

  # Relationships
  

  # Constraints
    def self.possible_values_for_published
    "true, false"
  end
  validates_inclusion_of :published,
                         :in      => possible_values_for_published, 
                         :message => "is not one of (#{possible_values_for_published.join(', ')})"

end


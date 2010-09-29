class Idea < ActiveRecord::Base
  belongs_to :user
  has_many :idea_comments
  has_many :idea_ratings
  
  validates_presence_of :name, :description
  
  def rating
    idea_ratings.uniq.uniq.size
  end
end

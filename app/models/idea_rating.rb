class IdeaRating < ActiveRecord::Base
	belongs_to :idea
	belongs_to :user
	
	def hash
      user_id.hash
  end

  def eql?(other)
      user_id == other.user_id
  end
end

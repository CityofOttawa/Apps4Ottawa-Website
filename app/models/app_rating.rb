class AppRating < ActiveRecord::Base
	belongs_to :app
	belongs_to :user
	
	def hash
      user_id.hash
  end

  def eql?(other)
      user_id == other.user_id
  end
end

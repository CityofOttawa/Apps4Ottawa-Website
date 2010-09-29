class FixIdeaCommentsLimits2 < ActiveRecord::Migration
	def self.up
		change_table :idea_comments do |t|
			t.change :user_id, :integer, :limit=>11
			t.change :idea_id, :integer, :limit=>11
		end
	end

	def self.down
	end
end

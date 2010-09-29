class FixIdeaCommentsTypes < ActiveRecord::Migration
	def self.up
		change_table :idea_comments do |t|
			t.change :user_id, :integer
			t.change :idea_id, :integer
		end
	end

	def self.down
	end
end

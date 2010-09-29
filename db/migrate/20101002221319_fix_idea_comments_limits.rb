class FixIdeaCommentsLimits < ActiveRecord::Migration
  def self.up
		change_table :idea_comments do |t|
			t.change :user_id, :integer, :limit=>
			t.change :idea_id, :integer, :limit=>
		end
  end

  def self.down
  end
end

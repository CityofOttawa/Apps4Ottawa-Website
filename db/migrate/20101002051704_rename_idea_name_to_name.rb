class RenameIdeaNameToName < ActiveRecord::Migration
  def self.up
    rename_column :ideas, :idea_name, :name
  end

  def self.down
    rename_column :ideas, :name, :idea_name
  end
end
class RenameAppNameToName < ActiveRecord::Migration
  def self.up
    rename_column :apps, :app_name, :name
  end

  def self.down
    rename_column :apps, :name, :app_name
  end
end
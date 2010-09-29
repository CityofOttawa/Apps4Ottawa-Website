class RemoveAcceptRules < ActiveRecord::Migration
  def self.up
    remove_column :users, :accept_rules
  end

  def self.down
    add_column :users, :accept_rules, :boolean
  end
end

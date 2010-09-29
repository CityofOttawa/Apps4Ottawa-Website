class AppComment < ActiveRecord::Base
  belongs_to :app
  belongs_to :user
  
  validates_presence_of :comment
end
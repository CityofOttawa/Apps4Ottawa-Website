class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  attr_protected :admin
  
  has_many :ideas
  has_many :idea_comments
  has_many :idea_ratings
  
  has_many :apps
  has_many :app_comments
  has_many :app_ratings
  
  validates_presence_of :name, :email
  validates_confirmation_of :password
  validates_acceptance_of :terms_of_use
  validates_uniqueness_of :email
  
  def can_submit_ideas_apps?
    %w(street_address city province postal_code).each do |a|
      return false if attributes[a].blank?
    end
    true
  end
end

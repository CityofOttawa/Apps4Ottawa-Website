class App < ActiveRecord::Base
  SCREENSHOT_FILE_TYPES = ['image/jpeg', 'image/jp!g','image/gif', 'image/png']
  belongs_to :user
  has_many :app_comments
  has_many :app_ratings
  
  attr_protected :user_id

  
  # Only post-process the screenshot if one has been included
  has_attached_file :screenshot,
    :styles => lambda { |attachment| attachment.instance.choose_styles },
    :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_file_name",
    :url => "/system/:attachment/:id/:style/:normalized_file_name" 

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.id}-#{self.screenshot_file_name.gsub( /[^a-zA-Z0-9_\.]/, '')}" 
  end

  # Validations to make sure the screenshot is an image under 2 megabytes. Note that we only run these validations
  # if a screenshot was uploaded.
  validates_attachment_content_type :screenshot, :content_type => SCREENSHOT_FILE_TYPES, :unless => lambda {screenshot_file_name.nil?} 
  validates_attachment_size :screenshot, :less_than => 2.megabytes, :unless => lambda {screenshot_file_name.nil?} 

  # A dirty hack so that paperclip error messages will be properly localized 
  # For some reason the i18n engine does not work when used in a :message option of a paperclip validation. BUT ONLY IN PRODUCTION MODE. In dev it works fine.
  # ex: validates_attachment_size :screenshot, :less_than => 2.megabytes, :message=>I18n.translate("errors.attachment_type"), :unless => lambda {screenshot_file_name.nil?} 
  # So instead, we use a callback to override whatever error message paperclip puts by default.
  def after_validation
    if self.errors[:screenshot_content_type][0]
      self.errors[:screenshot_content_type][0] = I18n.t('errors.attachment_type')
    end
    
    if self.errors[:screenshot_file_size][0]
      self.errors[:screenshot_file_size][0] = I18n.t('errors.attachment_size')
    end
  end
  
  def rating
    self.app_ratings.uniq.uniq.size
  end
  
  validates_presence_of :name, :description, :category_id, :resident_value
  
  

  # This method will only set paperclip to resize the screenshots if the screenshot is of a valid type.
  def choose_styles
    if SCREENSHOT_FILE_TYPES.include? screenshot_content_type
      return {:large=>"675x675\>",:thumb => "75x75"}
    else
      return {}
    end
  end
end

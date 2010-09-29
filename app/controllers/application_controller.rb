class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'inside'

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])
  end

  def default_url_options(options = {})
    {:locale => I18n.locale}
  end

   # Check to see if the current user owns the resource that he/she is
   # currently accessing.
   def is_owner?
     # The admin should be able to see everything
     if current_user.admin?
      return true
     end
     if @is_owner.nil?
       if current_user != nil && @owner != nil
         if @owner == current_user
           return @is_owner = true
         end
       end
       return @is_owner = false
     else
       return @is_owner
     end
   end

   def is_admin?
     current_user.try(:admin?)
   end

   # Defines the SecurityTransgression exception, which is the object thrown
   # when someone accesses something they are not allowed to.
   class SecurityTransgression < StandardError; end

    # This is like is_owner? except that it raises a Security exception if the user
    # is not the owner. This will prevent users from accessing resources they do not own.
    def ensure_ownership
      raise SecurityTransgression unless is_owner?
    end

    def ensure_admin
      raise SecurityTransgression unless is_admin?
    end
end

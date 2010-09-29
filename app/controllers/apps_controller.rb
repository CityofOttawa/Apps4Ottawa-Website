class AppsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :show ]
  before_filter :fetch_app , :only=>[:edit,:update,:destroy]
  before_filter :ensure_ownership, :only=>[:edit,:update,:destroy]

  layout 'inside'

  def index
    if Rails.env.production? 
      # For mysql
      @apps = App.all(:order => "Rand()")
    else
      # Intended only for Sqlite3 and Postgres
      @apps = App.all(:order => "Random()") 
    end
  end
  
  def show
    @app = App.find(params[:id])
    begin
      if URI.parse(@app.link.strip).scheme == "http" || URI.parse(@app.link.strip).scheme == "https"
        @link = @app.link.strip
      else
        @link = "http://" + @app.link.strip
      end
    rescue Exception=>e
      @link = ""
    end

    begin
      if URI.parse(@app.user.website.strip).scheme == "http" || URI.parse(@app.link.strip).scheme == "https"
        @userlink = @app.user.website.strip
      else
        @userlink = "http://" + @app.user.website.strip
      end
    rescue Exception=>e
      @userlink = ""
    end
  end

  def like
    if Apps4ottawa::Application::ALLOW_APP_VOTING == false
      redirect_to :back
      return
    end
    @app = App.find(params[:id])
    
    if current_user.app_ratings.empty?
      unless @app.app_ratings.exists?(current_user)
        rating = @app.app_ratings.new
        rating.user = current_user
        rating.rating = 1
        rating.save
      end
    end
    
    redirect_to :back
  end

  def new
    if Apps4ottawa::Application::ALLOW_APP_SUBMISSION == false
      redirect_to :back
      return
    end
    
    unless current_user.can_submit_ideas_apps?
      redirect_to edit_user_registration_path(:incomplete => true)
      return
    end
    
    @app = App.new
  end

  def edit
  end

  def create
    if Apps4ottawa::Application::ALLOW_APP_SUBMISSION == false
      redirect_to :back
      return
    end
    
    @app = App.new(params[:app])
    @app.user = current_user
    
    if @app.save
      redirect_to(:controller => 'apps', :action => 'show', :locale => I18n.locale, :id => @app.id)
    else
      render :action => "new"
    end
  end

  def update
    # Only remove the screenshot if the user selected to, and if there is no image currently being uploaded.
    if params[:app][:screenshot].nil?
      unless params[:remove_screenshot].nil? # The remove screenshot checkbox was selected.
        @app.screenshot = nil
      end
    else
      @app.screenshot_content_type = nil # Reset the content type so that it has to recalculate it.
      @app.screenshot=params[:app][:screenshot]
    end
    
    if @app.update_attributes(params[:app])
      redirect_to(:controller => 'apps', :action => 'show', :locale => I18n.locale, :id => @app.id)
    else
      render :action => "edit"
    end
  end

  def destroy
    @app.destroy
    redirect_to(:controller => 'apps', :action => 'index', :locale => I18n.locale)
  end
  
  protected 
  
  def fetch_app
    @app = App.find(params[:id])
    @owner = @app.user
  end
end

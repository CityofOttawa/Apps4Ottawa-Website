class IdeasController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :show ]
  before_filter :fetch_idea , :only=>[:edit,:update,:destroy]
  before_filter :ensure_ownership, :only=>[:edit,:update,:destroy]

  layout 'inside'

  def index
    if Rails.env.production? 
      @ideas = Idea.all(:order => "Rand()")
    else
      @ideas = Idea.all(:order => "Random()")
    end
  end

  def show
    @idea = Idea.find(params[:id])
  end

  def like
    if Apps4ottawa::Application::ALLOW_IDEA_VOTING == false
      redirect_to :back
      return
    end
    
    @idea = Idea.find(params[:id])
    
    if current_user.idea_ratings.empty?
      unless @idea.idea_ratings.exists?(current_user)
        rating = @idea.idea_ratings.new
        rating.user = current_user
        rating.rating = 1
        rating.save
      end
    end
    
    redirect_to :back
  end

  def new
    if Apps4ottawa::Application::ALLOW_IDEA_SUBMISSION == false
      redirect_to :back
      return
    end
    
    unless current_user.can_submit_ideas_apps?
      redirect_to(edit_user_registration_path(:incomplete => true))
      return
    end
    
    @idea = Idea.new
  end

  def edit
  end

  def create
    if Apps4ottawa::Application::ALLOW_IDEA_SUBMISSION == false
      redirect_to :back
      return
    end
    
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    
    if @idea.save
      redirect_to(:action => 'show', :id => @idea.id)
    else
      render :action => "new"
    end
  end

  def update
    if @idea.update_attributes(params[:idea])
      redirect_to(:action => 'show', :id => @idea.id)
    else
      render :action => "edit"
    end
  end

  def destroy
    @idea.destroy
    
    redirect_to(:action => 'index')
  end
  
  protected 
  
  def fetch_idea
    @idea = Idea.find(params[:id])
    @owner = @idea.user
  end
end

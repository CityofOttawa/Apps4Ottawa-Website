class AppCommentsController < ApplicationController
  def create
    @app_comment = AppComment.new(params[:app_comment])
    @app_comment.user = current_user

    if @app_comment.save
      redirect_to app_path(@app_comment.app)
    else
      redirect_to apps_path
    end
  end
end

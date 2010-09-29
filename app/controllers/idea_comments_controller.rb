class IdeaCommentsController < ApplicationController
  def create
    @idea_comment = IdeaComment.new(params[:idea_comment])
    @idea_comment.user = current_user

    if @idea_comment.save
      redirect_to idea_path(@idea_comment.idea)
    else
      redirect_to ideas_path
    end
  end
end

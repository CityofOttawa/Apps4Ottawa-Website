require 'test_helper'

class IdeaCommentsControllerTest < ActionController::TestCase
  def setup
    sign_in User.first
  end


  test "should create idea_comment" do
    assert_difference('IdeaComment.count') do
      post :create, :idea_comment => { :comment => "omg so good", :idea => Idea.first }
    end

    assert_redirected_to idea_path(assigns(:idea_comment).idea)
  end
end

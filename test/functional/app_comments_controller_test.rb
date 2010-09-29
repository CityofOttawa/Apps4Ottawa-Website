require 'test_helper'

class AppCommentsControllerTest < ActionController::TestCase
  def setup
    sign_in User.first
  end

  test "should create app_comment" do
    assert_difference('AppComment.count') do
      post :create, :app_comment => { :comment => "I love this app", :app => App.first }
    end

    #assert_redirected_to app_path(assigns(:app_comment).app)
  end
end

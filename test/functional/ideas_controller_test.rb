require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @idea = ideas(:an_idea)
    @user = @idea.user
    @controller.stubs(:current_user => @user)
    @controller.stubs(:authenticate_user! => true)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ideas)
  end

  test "should get new when user can submit ideas or apps" do
    User.any_instance.stubs(:can_submit_ideas_apps? => true)
    get :new
    assert_response :success
  end
  
  test "should redirect on #new when user cannot submit ideas or apps" do
    User.any_instance.stubs(:can_submit_ideas_apps? => false)
    get :new
    assert_redirected_to edit_user_registration_path(:incomplete => true)
  end
  
  test "should create idea" do
    assert_difference('Idea.count') do
      post :create, :idea => {:name => 'Some idea', :description => 'Some description' }
    end

    assert_redirected_to idea_path(assigns(:idea))
  end

  test "should show idea" do
    get :show, :id => @idea.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @idea.to_param
    assert_response :success
  end

  test "should update idea" do
    put :update, :id => @idea.to_param, :idea => { }
    assert_redirected_to idea_path(assigns(:idea))
  end

  test "should destroy idea" do
    assert_difference('Idea.count', -1) do
      delete :destroy, :id => @idea.to_param
    end

    assert_redirected_to ideas_path
  end
end

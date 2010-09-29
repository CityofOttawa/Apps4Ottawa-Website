require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @app = apps(:example_app)
    @user = @app.user
    @controller.stubs(:current_user => @user)
    @controller.stubs(:authenticate_user! => true)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apps)
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

  test "should create app" do
    assert_difference('App.count') do
      post :create, :app => {:name => 'A name', :description => 'A description', :category_id => 1,  :resident_value => 'Some nice ideas'}
    end

    assert_redirected_to app_path(assigns(:app))
  end

  test "should show app" do
    get :show, :id => @app.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @app.to_param
    assert_response :success
  end

  test "should update app" do
    put :update, :id => @app.to_param, :app => { }
    assert_redirected_to app_path(assigns(:app))
  end

  test "should destroy app" do
    assert_difference('App.count', -1) do
      delete :destroy, :id => @app.to_param
    end

    assert_redirected_to apps_path
  end
end

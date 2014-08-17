require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  def setup
    super
    @project = Project.create(name: 'foo', owner: @user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { name: 'Test'}
    end

    assert_redirected_to projects_path
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { name: @project.name}
    assert_redirected_to projects_path
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test "should get metrics" do
    get :metrics, project_id: @project.id
    assert_response :success
  end


  test "should get metrics if owner subscription not expired" do
    user = users(:user_two)
    project = Project.create!(name: 'foobar', owner: user)
    project.users<< @user
    get :metrics, project_id: project.id
    assert_response :success
  end

  test "should read projects data" do
    user = users(:user_one)
    project = Project.create(name: 'foo', owner: user)
    user.owned_projects<< project
    @user.projects<< project
    get :metrics, project_id: project.id, format: :json
    assert_response :success
  end
end

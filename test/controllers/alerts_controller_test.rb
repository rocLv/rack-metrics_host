require 'test_helper'

class AlertsControllerTest < ActionController::TestCase
  def setup
    super
    @alert = alerts(:alert_one)
    @project = projects(:project_one)
    @user.owned_projects<< @project
    @alert.project_id = @project.id
    @alert.save
  end

  test "should get index" do
    get :index, project_id: @project.id
    assert_response :success
    assert_not_nil assigns(:alerts)
  end

  test "should get new" do
    get :new, project_id: @project.id
    assert_response :success
  end

  test "should create alert" do
    assert_difference('Alert.count') do
      post :create, project_id: @project.id, alert: { active: @alert.active}
    end

    assert_redirected_to project_alerts_path(@project)
  end

  # test "should show alert" do
  #   get :show, id: @alert, project_id: @project.id
  #   assert_response :success
  # end

  test "should get edit" do
    get :edit, id: @alert, project_id: @project.id
    assert_response :success
  end

  test "should update alert" do
    patch :update, project_id: @project.id, id: @alert, alert: { active: @alert.active, project_id: @alert.project_id, response_time_treshold: @alert.response_time_treshold }
    assert_redirected_to project_alerts_path(@project)
  end

  test "should destroy alert" do
    assert_difference('Alert.count', -1) do
      delete :destroy, project_id: @project.id, id: @alert
    end

    assert_redirected_to project_alerts_path(@project)
  end
end

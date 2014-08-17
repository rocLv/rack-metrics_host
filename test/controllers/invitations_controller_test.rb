require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  def setup
    super
    @project = Project.create(name: 'Foo', owner: @user)
    @invitation = invitations(:one)
  end

  test "should get new" do
    get :new, project_id: @project.id
    assert_response :success
  end

  test "should create invitation" do
    assert_difference('Invitation.count') do
      post :create, invitation: @invitation.attributes, project_id: @project.id
    end

    assert_redirected_to project_users_path(@project.id)
  end

  test "should destroy invitation" do
    @invitation = @project.invitations.create(email: 'foo@bar.com')
    assert_difference('Invitation.count', -1) do
      delete :destroy, id: @invitation, project_id: @project.id
    end

    assert_redirected_to project_users_path(@project.id)
  end
end

require 'test_helper'

class InvitationControllerTest < ActionController::TestCase
  def setup
    super
    @project = Project.create(name: 'Foo', owner: @user)
  end

  test "should return form if valid token and new user" do
    @invitation = @project.invitations.create(email: 'foo@foobar.com')
    get :invitation, invitation: {token: @invitation.token}
    assert_response :success
  end

  test "should redirect_to home if invalid token" do
    @invitation = @project.invitations.create(email: 'foo@foobar.com')
    get :invitation, invitation: {token: 'foo'}
    assert_redirected_to root_url
  end

  test "should redirect_to login if existing user and setup project" do
    skip "Implement later"
    user2 = User.create!(name: 'FooBar', email: 'foo2@bar.com', password: '12345678', password_confirmation: '12345678')
    @invitation = @project.invitations.create(email: user2.email)
    get :invitation, invitation: {token: @invitation.token}
    assert_redirected_to new_user_session_path
    assert @project.users.include? @invitation.user
  end

  test "should register new user with invited email address and add project" do
    @invitation = @project.invitations.create(email: 'foo3@foobar.com')
    assert_difference('User.count') do
      post :register_invitation, invitation: {token: @invitation.token}, user: {name: 'Foobar', password: '12345678', password_confirmation: '12345678'}
    end
    created = User.where(email: 'foo3@foobar.com').first
    refute_nil created
    assert @project.users.include?(created)
  end
end

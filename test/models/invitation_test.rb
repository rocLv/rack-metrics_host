require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "shouldn't be valid with own email" do
    user = users(:user_one)
    project = Project.create(name: 'Foo', owner: user)
    invitation = project.invitations.new(email: user.email)
    refute invitation.save
  end
end

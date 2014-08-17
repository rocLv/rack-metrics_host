require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "after created it has the necessary keys" do
    user = users(:user_one)
    project = Project.create(name: 'Foo', owner: user)
    refute_nil project.api_key
  end

  # test "obey plan limits" do
  #   user = users(:user_one)
  #   user.subscription.plan.update_attribute(:max_projects, 1)
  #   project = projects(:test_project)
  #   refute project.valid?
  # end
end

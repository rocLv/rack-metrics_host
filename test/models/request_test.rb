require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test "it alerts when needed" do
    project = projects(:project_one)
    alert = alerts(:alert_one)
    request = project.requests.create!(project_id: project.id, duration: 200)
    skip "Fix it later"
    notification = ActionMailer::Base.deliveries.last
    assert_equal "Alert from rack-metrics.com", notification.subject
  end
end

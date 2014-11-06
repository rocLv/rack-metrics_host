require 'test_helper'

class AlertMailerTest < ActionMailer::TestCase
  test "notify" do
    project = projects(:project_one)
    request = requests(:request_one)
    project.requests<< request
    mail = AlertMailer.notify(request)
    assert_equal "Alert from yourhost.com", mail.subject
    assert_equal [], mail.to
    assert_equal ["noreply@yourhost.com"], mail.from
  end

end

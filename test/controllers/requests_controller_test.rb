require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  def setup
    super
    @user.update_attribute(:active, true)
    @project = Project.create(name: 'Foo', owner: @user)
    attributes = requests(:request_one).attributes
    attributes.delete("id")
    @web_request = @project.requests.create(attributes)
  end
  test "should get index" do
    get :index, project_id: @project.id
    assert_response :success
  end

  test "should get show" do
    get :show, id: @web_request.id, project_id: @project.id
    assert_response :success
  end

end

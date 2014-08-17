class Api::V1::ProjectsController < ActionController::Base
  respond_to :json

  def index
    head :bad_request  and return if params[:api_version].nil? or params[:api_key].nil? or params[:data].nil?
    project = Project.where(api_key: params[:api_key]).first
    request = ApiRequest.create(project_id: project.id, api_version: params[:api_version], data: params[:data])
    RequestWorker.perform_async(request.id)
    head :ok
  end
end

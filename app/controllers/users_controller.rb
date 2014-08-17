class UsersController < ApplicationController
  before_action :set_project

  def index
    @users = @project.users.all
    @invitation = Invitation.new
  end

  def destroy
    @project.users.delete(@project.users.find(params[:id]))
    redirect_to project_users_path(@project)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:project_id])
    end
end

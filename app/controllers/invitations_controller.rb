class InvitationsController < ApplicationController
  before_action :set_project
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = @project.invitations.all
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = @project.invitations.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html {
          InvitationMailer.invite(@invitation).deliver
          redirect_to project_users_path(@project), notice: 'Invitation was successfully created.'
        }
        format.json { render action: 'show', status: :created, location: @invitation }
      else
        format.html { render 'users/index' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to project_invitations_path(@project), notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to project_users_path(@project) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:project_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = @project.invitations.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:email)
    end
end

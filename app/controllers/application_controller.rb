class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!
  around_filter :user_time_zone, if: :current_user
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :time_zone, :current_password) }
  end

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? and (self.class.to_s != 'Devise::RegistrationController' and action_name != 'edit')
      "login"
    else
      "application"
    end
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end

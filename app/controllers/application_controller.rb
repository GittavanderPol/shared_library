class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_request_count

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :whatsapp])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :whatsapp])
  end

  def set_request_count
    return unless current_user
    @request_count = current_user.connections_to_accept.count
  end
end

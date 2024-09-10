class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :log_request_format
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    resource = warden.authenticate!(auth_options)
    render json: { user: resource, status: :ok, message: 'Signed in successfully' }, status: :ok
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end

  def log_request_format
    Rails.logger.debug 'Request format: # {request.format}'
  end
end

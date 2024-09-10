# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    skip_before_action :verify_authenticity_token

    def create
      super do |user|
        if user.persisted?
          render json: { user: user, message: 'Signed up successfully' }, status: :ok and return
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity and return
        end
      end
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name username bio avatar])
    end

    protected

    def update_resource(resource, params)
      return super if params[:password]&.present?

      resource.update_without_password(params.except(:current_password))
    end
  end
end


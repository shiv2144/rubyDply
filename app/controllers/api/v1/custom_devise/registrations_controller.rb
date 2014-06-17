module Api
  module V1
    module CustomDevise
      class RegistrationsController < Devise::RegistrationsController
        include DeviseJsonAdapter

        prepend_before_filter :require_no_authentication, only: [ :create ]

        respond_to :json

        # POST /resource
        def create
          build_resource(sign_up_params)
          if resource.save
            if resource.active_for_authentication?
              sign_up(resource_name, resource)
              # access_token = Doorkeeper::AccessToken.create!(application_id:application_id,:resource_owner_id:user_id)
              render json: {
                first_name: resource.first_name,
                last_name: resource.last_name,
                email: resource.email
              }, status: :created
            else
              render json: {errors: [resource.inactive_message]}, status: :created
            end
          else
            clean_up_passwords resource
            render json: {errors: resource.errors.full_messages.uniq}, status: :unprocessable_entity
          end
        end

        private

          def sign_up_params
            params.fetch(:user).permit([:password, :password_confirmation, :email, :first_name, :last_name])
          end

      end
    end
  end
end

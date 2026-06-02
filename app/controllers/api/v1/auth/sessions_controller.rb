module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        def create
          user = User.find_by(email: params[:email]&.downcase)

          if user&.authenticate(params[:password])
            render json: {
              token: user.api_token,
              user: {
                id: user.id,
                email: user.email,
                role: user.role,
                company_id: user.company_id
              }
            }, status: :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end
      end
    end
  end
end

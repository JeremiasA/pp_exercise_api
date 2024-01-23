module Api
  module V1
    class AuthController < ApplicationController
      skip_before_filter :authorized, only: [:login]
      before_filter :basic_authenticate!
      # POST /login
      def login
        if @current_user
          render json: { token: encode_token(user_id: @current_user.id) }
        else
          render json: { message: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_filter :authorized, only: [:create]
      before_filter :set_user, only: [:show, :update, :destroy]

      # GET /users/1
      def show
        @user = User.find(params[:id])

        render_one @user, with: Users::Serializer
      end

      # POST /users
      def create
        @user = User.create!(user_params)

        @token = encode_token(user_id: @user.id)

        render json: {
          token: @token
        }
      end

      # PUT /users/1
      def update
        @user.update_attributes!(users_params)

        render_one @user, with: Users::Serializer
      end

      # DELETE /users/1
      def destroy
        @user.destroy

        head :ok
      end

      private

      def set_user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.permit(
          :name,
          :last_name,
          :email,
          :password
        )
      end
    end
  end
end

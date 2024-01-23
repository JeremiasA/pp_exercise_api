module Api
  module V1
    class ClientsController < ApplicationController
      before_filter :set_client, only: [:show, :update, :destroy]

      # GET /clients
      def index
        @clients = Client.all.paginate(page: params[:page], per_page: per_page)

        render_many @clients, with: Clients::Serializer
      end

      # GET /clients/1
      def show
        @client = Client.find(params[:id])

        render_one @client, with: Clients::Serializer
      end

      # POST /clients
      def create
        @client = @user.clients.create!(client_params)

        render_create @client, with: Clients::Serializer
      end

      # PUT /clients/1
      def update
        @client.update_attributes!(client_params)

        render_one @client, with: Clients::Serializer
      end

      # DELETE /clients/1
      def destroy
        @client.destroy

        head :ok
      end

      private

      def set_client
        @client ||= Client.find(params[:id])
      end

      def client_params
        params.permit(
          :name,
          :last_name,
          :doc_number,
          :email,
          :phone,
          :zip_code,
          :address
        )
      end
    end
  end
end

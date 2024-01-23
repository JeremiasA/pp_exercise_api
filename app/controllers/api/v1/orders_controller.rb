module Api
  module V1
    class OrdersController < ApplicationController
      before_filter :set_order, only: [:show, :update, :destroy]

      # GET /orders
      def index
        @orders = Order.filter_by(filter_params.except(:count_by_range))

        if filter_params[:count_by_range].present?
          stats = Orders::Stats.stats(@orders, filter_params[:count_by_range])

          render json: stats
        else
          render_many @orders.paginate(page: params[:page], per_page: per_page), with: Orders::Serializer
        end
      end

      # GET /orders/1
      def show
        @order = Order.find(params[:id])

        render_one @order, with: Orders::Serializer
      end

      # POST /orders
      def create
        @order = Order.create!(create_params)

        render_create @order, with: Orders::Serializer
      end

      # PUT /orders/1
      def update
        @order.update_attributes!(update_params)

        render_one @order, with: Orders::Serializer
      end

      # DELETE /orders/1
      def destroy
        @order.destroy

        head :ok
      end

      private

      def set_order
        @order ||= Order.find(params[:id])
      end

      def create_params
        params.permit(
          :code,
          :status,
          :payment_method,
          :shipping_method,
          :shipping_price,
          :total_price,
          :product_id,
          :client_id
        )
      end

      def update_params
        create_params.except(
          :code
        )
      end

      def filter_params
        params.permit(
          :created_from,
          :created_to,
          :category_id,
          :client_id,
          :user_id,
          :count_by_range
        )
      end
    end
  end
end

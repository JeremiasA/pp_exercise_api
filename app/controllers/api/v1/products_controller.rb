module Api
  module V1
    class ProductsController < ApplicationController
      before_filter :set_product, only: [:show, :update, :destroy]

      # GET /products
      def index
        @products = Product.includes(category_items: :category).paginate(page: params[:page], per_page: per_page)

        render_many @products, with: Products::Serializer
      end

      # GET /products/1
      def show
        @product = Product.find(params[:id])

        render_one @product, with: Products::Serializer
      end

      # POST /products
      def create
        @product = @user.products.create!(create_params)

        render_create @product, with: Products::Serializer
      end

      # PUT /products/1
      def update
        @product.update_attributes!(update_params)

        render_one @product, with: Products::Serializer
      end

      # DELETE /products/1
      def destroy
        @product.destroy

        head :ok
      end

      # GET /most_sold_products
      def most_sold_products
        stats = Products::Stats.most_sold(params.permit(:code))

        render json: stats
      end

      # GET /most_money_products
      def most_money_products
        stats = Products::Stats.most_money(params.permit(:code))

        render json: stats
      end

      private

      def set_product
        @product ||= Product.find(params[:id])
      end

      def create_params
        params.permit(
          :title,
          :code,
          :sell_price,
          :description,
          :cost,
          :weight,
          :width,
          :length,
          :height
        ).merge!(category_items_params)
      end

      def update_params
        create_params.except(
          :code
        )
      end

      def category_items_params
        category_items = params.require(
          :category_items
        )

        { category_items_attributes: category_items }
      end
    end
  end
end

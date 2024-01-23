module Api
  module V1
    class CategoriesController < ApplicationController
      before_filter :set_category, only: [:show, :update, :destroy]

      # GET /categories
      def index
        @categories = Category.all.paginate(page: params[:page], per_page: per_page)

        render_many @categories, with: Categories::Serializer
      end

      # GET /categories/1
      def show
        @category = Category.find(params[:id])

        render_one @category, with: Categories::Serializer
      end

      # POST /categories
      def create
        @category = @user.categories.create!(create_params)

        render_create @category, with: Categories::Serializer
      end

      # PUT /categories/1
      def update
        @category.update_attributes!(update_params)

        render_one @category, with: Categories::Serializer
      end

      # DELETE /categories/1
      def destroy
        @category.destroy

        head :ok
      end

      private

      def set_category
        @category ||= Category.find(params[:id])
      end

      def create_params
        params.permit(
          :code,
          :description
        )
      end

      def update_params
        create_params.except(
          :code
        )
      end
    end
  end
end

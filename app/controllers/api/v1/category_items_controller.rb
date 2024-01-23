module Api
  module V1
    class CategoryItemsController < ApplicationController
      before_filter :set_category_item, only: [:destroy]

      # POST /category_items
      def create
        @category_item = CategoryItem.create!(create_params)

        render_create @category_item, with: CategoryItems::Serializer
      end

      # DELETE /category_items/1
      def destroy
        @category_item.destroy

        head :ok
      end

      private

      def set_category_item
        @category_item ||= CategoryItem.find(params[:id])
      end

      def create_params
        params.permit(
          :product_id,
          :category_id
        )
      end
    end
  end
end

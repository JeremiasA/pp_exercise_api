module Products
  module Serializer
    extend BasicSerializer

    CATEGORY_ITEMS_EXCLUDES = [:product].freeze

    module_function

    def json(product, options = {})
      return unless product

      attributes = product.attributes.symbolize_keys.slice(
        :id,
        :title,
        :code,
        :sell_price,
        :description,
        :weight,
        :width,
        :length,
        :height
      )

      attributes[:categories] = category_json(product, options)

      attributes
      end

    def category_json(product, options)
      CategoryItems::Serializer.render_many(
        product.category_items,
        options.merge(excludes: CATEGORY_ITEMS_EXCLUDES)
      )
    end
  end
end

module CategoryItems
  module Serializer
    extend BasicSerializer

    module_function

    ASSOCIATIONS_RENDER = [:category, :product].freeze

    def json(category_item, options = {})
      return unless category_item

      attributes = {}

      ASSOCIATIONS_RENDER.each do |association|
        next if options[:excludes].include?(association)

        attributes[association] = public_send("#{association}_json", category_item, options)
      end

      attributes
    end

    def product_json(category_item, _options)
      Products::Serializer.json(category_item.product)
    end

    def category_json(category_item, _options)
      Categories::Serializer.json(category_item.category)
    end
end
end

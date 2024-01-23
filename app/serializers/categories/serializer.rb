module Categories
  module Serializer
    extend BasicSerializer

    module_function

    def json(category, _options = {})
      return unless category

      attributes = category.attributes.symbolize_keys.slice(
        :id,
        :code,
        :description
      )

      attributes
      end
  end
end

module Orders
  module Serializer
    extend BasicSerializer

    module_function

    def json(order, _options = {})
      return unless order

      attributes = order.attributes.symbolize_keys.slice(
        :id,
        :code,
        :status,
        :payment_method,
        :shipping_method,
        :shipping_price,
        :total_price,
        :product_id,
        :client_id,
        :created_at,
        :user_id
      )

      attributes
      end
  end
end

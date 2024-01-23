module Clients
  module Serializer
    extend BasicSerializer

    module_function

    def json(client, _options = {})
      return unless client

      attributes = client.attributes.symbolize_keys.slice(
        :id,
        :name,
        :last_name,
        :doc_number,
        :email,
        :phone,
        :zip_code,
        :address
      )

      attributes
      end
  end
end

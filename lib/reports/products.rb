module Products
  module Report
    module_function

    YESTERDAY_SELLS_SQL = " SELECT to_jsonb(products.code) as product, json_agg(to_jsonb(orders.code)) as orders
                            FROM products
                            LEFT JOIN orders ON orders.product_id = products.id
                            GROUP BY 1
                          ".freeze

    def yesterday_sell
      ActiveRecord::Base.connection.execute(YESTERDAY_SELLS_SQL).to_a
    end
  end
end

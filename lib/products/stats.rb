# frozen_string_literal: true

module Products
  module Stats
    RESULTS = 3

    ORDERS_PRODUCTS_SQL = "SELECT category, product_id, orders_count
                    FROM(
                      SELECT products.id product_id, categories.code category, count(orders) as orders_count
                      FROM products
                      JOIN category_items ON category_items.product_id = products.id
                      JOIN categories ON categories.id = category_items.category_id
                      JOIN orders ON orders.product_id = products.id
                      GROUP BY category, products.id
                      )".freeze

    PRICE_PRODUCTS_SQL = "SELECT category, product_id, product_price_totals
                           FROM(
                            SELECT products.id product_id, categories.code category, sum(products.sell_price) as product_price_totals
                            FROM products
                            JOIN category_items ON category_items.product_id = products.id
                            JOIN categories ON categories.id = category_items.category_id
                            JOIN orders ON orders.product_id = products.id
                            GROUP BY category, products.id
                            )".freeze

    module_function

    def most_sold(_params)
      products_query = ActiveRecord::Base.connection.execute(ORDERS_PRODUCTS_SQL)

      category_products = products_query.to_a.group_by { |r| r['category'] }.map { |r| r.last.sort_by { |k| k['orders_count'].to_i }.reverse!.first(RESULTS) }.flatten

      category_products
    end

    def most_money(_params)
      products_query = ActiveRecord::Base.connection.execute(PRICE_PRODUCTS_SQL)

      category_products = products_query.to_a.group_by { |r| r['category'] }.map { |r| r.last.sort_by { |k| k['product_price_totals'].to_f }.reverse!.first(RESULTS) }.flatten

      category_products
    end
  end
end

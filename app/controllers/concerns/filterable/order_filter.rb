# frozen_string_literal: true
module Filterable
  module OrderFilter
    extend ActiveSupport::Concern

    included do
      scope :filter_by_created_from, ->(date_from) {
        where 'orders.created_at >= ?', date_from
      }

      scope :filter_by_created_to, ->(date_to) { where 'orders.created_at <= ?', date_to }

      scope :filter_by_client_id, ->(client_id) {
        where(client_id: client_id)
      }

      scope :filter_by_category_id, ->(category_id) {
                                      joins(product: :category_items)
                                        .where(category_items: { category_id: category_id })
                                    }

      scope :filter_by_user_id, ->(user_id) {
                                  joins(:product)
                                    .where(products: { user_id: user_id })
                                }

      scope :created_yesterday, -> {
        where(
          created_at: DateTime.now.utc.yesterday.beginning_of_day..DateTime.now.utc.yesterday.end_of_day
        )
      }
    end
  end
  end

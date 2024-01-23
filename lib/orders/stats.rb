# frozen_string_literal: true
module Orders
  module Stats
    VALID_TIME_RANGES = %w(
      second
      minute
      hour
      week
      month
      year
    ).freeze

    module_function

    def stats(orders, range)
      retun {} unless VALID_TIME_RANGES.include?(range)

      {
        stats: orders.order("date_trunc('#{range}', orders.created_at)").group("date_trunc('#{range}', orders.created_at)").count
      }
    end
  end
end

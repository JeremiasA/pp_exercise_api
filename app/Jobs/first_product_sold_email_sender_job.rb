# frozen_string_literal: true

class FirstProductSoldEmailSenderJob
  include Sidekiq::Worker

  sidekiq_options queue: :emails, retry: 10

  def perform(id)
    first_order_product = Order.where(product_id: id)
                               .where('status != ?', 'cancelled')
                               .order(:created_at).first

    return unless first_order_product

    begin
      ProductEmail.first_sold_email!(first_order_product).deliver
    rescue Exception => e
      Rails.logger.warn("error: #{e}")
    end
  end
end

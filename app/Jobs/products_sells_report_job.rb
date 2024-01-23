# frozen_string_literal: true

class ProductsSellsReportJob
  include Sidekiq::Worker

  sidekiq_options queue: :emails, retry: 10

  def perform(_id)
    ProductEmail.yesterday_report_email!.deliver
  rescue Exception => e
    Rails.logger.warn("error: #{e}")
  end
end

# frozen_string_literal: true

redis_url = ENV['REDIS_URL']

Sidekiq.configure_server do |config|
  pool_size = ENV.fetch('REDIS_POOL_SIZE', 12).to_i

  if redis_url.present?
    config.redis = {
      url: redis_url,
      size: pool_size
    }
  end

  config.on(:startup) do
    schedule_file = Rails.root.join('config', 'sidekiq_scheduler.yml')

    Sidekiq.schedule = YAML.load_file(schedule_file)
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end

  ActiveRecord::Base.establish_connection
end

Sidekiq.configure_client do |config|
  if redis_url.present?
    config.redis = {
      url: redis_url,
      size: ENV.fetch('REDIS_CLIENT_SIZE', 5).to_i
    }
  end
end

require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Calculate interest in every 5 minutes',
  cron: "*/5 * * * *", # Every 5 minutes
  class: 'CalculateInterestJob'
)

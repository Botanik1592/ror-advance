require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module RorAdvance
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.action_cable.allowed_request_origins = ['http://qna.buryka.ru', 'http://localhost:3000']

    config.active_job.queue_adapter = :sidekiq

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 60.minutes }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end

require 'rails_helper'

Capybara.default_max_wait_time  = 5
Capybara.server = :puma

Capybara::Webkit.configure do |config|
  config.allow_url("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js")
end

Capybara::Webkit.configure do |config|
  config.allow_url("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css")
end

Capybara::Webkit.configure do |config|
  config.allow_url("maxcdn.bootstrapcdn.com")
end

Capybara::Webkit.configure do |config|
  config.allow_url("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css")
end

RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

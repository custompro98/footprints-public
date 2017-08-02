require 'simplecov'
require 'database_cleaner'

SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require './lib/ar_repository/ar_repository'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  I18n.enforce_available_locales = false
  config.treat_symbols_as_metadata_keys_with_true_values = true
  #config.profile_examples = true # uncomment if profiling is necessary

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.test_mode = true


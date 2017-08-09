require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

SafeYAML::OPTIONS[:default_mode] = :safe

module Footprints
  class Application < Rails::Application
    config_file =  File.expand_path(Rails.root.join('config', 'application.yml'))
    ENV.update YAML.load_file(config_file) if File.exist?(config_file)
    mailer_config = File.expand_path(Rails.root.join('config', 'mailer.yml'))
    ENV.update YAML.load_file(Rails.root.join("config", "mailer.yml")) if File.exist?(mailer_config)

    # add custom validators path
    config.autoload_paths += %W["#{config.root}/app/validators/"]
    config.autoload_paths += %W["#{config.root}/lib"]
    config.time_zone = 'Central Time (US & Canada)'
    config.force_ssl = Rails.env.production?
    config.assets_enabled = true
    config.encoding = "utf-8"

    if Rails.env.production?
      host = "footprints.abcinc.com"
    elsif Rails.env.staging?
      host = "footprints-staging.abcinc.com"
    else
      host = "0.0.0.0"
    end

    config.action_mailer.default_url_options = { :host => host }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => 587,
      :user_name => ENV['MAILER_USERNAME'],
      :password => ENV['MAILER_PASSWORD'],
      :authentication => 'plain',
      :enable_starttls_auto => true }

    config.filter_parameters += [:password]
  end
end


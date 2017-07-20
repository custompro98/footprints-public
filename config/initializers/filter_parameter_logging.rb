# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.

# TODO: Consider anything else to add
Rails.application.config.filter_parameters += [:password]

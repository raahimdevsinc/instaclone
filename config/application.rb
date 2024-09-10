# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Instaclone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.exceptions_app = routes
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_controller.default_protect_from_forgery = true
    config.action_controller.allow_forgery_protection = true

    config.action_dispatch.default_headers.merge!({
                                                    'Access-Control-Allow-Origin' => 'http://localhost:3001', # Frontend origin
                                                    'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
                                                    'Access-Control-Allow-Headers' => 'Content-Type, Authorization'
                                                  })
  end
end

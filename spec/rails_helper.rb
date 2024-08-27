# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'
require 'rails-controller-testing'

# Additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Include Devise test helpers
  config.include Devise::Test::ControllerHelpers, type: :controller

  # If you are using Capybara for feature specs, include its DSL
  config.include Capybara::DSL

  # If you use DatabaseCleaner or other tools, configure them here

  # Set the correct behavior for pending examples
  config.expose_dsl_globally = true

  config.use_transactional_fixtures = true

  # Include the following if you want to use shoulda-matchers
  # config.include Shoulda::Matchers::ActiveRecord, type: :model

  # Add additional configuration here if needed
end

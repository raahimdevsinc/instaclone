# frozen_string_literal: true

# app/controllers/errors_controller.rb
class ErrorsController < ApplicationController
  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end
end

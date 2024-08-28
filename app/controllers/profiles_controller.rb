# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index
    @users = search_users
  rescue StandardError => e
    flash[:alert] = "An error occurred while searching for users: #{e.message}"
  end

  private

  def search_users
    query = User.ransack(username_cont: search_query)
    query.result(distinct: true)
  rescue StandardError => e
    flash[:alert] = "An error occurred while searching for users: #{e.message}"
  end

  def search_query
    params[:query]
  end
end

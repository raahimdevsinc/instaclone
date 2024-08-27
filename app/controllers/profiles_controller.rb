# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index
    @users = search_users
  end

  def search_users
    query = User.ransack(username_cont: search_query)
    query.result(distinct: true)
  end

  def search_query
    params[:query]
  end
end

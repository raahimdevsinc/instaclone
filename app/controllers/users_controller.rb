# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show follow unfollow accept decline cancel]
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found.'
  end

  def follow
    current_user.send_follow_request_to(@user)
    @user.accept_follow_request_of(current_user)
    redirect_to user_path(@user), notice: 'Now following.'
  end

  def unfollow
    if current_user.following?(@user)
      current_user.unfollow(@user)
      redirect_to user_path(@user), notice: 'No longer following.'
    else
      redirect_to user_path(@user), alert: 'Not following.'
    end
  end

  def accept
    if current_user.pending_follow_request_from?(@user)
      current_user.accept_follow_request_of(@user)
      redirect_to user_path(@user), notice: 'Follow request accepted.'
    else
      redirect_to user_path(@user), alert: 'No follow request to accept.'
    end
  rescue StandardError => e
    redirect_to users_path, alert: "An error occurred: #{e.message}"
  end

  def decline
    if current_user.pending_follow_request_from?(@user)
      current_user.decline_follow_request_of(@user)
      redirect_to user_path(@user), notice: 'Follow request declined.'
    else
      redirect_to user_path(@user), alert: 'No follow request to decline.'
    end
  rescue StandardError => e
    redirect_to users_path, alert: "An error occurred: #{e.message}"
  end

  def cancel
    if current_user.sent_follow_request_to?(@user)
      current_user.remove_follow_request_for(@user)
      redirect_to user_path(@user), notice: 'Follow request canceled.'
    else
      redirect_to user_path(@user), alert: 'No follow request to cancel.'
    end
  rescue StandardError => e
    redirect_to users_path, alert: "An error occurred: #{e.message}"
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'User not found.'
  end
end

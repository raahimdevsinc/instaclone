# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show follow unfollow accept decline cancel]
  before_action :authenticate_user!

  def show
    # Already set_user before action
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found.'
  end

  def follow
    if current_user.can_follow?(@user)
      current_user.send_follow_request_to(@user)
      @user.accept_follow_request_of(current_user)
      redirect_to user_path(@user), notice: 'Follow request sent and accepted.'
    else
      redirect_to user_path(@user), alert: "You can't follow this user."
    end
  rescue StandardError => e
    redirect_to users_path, alert: "An error occurred: #{e.message}"
  end

  def unfollow
    if current_user.following?(@user)
      current_user.unfollow(@user)
      redirect_to user_path(@user), notice: 'Unfollowed successfully.'
    else
      redirect_to user_path(@user), alert: 'You are not following this user.'
    end
  rescue StandardError => e
    redirect_to users_path, alert: "An error occurred: #{e.message}"
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
    redirect_to users_path, alert: 'User not found.'
  end
end

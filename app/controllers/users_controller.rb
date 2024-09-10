# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show follow unfollow accept decline cancel followers following]
  before_action :authenticate_user!, except: %i[show followers following]

  def current_user
    render json: { user: current_user }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      logger.info "User created successfully: #{@user.inspect}"
      render json: { user: @user }, status: :created
    else
      logger.error "User creation failed: #{@user.errors.full_messages.inspect}"
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found.'
  end

  def followers
    @followers = @user.followers
    render json: @followers
  end

  def following
    @following = @user.following
    render json: @following
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
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end

# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_like, only: %i[destroy]

  def create
    @like = current_user.likes.find_or_initialize_by(like_params)

    if @like.save
      flash[:notice] = 'Post liked!'
    else
      flash[:alert] = 'You have already liked this post'
    end

    redirect_to post_path(@like.post.id)
  rescue StandardError => e
    flash[:alert] = "An error occurred while liking the post: #{e.message}"
    redirect_to posts_path
  end

  def destroy
    if @like
      @like.destroy
      flash[:notice] = 'Like removed.'
    else
      flash[:alert] = 'Like not found.'
    end

    redirect_to @like&.post || posts_path
  rescue StandardError => e
    flash[:alert] = "An error occurred while removing the like: #{e.message}"
    redirect_to posts_path
  end

  private

  def find_like
    @like = current_user.likes.find_by_id(params[:id])
    return if @like

    flash[:alert] = 'Like not found.'
    redirect_to posts_path
  end

  def like_params
    params.require(:like).permit(:post_id)
  end
end

# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @like = current_user.likes.find_or_initialize_by(like_params)
    if @like.save
      flash[:notice] = 'Post liked!'
    else
      flash[:alert] = 'You have already liked this post'
    end
    redirect_to root_path
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    redirect_to root_path
  end

  def like_params
    params.require(:like).permit(:post_id)
  end
end

# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  include Pagy::Backend

  # GET /posts or /posts.json
  def index
    @posts = Post.order(created_at: :asc)
    @pagy, @posts = pagy_countless(@posts)
  rescue StandardError => e
    flash[:alert] = "An error occurred while loading posts: #{e.message}"
    redirect_to root_path
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = @post.comments.build
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = "Post not found: #{e.message}"
    redirect_to posts_path
  end

  def myposts
    @posts = current_user.posts
  rescue StandardError => e
    flash[:alert] = "An error occurred while fetching your posts: #{e.message}"
    redirect_to posts_path
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = "Post not found: #{e.message}"
    redirect_to posts_path
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  rescue StandardError => e
    flash[:alert] = "An error occurred while creating the post: #{e.message}"
    redirect_to new_post_path
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  rescue StandardError => e
    flash[:alert] = "An error occurred while updating the post: #{e.message}"
    redirect_to edit_post_path(@post)
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue StandardError => e
    flash[:alert] = "An error occurred while deleting the post: #{e.message}"
    redirect_to posts_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :description, :keywords, :user_id, images: [])
  end
end

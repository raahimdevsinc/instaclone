class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  include Pagy::Backend

  # GET /posts or /posts.json
  # app/controllers/posts_controller.rb
  def index
    @posts = Post.includes(:user, :comments).all
    render json: @posts.as_json(include: { user: { only: :username },
                                           comments: { include: { user: { only: :username } },
                                                       only: %i[id content] } })
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
    render json: @comments.as_json(include: { user: { only: :username } })
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
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
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
    respond_to do |format|
      format.html { redirect_to edit_post_path(@post) }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue StandardError => e
    flash[:alert] = "An error occurrerails db:migrate
d while deleting the post: #{e.message}"
    respond_to do |format|
      format.html { redirect_to posts_path }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, images: [])
  end
end

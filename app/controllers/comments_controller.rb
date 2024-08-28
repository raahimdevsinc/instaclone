# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  rescue StandardError => e
    redirect_to root_path, alert: "An error occurred while fetching comments: #{e.message}"
  end

  # GET /comments/1 or /comments/1.json
  def show
    # The @comment is already set by before_action
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_path, alert: 'Comment not found.'
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  rescue StandardError => e
    redirect_to comments_path, alert: "An error occurred while initializing a new comment: #{e.message}"
  end

  # GET /comments/1/edit
  def edit
    # The @comment is already set by before_action
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_path, alert: 'Comment not found.'
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue StandardError => e
    redirect_to comments_path, alert: "An error occurred while creating the comment: #{e.message}"
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_path, alert: 'Comment not found.'
  rescue StandardError => e
    redirect_to comments_path, alert: "An error occurred while updating the comment: #{e.message}"
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_path, alert: 'Comment not found.'
  rescue StandardError => e
    redirect_to comments_path, alert: "An error occurred while deleting the comment: #{e.message}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_path, alert: 'Comment not found.'
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :user_id, :post_id)
  end
end

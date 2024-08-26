# frozen_string_literal: true

class ChangeCommentFields < ActiveRecord::Migration[7.1]
  def change
    change_column :comments, :user_id, :bigint
    change_column :comments, :post_id, :bigint
  end
end

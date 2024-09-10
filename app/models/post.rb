# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1, maximum: 30 }
  validates :description, presence: true, length: { minimum: 1, maximum: 500 }
  validates :keywords, presence: true, length: { minimum: 1, maximum: 100 }
  has_many_attached :images
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end

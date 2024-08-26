# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1, maximum: 30 }
  validates :description, presence: true, length: { minimum: 1, maximum: 500 }
  validates :keywords, presence: true, length: { minimum: 1, maximum: 100 }
  has_many_attached :images
  belongs_to :user

  before_create :randomize_id

  private

  def randomize_id
    loop do
      self.id = SecureRandom.random_number(1_000_000_000)
      break unless User.where(id: id).exists?
    end
  end
end

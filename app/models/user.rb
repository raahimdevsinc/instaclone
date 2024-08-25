# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts

  before_create :randomize_id

  private

  def randomize_id
    loop do
      self.id = SecureRandom.random_number(1_000_000_000)
      break unless User.where(id: id).exists?
    end
  end
end
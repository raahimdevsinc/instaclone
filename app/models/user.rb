# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  followability
  has_many :posts
  has_many :comments
  has_one_attached :avatar
  has_many :likes
  before_create :randomize_id

  def follow(user)
    raise 'Cannot follow yourself' if self == user

    following << user
    user.followers << self
  end

  def unfollow(user)
    followerable_relationships.where(followable_id: user.id).destroy_all
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[email username]
  end

  def can_follow?(other_user)=!following?(other_user) && self != other_user
end

  private

def randomize_id
  loop do
    self.id = SecureRandom.random_number(1_000_000_000)
    break unless User.where(id: id).exists?
  end
end

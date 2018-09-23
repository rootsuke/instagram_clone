class Micropost < ApplicationRecord
  belongs_to :user

  has_many :favorites, foreign_key: "favorite_post_id", dependent: :destroy
  # post.favorites.map(&:favorite_user)
  has_many :favorite_users, through: :favorites, source: :favorite_user

  default_scope -> {order(created_at: :desc)}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end

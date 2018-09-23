class Favorite < ApplicationRecord
  belongs_to :favorite_user, class_name: "User"
  belongs_to :favorite_post, class_name: "Micropost"

  validates :favorite_user_id, presence: true
  validates :favorite_post_id, presence: true
end

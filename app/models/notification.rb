class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notified_by, class_name: "User"
  belongs_to :micropost, optional: true

  validates :user_id, presence: true
  validates :notified_by_id, presence: true
  validates :notification_type, presence: true

  validates :notified_by_id, uniqueness: {scope: :micropost_id}, if: -> {notification_type == "favorite"}
  validates :notified_by_id, uniqueness: {scope: :user_id}, if: -> {notification_type == "follow"}

  default_scope -> {order(created_at: :desc)}

end

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notified_by, class_name: "User"

  validates :user_id, presence: true
  validates :notified_by_id, presence: true
  validates :notification_type, presence: true

  default_scope -> {order(created_at: :desc)}

end

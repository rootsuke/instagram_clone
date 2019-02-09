class NotificationsController < ApplicationController
  before_action :logged_in_user

  def index
    @notifications = current_user.notifications.paginate(page: params[:page])
    unread_notifications = current_user.notifications.where(read: false)
    if unread_notifications
      unread_notifications.each do |notification|
        notification.update_attribute(:read, true)
      end
    end
  end
end

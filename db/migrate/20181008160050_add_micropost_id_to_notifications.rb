class AddMicropostIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :micropost_id, :integer
  end
end

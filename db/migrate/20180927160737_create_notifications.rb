class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.boolean :read, default: false
      t.string :type
      t.integer :notified_by_id

      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, :notified_by_id
  end
end

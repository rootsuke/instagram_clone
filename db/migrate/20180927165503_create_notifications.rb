class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.boolean :read, default: false
      t.string :type
      t.integer :notify_user_id

      t.timestamps
    end
    
    add_index :notifications, :notify_user_id
  end
end

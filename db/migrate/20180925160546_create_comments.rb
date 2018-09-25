class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.integer :reply_to

      t.timestamps
    end

    add_index :comments, [:user_id, :created_at]
    add_index :comments, :reply_to

  end
end

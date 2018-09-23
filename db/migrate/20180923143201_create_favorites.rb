class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.integer :favorite_user_id
      t.integer :favorite_post_id

      t.timestamps
    end

    add_index :favorites, :favorite_user_id
    add_index :favorites, :favorite_post_id
    add_index :favorites, [:favorite_user_id, :favorite_post_id], unique: true
  end
end

class AddProfileToUsers < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :website, :string
    add_column :users, :self_introduction, :text
    add_column :users, :telephone_number, :string
    add_column :users, :gender, :string
  end
end

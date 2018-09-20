class AddFullNameColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :full_name, :string

    add_index :users, :full_name
  end
end

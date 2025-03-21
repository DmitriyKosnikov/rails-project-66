class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :name
      t.string :email, null: false
      t.string :image_url
      t.string :token

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end

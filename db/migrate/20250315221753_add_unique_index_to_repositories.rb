class AddUniqueIndexToRepositories < ActiveRecord::Migration[8.0]
  def change
    add_index :repositories, :github_id, unique: true
  end
end

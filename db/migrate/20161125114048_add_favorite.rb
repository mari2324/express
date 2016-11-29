class AddFavorite < ActiveRecord::Migration[5.0]
  def change
    add_column :histories, :favorite, :boolean, default: false
  end
end

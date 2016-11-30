class AddComment < ActiveRecord::Migration[5.0]
  def change
    add_column :histories, :comment, :string
  end
end

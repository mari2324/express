class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.float :x
      t.float :y
      t.timestamps null: false
    end
  end
end

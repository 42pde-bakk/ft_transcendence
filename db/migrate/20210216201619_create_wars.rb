class CreateWars < ActiveRecord::Migration[6.1]
  def change
    create_table :wars do |t|
      t.references :guild1, null: false
      t.references :guild2, null: false
      t.boolean :finished, default: false
      t.boolean :accepted, default: false

      t.timestamps
    end
    add_foreign_key :wars, :guilds, column: :guild1_id, primary_key: :id
    add_foreign_key :wars, :guilds, column: :guild2_id, primary_key: :id
  end
end

class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :player1, null: false
      t.references :player2, null: true

      t.integer :room_nb

      t.timestamps
    end
    add_foreign_key :games, :users, column: :player1_id, primary_key: :id
    add_foreign_key :games, :users, column: :player2_id, primary_key: :id
  end
end

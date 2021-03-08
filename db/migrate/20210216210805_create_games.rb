class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :player1, references: :users
      t.references :player2, references: :users
      t.string :name_player1
      t.string :name_player2
      t.string :gametype
      t.boolean :long_paddles
      t.boolean :extra_speed
      t.timestamps
    end
    # add_foreign_key :games, :users, column: :player1_id, primary_key: :id
    # add_foreign_key :games, :users, column: :player2_id, primary_key: :id
  end
end

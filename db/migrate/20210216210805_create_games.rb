class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :player1, references: :users
      t.references :player2, references: :users
      t.string :name_player1
      t.string :name_player2
      t.string :winner, default: "Noone"
      t.string :gametype, default: "casual"
      t.boolean :is_finished, default: false
      t.boolean :long_paddles, default: false
      t.boolean :extra_speed, default: false
      t.timestamps
    end
  end
end

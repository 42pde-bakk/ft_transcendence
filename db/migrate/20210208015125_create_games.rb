class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :room_nb
      t.string :user1
      t.string :user2

      t.timestamps
    end
  end
end

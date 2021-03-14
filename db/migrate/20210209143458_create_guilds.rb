class CreateGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :guilds do |t|
      t.string :name
      t.string :anagram
      t.integer :max_battle_invites, default: 5
      t.integer :points, default: 50

      t.timestamps
    end
  end
end

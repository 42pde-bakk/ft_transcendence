class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :img_path, default: "https://img2.cgtrader.com/items/2043799/e1982ff5ee/star-wars-rogue-one-solo-stormtrooper-helmet-3d-model-stl.jpg"
      t.string :token
      t.integer :elo, default: 1500
      t.integer :guild_id
      t.boolean :guild_owner, default: false
      t.boolean :guild_officer, default: false
      t.boolean :guild_validated, default: false
      t.boolean :tfa
      t.boolean :reg_done
      t.boolean :current
      t.datetime :last_seen
      t.boolean :is_ingame, default: false
      t.boolean :is_queueing, default: false

      t.timestamps
    end
  end
end

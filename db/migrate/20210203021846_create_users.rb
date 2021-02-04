class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :img_path
      t.string :token
      t.integer :guild_id
      t.boolean :tfa
      t.boolean :reg_done

      t.timestamps
    end
  end
end

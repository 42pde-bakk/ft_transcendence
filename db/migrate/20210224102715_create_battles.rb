class CreateBattles < ActiveRecord::Migration[6.1]
  def change
    create_table :battles do |t|
      t.references :user1, null: false
      t.references :user2, null: false
      t.boolean :finished, default: false
      t.boolean :accepted, default: false
      t.integer :winner_id
      t.datetime :time_to_accept

      t.timestamps
    end
    add_foreign_key :battles, :users, column: :user1_id, primary_key: :id
    add_foreign_key :battles, :users, column: :user2_id, primary_key: :id
  end
end

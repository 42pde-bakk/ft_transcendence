class CreateWars < ActiveRecord::Migration[6.1]
  def change
    create_table :wars do |t|
      t.references :guild1, null: false
      t.references :guild2, null: false
      t.boolean :finished, default: false
      t.boolean :accepted, default: false

      t.datetime :start
      t.datetime :end
      t.integer :prize
      t.integer :g1_points, default: 0
      t.integer :g2_points, default: 0
      t.datetime :wt_begin
      t.datetime :wt_end
      t.integer :time_to_answer, default: 10 # in min
      t.integer :max_unanswered_match_calls, default: 5
      t.integer :g1_unanswered_match_calls, default: 0
      t.integer :g2_unanswered_match_calls, default: 0
      t.boolean :ladder, default: false
      t.boolean :tournament, default: false
      t.boolean :duel, default: false
      t.boolean :extra_speed, default: false
      t.boolean :long_paddles, default: false
      t.integer :winning_guild_id

      t.timestamps
    end
    add_foreign_key :wars, :guilds, column: :guild1_id, primary_key: :id
    add_foreign_key :wars, :guilds, column: :guild2_id, primary_key: :id
  end
end

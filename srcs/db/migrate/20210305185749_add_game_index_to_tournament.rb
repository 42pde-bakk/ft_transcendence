class AddGameIndexToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :game_index, :integer
  end
end

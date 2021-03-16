class AddTournamentToGame < ActiveRecord::Migration[6.1]
  def change
    add_reference :games, :tournament, index: true
  end
end

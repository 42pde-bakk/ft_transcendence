class AddTournamentToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :tournament, index: true
  end
end

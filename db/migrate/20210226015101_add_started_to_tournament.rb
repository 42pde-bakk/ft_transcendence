class AddStartedToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :started, :boolean
  end
end

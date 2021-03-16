class AddGameplayfeaturesToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :extra_speed, :boolean
    add_column :tournaments, :long_paddle, :boolean
  end
end

class AddAdditionalGameFeaturesToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament, :extra_speed, :boolean
    add_column :tournament, :long_paddle, :boolean
  end
end

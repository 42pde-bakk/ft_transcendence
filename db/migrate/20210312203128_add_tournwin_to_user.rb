class AddTournwinToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tourn_win, :integer
  end
end

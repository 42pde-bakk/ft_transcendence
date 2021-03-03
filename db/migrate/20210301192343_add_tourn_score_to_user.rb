class AddTournScoreToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tourn_score, :integer
  end
end

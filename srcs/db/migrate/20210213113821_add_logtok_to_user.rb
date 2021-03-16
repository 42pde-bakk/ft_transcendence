class AddLogtokToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :log_token, :integer
  end
end

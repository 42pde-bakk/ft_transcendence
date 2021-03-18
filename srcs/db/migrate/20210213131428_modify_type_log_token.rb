class ModifyTypeLogToken < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :log_token
    add_column :users, :log_token, :string
  end
end

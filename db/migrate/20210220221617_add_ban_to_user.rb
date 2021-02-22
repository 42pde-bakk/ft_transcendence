class AddBanToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ban, :boolean
  end
end

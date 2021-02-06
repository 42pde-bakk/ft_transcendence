class DeleteImage < ActiveRecord::Migration[6.1]
  def change
    remove_column  :users, :image
  end
end

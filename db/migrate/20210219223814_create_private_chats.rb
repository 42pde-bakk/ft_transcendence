class CreatePrivateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :private_chats do |t|
      t.references :user1, references: :users
      t.references :user2, references: :users
      t.timestamps
    end
  end
end

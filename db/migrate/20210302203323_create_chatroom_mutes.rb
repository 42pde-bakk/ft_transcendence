class CreateChatroomMutes < ActiveRecord::Migration[6.1]
  def change
    create_table :chatroom_mutes do |t|
      t.references :chatroom, references: :chatrooms
      t.references :user, references: :users
      t.timestamps
    end
  end
end

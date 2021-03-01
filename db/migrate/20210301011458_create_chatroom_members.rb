class CreateChatroomMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :chatroom_members do |t|
      # t.references :user, references: :users
      # t.references :chatroom, references: :chatrooms
      t.belongs_to :chatroom, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end

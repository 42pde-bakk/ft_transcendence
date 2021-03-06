class CreateChatroomMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :chatroom_members do |t|
      t.references :chatroom, references: :chatrooms
      t.references :user, references: :users
      t.timestamps
    end
  end
end

# t.belongs_to :chatroom, index: true
# t.belongs_to :user, index: true

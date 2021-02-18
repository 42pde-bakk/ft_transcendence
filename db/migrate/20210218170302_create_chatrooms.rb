class CreateChatrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chatrooms do |t|
	    t.references :user1, references: :users
	    t.references :user2, references: :users

      t.timestamps
    end
  end
end

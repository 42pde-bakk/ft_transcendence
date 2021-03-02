class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :user, references: :users
      t.references :chatroom, references: :chatrooms
      t.text :msg
      t.timestamps
    end
    # add_reference :messages, :user, foreign_key: true
    # add_foreign_key :messages, :users
  # add_foreign_key :users, :messages, column: :user_id
  end
end

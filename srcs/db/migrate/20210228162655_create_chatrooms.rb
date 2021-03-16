class CreateChatrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chatrooms do |t|
      t.string :name
      t.references :owner, index: true, foreign_key: { to_table: :users}
      t.boolean :is_private
      t.string :password
      t.boolean :is_subscribed
      t.bigint :amount_members
      t.timestamps
    end
  end
end

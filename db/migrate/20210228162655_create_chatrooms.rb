class CreateChatrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chatrooms do |t|
      t.string :name
      t.references :owner, index: true, foreign_key: { to_table: :users}
      t.boolean :isprivate
      t.string :password
      t.bigint :amount_members
      t.timestamps
    end
  end
end

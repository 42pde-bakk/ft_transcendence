class CreateBlockedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :blocked_users do |t|
      t.references :user
      t.references :towards, references: :users, foreign_key: { to_table: :users}
      t.timestamps
    end
  end
end

class CreatePrivateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :private_messages do |t|
      t.references :from, references: :users
      t.text :message
      t.timestamps
    end
  end
end

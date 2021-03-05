class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.boolean :is_accepted
      t.string :kind
      t.string :name_sender
      t.string :name_receiver
      t.references :sender, references: :users
      t.references :receiver, references: :users

      t.timestamps
    end
  end
end

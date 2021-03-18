class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.boolean :is_accepted, default: false
      t.boolean :is_declined, default: false
      t.string :kind
      t.string :description
      t.string :name_sender
      t.string :name_receiver
      t.references :sender, references: :users
      t.references :receiver, references: :users
      t.references :war, references: :wars
      t.boolean :extra_speed
      t.boolean :long_paddles
      t.timestamps
    end
  end
end

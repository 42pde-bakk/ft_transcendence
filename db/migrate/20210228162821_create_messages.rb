class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :from, references: :users
      t.text :msg
      t.timestamps
    end
  end
end

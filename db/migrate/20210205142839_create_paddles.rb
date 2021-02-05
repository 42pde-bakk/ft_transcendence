class CreatePaddles < ActiveRecord::Migration[6.1]
  def change
    create_table :paddles do |t|

      t.timestamps
    end
  end
end

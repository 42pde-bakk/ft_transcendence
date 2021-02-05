class CreateBalls < ActiveRecord::Migration[6.1]
  def change
    create_table :balls do |t|

      t.timestamps
    end
  end
end

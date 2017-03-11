class CreateLongTermGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :long_term_goals do |t|
      t.references :user, foreign_key: true
      t.text :category
      t.integer :timeframe
      t.text :content

      t.timestamps
    end
  end
end

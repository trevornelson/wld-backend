class CreateShortTermGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :short_term_goals do |t|
      t.references :user, foreign_key: true
      t.integer :long_term_goal_id
      t.text :category
      t.text :content

      t.timestamps
    end
  end
end

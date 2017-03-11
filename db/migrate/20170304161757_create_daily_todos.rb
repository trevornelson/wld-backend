class CreateDailyTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_todos do |t|
      t.references :user, foreign_key: true
      t.date :due_date
      t.text :content
      t.boolean :completed

      t.timestamps
    end
  end
end

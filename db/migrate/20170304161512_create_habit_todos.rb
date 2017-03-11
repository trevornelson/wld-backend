class CreateHabitTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :habit_todos do |t|
      t.references :user, foreign_key: true
      t.references :habit, foreign_key: true
      t.date :due_date
      t.boolean :completed

      t.timestamps
    end
  end
end

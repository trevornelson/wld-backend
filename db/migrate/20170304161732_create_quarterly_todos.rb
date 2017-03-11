class CreateQuarterlyTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :quarterly_todos do |t|
      t.references :user, foreign_key: true
      t.text :category
      t.text :content

      t.timestamps
    end
  end
end

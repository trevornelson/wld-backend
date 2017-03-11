class CreateHabits < ActiveRecord::Migration[5.0]
  def change
    create_table :habits do |t|
      t.references :user, foreign_key: true
      t.boolean :active
      t.text :content

      t.timestamps
    end
  end
end

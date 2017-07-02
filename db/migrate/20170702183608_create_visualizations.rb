class CreateVisualizations < ActiveRecord::Migration[5.0]
  def change
    create_table :visualizations do |t|
      t.integer :user_id
      t.string :caption
      t.string :url

      t.timestamps
    end
  end
end

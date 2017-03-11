class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.integer :relationship_category_id
      t.text :content

      t.timestamps
    end
  end
end

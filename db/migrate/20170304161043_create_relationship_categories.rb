class CreateRelationshipCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :relationship_categories do |t|
      t.references :user, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end

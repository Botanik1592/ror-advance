class CreateRatingTableAndAddReferencesToModels < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.references :ratable, polymorphic: true, index: true
      t.references :user, foreign_key: true
      t.integer :ratings

      t.timestamps
    end
  end
end

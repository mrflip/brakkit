class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.string :name
      t.text :description
      t.belongs_to :bracket
      t.integer :seed
      t.string :handle
      t.text :settings

      t.timestamps
    end
    add_index :contestants, :bracket_id
  end
end

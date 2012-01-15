class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      t.text :ordering
      t.boolean :closed
      t.belongs_to :tournament

      t.timestamps
    end
    add_index :brackets, :tournament_id
  end
end

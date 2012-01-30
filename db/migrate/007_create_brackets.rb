class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      #
      t.belongs_to :tournament
      #
      t.boolean    :closed
      #
      t.text       :settings
      t.timestamps
    end
    add_index :brackets, :tournament_id
  end
end

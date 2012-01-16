class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.string     :name
      t.string     :handle
      t.text       :description
      #
      t.belongs_to :bracket
      #
      t.integer    :seed
      #
      t.text       :settings
      t.timestamps
    end
    add_index :contestants, :bracket_id
    add_index :contestants, :handle, :unique => true
  end
end

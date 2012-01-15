class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.text :description
      t.belongs_to :user
      t.string :state

      t.timestamps
    end
    add_index :tournaments, :user_id
  end
end

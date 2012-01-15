class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end

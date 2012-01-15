class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string     :name,        :null => false
      t.text       :description, :null => false, :default => ''
      t.integer    :size
      t.belongs_to :user,        :null => false
      t.string     :state,       :null => false, :default => 'preparing'
      t.string     :handle,      :null => false
      t.text       :settings

      t.timestamps
    end
    add_index      :tournaments, :user_id
  end
end

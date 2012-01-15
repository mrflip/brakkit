class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.belongs_to :user,        :null => false
      t.string     :name,        :null => false
      t.text       :description, :null => false, :default => ''
      #
      t.integer    :size,        :null => false, :default => 64
      t.integer    :duration,    :null => false, :default => 7
      t.integer    :visibility,  :null => false, :default => 'public'
      t.string     :state,       :null => false, :default => 'development'
      #
      t.string     :handle,      :null => false
      t.text       :settings

      t.timestamps
    end
    add_index      :tournaments, :user_id
  end
end

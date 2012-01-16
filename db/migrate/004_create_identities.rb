class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string  :handle
      #
      t.integer :user_id
      t.string  :provider
      t.text    :data
      #
      t.timestamps
    end
    add_index :identities, [:user_id, :provider]
    add_index :identities, [:handle,  :provider]
  end
end

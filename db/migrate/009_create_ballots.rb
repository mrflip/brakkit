class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.text :outcomes
      t.belongs_to :bracket

      t.timestamps
    end
    add_index :ballots, :bracket_id
  end
end

class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.integer :voter_id, null: false
      t.references :votable, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index :votes, :voter_id
    add_index :votes, [:voter_id, :votable_id, :votable_type], unique: true
  end
end

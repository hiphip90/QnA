class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :votable_type
      t.integer :votable_id
      t.integer :value
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :votes, :votable_id
    add_index :votes, :user_id
  end
end

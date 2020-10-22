class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.references :user
      t.integer :votes

      t.timestamps 
    end
  end
end

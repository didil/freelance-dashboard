class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :description
      t.integer :num_proposals
      t.string :keywords

      t.timestamps
    end
  end
end

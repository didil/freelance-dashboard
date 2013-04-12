class AddPostedAtToJobs < ActiveRecord::Migration
  def up
    remove_column :jobs , :date_posted
    add_column :jobs , :posted_at , :datetime
  end

  def down
    remove_column :jobs , :posted_at
    add_column :jobs , :date_posted , :date
  end
end

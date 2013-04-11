class AddIndexToJobsRequests < ActiveRecord::Migration
  def up
    add_index :jobs_requests , :keyword , :unique => true
  end

  def down
    remove_index :jobs_requests , :keyword
  end
end

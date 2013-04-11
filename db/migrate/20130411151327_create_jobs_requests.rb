class CreateJobsRequests < ActiveRecord::Migration
  def change
    create_table :jobs_requests do |t|
      t.string :keyword
      t.datetime :requested_at

      t.timestamps
    end
  end
end

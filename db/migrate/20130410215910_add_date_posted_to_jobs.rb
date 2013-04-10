class AddDatePostedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :date_posted, :datetime
  end
end

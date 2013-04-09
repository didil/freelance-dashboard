class AddPlatformToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :platform, :string
  end
end

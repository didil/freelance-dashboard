class ChangeDatePostedFromDatetimeToDateInJobs < ActiveRecord::Migration
  def up
    change_column :jobs , :date_posted , :date
  end

  def down
    change_column :jobs , :date_posted , :datetime
  end
end

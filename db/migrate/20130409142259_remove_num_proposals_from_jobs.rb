class RemoveNumProposalsFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :num_proposals
  end

  def down
    add_column :jobs, :num_proposals, :integer
  end
end

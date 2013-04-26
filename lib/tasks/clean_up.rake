namespace :clean_up do
  desc "Delete jobs older than 2 days"
  task :jobs => :environment do
    Job.where("created_at < ?" , 2.days.ago).destroy_all
  end
end



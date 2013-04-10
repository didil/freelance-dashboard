module JobFeedHelper
  def first_job_id jobs
    if jobs and !jobs.empty?
      jobs.first.id
    else
      0
    end
  end
end

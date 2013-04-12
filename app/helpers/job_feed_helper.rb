module JobFeedHelper
  def first_job_id jobs
    if jobs and !jobs.empty?
      jobs.map(&:id).max
    else
      0
    end
  end

  def display_job_date_posted job
    response = "Posted on : "
    response += job.date_posted.strftime("%B, %-d %Y") unless job.date_posted.nil?
  end
end

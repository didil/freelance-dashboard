module JobsHelper
  def display_job_description job
    response =""
    max_length = 300
    response += sanitize truncate(job.description, :length => max_length)
    if job.description.length > max_length
      response += link_to "Read more", jobs_path(job), :remote => true
    end
    raw (response)
  end

  def display_job_posted_at job
    response = "Posted on : "
    response += job.posted_at.to_s unless job.posted_at.nil?
  end
end

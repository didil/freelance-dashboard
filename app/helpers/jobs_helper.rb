module JobsHelper
  def display_job_description job
    response =""
    max_length = 300
    response += truncate(job.description, :length => max_length)
    if job.description.length > max_length
      response += link_to "Read more", jobs_path(job), :remote => true
    end
    raw (response)
  end
end

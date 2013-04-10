class Job < ActiveRecord::Base
  attr_accessible :description, :keywords, :title, :platform, :link

  def self.update_all_jobs
    Keyword.uniq.pluck(:content).each do |keyword|
      update_jobs(keyword)
    end
  end

  def self.update_jobs(keyword)
    update_odesk_jobs(keyword)
    # update_elance_jobs(keyword)
  end

  def self.update_odesk_jobs(keyword)
    rd = RubyDesk::Connector.new("api_key", "api_secret")
    jobs = RubyDesk::Job.search(rd, q: keyword, page: "0;20").map do |j|
      Job.new(title: j.op_title,
              description: j.op_description,
              keywords: j.op_required_skills.downcase,
              link: "http://www.odesk.com/jobs/#{j.ciphertext}",
              platform: "oDesk")
    end

    save_new_jobs(jobs)
  end

  def self.save_new_jobs(jobs)
    jobs.each do |j|
      j.save unless Job.exists?(title: j.title)
    end
  end

end

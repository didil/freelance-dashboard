require 'open-uri'

class Job < ActiveRecord::Base
  attr_accessible :description, :keywords, :title, :platform, :link, :posted_at

  validates_presence_of :description, :keywords, :title, :platform, :link, :posted_at

  PLATFORMS = %w{odesk elance}

  def self.update_all_jobs
    Keyword.uniq.pluck(:content).each do |keyword|
      update_jobs(keyword)
    end
  end

  def self.update_jobs(keyword)
    PLATFORMS.each do |platform|
      jobs = self.send("fetch_#{platform}_jobs".to_sym, keyword)
      save_new_jobs(jobs)
    end
    JobsRequest.find_or_create_by_keyword(keyword).update_attribute(:requested_at, Time.now)
  end

  private

  def self.fetch_odesk_jobs(keyword)
    jobs =[]
    begin
      rd = RubyDesk::Connector.new("api_key", "api_secret")
      jobs = RubyDesk::Job.search(rd, q: keyword, page: "0;20").map do |j|
        j = Job.new(title: j.op_title,
                    description: j.op_description,
                    keywords: j.op_required_skills.downcase,
                    link: "http://www.odesk.com/jobs/#{j.ciphertext}",
                    posted_at: DateTime.parse("#{j.date_posted} #{j.op_time_posted} #{j.op_time_posted}"),
                    platform: "oDesk")
        j.keywords += ", #{keyword}" unless j.keywords.include? keyword
        j
      end
    rescue StandardError => ex
      logger.debug "Failed to fetch odesk jobs : " + ex.message
    end
    # reverse to allow most recent to be written to db last
    jobs.reverse
  end

  def self.fetch_elance_jobs(keyword)
    jobs= []
    begin
      doc = Nokogiri::HTML(open("https://www.elance.com/r/jobs/q-#{keyword}"))
      doc.css("div.jobCard").each do |div|
        j= Job.new
        j.title = div.css('a.title').first.content
        j.description= div.css('.desc').first.content
        j.keywords= div.css('span.skilllist').first.content.downcase
        j.keywords += ", #{keyword}" unless j.keywords.include? keyword
        j.link= div.css('a.title').first.attr('href')
        stats_div_content = div.css('div.stats').first.content
        stats_div_content =~ /Posted: ([^\|]+)/
        match =$1
        if match =~ /(.+) ago/
          match = $1
          if match =~ /(\d+) minutes/
            j.posted_at= $1.to_i.minutes.ago
          elsif match =~ /(\d+)h, (\d+)m/
            j.posted_at= Time.now - $1.to_i.hours - $2.to_i.minutes
          end
        else
          stats_div_content =~ /Posted: ([^\|]+)/
          j.posted_at= $1.strip
        end
        j.platform= "Elance"
        jobs << j
      end
    rescue StandardError => ex
      logger.debug "Failed to fetch elance jobs : " + ex.message
    end
    # reverse to allow most recent to be written to db last
    jobs.reverse!
  end

  def self.save_new_jobs(jobs)
    jobs.each do |j|
      j.save unless Job.exists?(title: j.title)
    end
  end

end

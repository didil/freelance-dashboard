class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :keywords

  def jobs (id=0)
    output = []
    return output unless self.keywords.any?
    self.keywords.each do |keyword|
      if keyword.outdated?
        Job.update_jobs keyword.content
      end

      Job.where("keywords like ? and id > ?", "%#{keyword.content}%", id)
      .order("date_posted DESC")
      .order("created_at DESC").each { |j| output << j }
    end
    output
  end

end

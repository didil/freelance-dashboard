class Keyword < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user

  validates_presence_of :content, :user_id

  def existing?
    Keyword.where(content: content, user_id: user_id).any?
  end
end

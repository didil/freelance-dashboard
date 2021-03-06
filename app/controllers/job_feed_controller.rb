class JobFeedController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.keywords.empty?
      flash.now[:notice] = "Add a keyword to activate your job feed"
    end

    @keywords = current_user.keywords
    @keyword = Keyword.new
    @jobs = current_user.jobs :skip_updates => true
  end

  def refresh
    @new_jobs = current_user.jobs(:id => params[:id])
    @jobs = current_user.jobs

    respond_to do |format|
      format.js
      format.html { redirect_to root_path}
    end
  end
end

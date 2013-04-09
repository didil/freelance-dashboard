class JobsController < ApplicationController
  before_filter :authenticate_user!

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'

    Job.update_all_jobs
    flash[:notice] = "Jobs updated"

    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
end

class KeywordsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @keyword = Keyword.new
    @keyword.content = params[:keyword][:content].downcase
    @keyword.user = current_user

    if @keyword.existing?
      flash[:alert] = "Cannot add a keyword twice"
    elsif !@keyword.save
        flash[:alert] = "Couldn't add the keyword"
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :partial => "job_feed/reload",
                         :locals => {:jobs => current_user.jobs,
                                     :keywords => current_user.keywords}
      }
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])

    unless @keyword.user_id == current_user.id and @keyword.destroy
      flash[:alert] = "Couldn't add the keyword"
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :partial => "job_feed/reload",
                         :locals => {:jobs => current_user.jobs,
                                     :keywords => current_user.keywords}
      }
    end
  end
end

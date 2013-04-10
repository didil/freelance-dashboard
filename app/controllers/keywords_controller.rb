class KeywordsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @keyword = Keyword.new
    @keyword.content = params[:keyword][:content].downcase
    @keyword.user = current_user

    if @keyword.existing?
      respond_to do |format|
        flash[:alert] = "Cannot add a keyword twice"
        format.html { redirect_to root_path }
        format.js
      end
      return
    end

    respond_to do |format|
      if @keyword.save
        format.html { redirect_to root_path }
        format.js
      else
        format.html { redirect_to root_path, :alert => "Couldn't add the keyword" }
        format.js
      end
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      if @keyword.user_id == current_user.id and @keyword.destroy
        format.html { redirect_to root_path }
        format.js { @keywords = current_user.keywords }
      else
        format.html { redirect_to root_path, :alert => "Couldn't delete the keyword" }
        format.js
      end
    end
  end
end

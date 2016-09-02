class WebsitesController < ApplicationController

  def create
    @website = current_user.websites.build(website_params)
    WebsiteAddJob.perform_async(@website) if @website.save
    redirect_to root_url
  end

  def show
    @alexa_rank =  Website.find(params[:id]).alexaranks.all

    respond_to do |format|
      format.js
    end
  end

  def destroy
    id = params[:id]
    Website.destroy(id)
    Alexarank.where(website_id: id).destroy_all
    redirect_to root_url
  end

  private
    def website_params
      params.require(:website).permit(:url, :user_id)
    end
end

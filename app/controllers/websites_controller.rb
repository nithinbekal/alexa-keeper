class WebsitesController < ApplicationController
  def create
    already_exist = Website.find_by(url: params[:website][:url])
    if already_exist && params[:website][:collection_id]
      website = CollectionWebsite.where("collection_id = ?", params[:website][:collection_id])
                                 .where("website_id = ?", already_exist.id)
                                 .first
      if website.nil?
        CollectionWebsite.create!(collection_id: params[:website][:collection_id], website_id: already_exist.id)
      end
      @sites_count=CollectionWebsite.count('id')
      if Statistic.exists?
        Statistic.first.update_attribute(:sites, @sites_count) 
      else
        Statistic.create(sites: @sites_count)
      end
      @site_name=[]
        current_user.websites.each do |website|
          @site_name << website.url
        end
      @each_user_sites=current_user.websites.count
      if User.exists?
        current_user.update(sites: @site_name)
        current_user.update(site_number: @each_user_sites)
      else
        current_user.create(sites: @site_name)
        current_user.create(site_number: @each_user_sites)
      end
      redirect_to root_url
    else
      @website = Website.new(website_create_params)
      if @website.save
        CollectionWebsite.create(collection_id: params[:website][:collection_id],
                                   website_id: @website.id)
        @sites_count=CollectionWebsite.count('id')
        if Statistic.exists?
          Statistic.first.update_attribute(:sites, @sites_count) 
        else
          Statistic.create(sites: @sites_count)
        end
        @site_name=[]
          current_user.websites.each do |website|
            @site_name << website.url
          end
        @each_user_sites=current_user.websites.count
        if User.exists?
          current_user.update(sites: @site_name)
          current_user.update(site_number: @each_user_sites)
        else
          current_user.create(sites: @site_name)
          current_user.create(site_number: @each_user_sites)
        end
        FetchRankJob.perform_later(@website)
        redirect_to root_url
      end
   end
  end
  def show
    website          = Website.find(params[:id])
    @alexa_rank_json = WebsitesHelper.createJSON(website)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    CollectionWebsite.where(collection_id: params[:collection_id]).where(website_id: params[:id]).first.destroy
    @site_name=[]
      current_user.websites.each do |website|
        @site_name << website.url
      end
    @each_user_sites=current_user.websites.count
    if User.exists?
      current_user.update(sites: @site_name)
      current_user.update(site_number: @each_user_sites)
    else
      current_user.create(sites: @site_name)
      current_user.create(site_number: @each_user_sites)
    end
    @sites_count=CollectionWebsite.count('id')
    if Statistic.exists?
      Statistic.first.update_attribute(:sites, @sites_count) 
    else
      Statistic.create(sites: @sites_count)
    end
      redirect_to root_url
  end
  private
    def website_params
      params.require(:website).permit(:url, :user_id, :collection_id)
    end
    def website_create_params
      website_params.select{|x| Website.attribute_names.index(x)}
    end
end

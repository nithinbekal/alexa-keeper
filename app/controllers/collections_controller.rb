class CollectionsController < ApplicationController
  protect_from_forgery
  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      @list_count=Collection.count('id')
      @each_user_lists=current_user.collections.count
      if User.exists?
        current_user.update(list_number: @each_user_lists)
      else
        current_user.create(list_number: @each_user_lists)
      end
      if Statistic.exists?
        Statistic.update(lists: @list_count)
      else
        Statistic.create(lists: @list_count)
      end
    end
    redirect_to root_url
  end
 
  def destroy
    @collection = Collection.find(params[:id])
    @collection_sites = CollectionWebsite.where("collection_id = ?", @collection.id)
    @collection_sites.destroy_all 
    @collection.destroy
    @sites_count=CollectionWebsite.count('id')
    @list_count=Collection.count('id')
    if Statistic.exists?
      Statistic.first.update_attribute(:sites, @sites_count) 
      Statistic.update(lists: @list_count)
    else
      Statistic.create(sites: @sites_count)
      Statistic.create(lists: @list_count)
    end
    @site_name=[]
    current_user.websites.each do |website|
      @site_name << website.url
    end
    @each_user_lists=current_user.collections.count
    @each_user_sites=current_user.websites.count
    if User.exists?
      current_user.update(sites: @site_name)
      current_user.update(list_number: @each_user_lists)
      current_user.update(site_number: @each_user_sites)
    else
      current_user.update(sites: @site_name)
      current_user.create(list_number: @each_user_lists)
      current_user.create(site_number:@each_user_sites)
    end
    redirect_to root_url
  end
private
    def collection_params
      params.require(:collection).permit(:name, :user_id)
    end
  end

module Websites
  class Create
    # From the controller, use it like this:
    #
    # Websites::Create.call(params, user)
    def self.call(params, user)
      new(params, user).call
    end

    def initialize(params, user)
      @params = params
      @user = user
      @website = Website.where(url: params[:website][:url])
    end

    def call
      @descript = create_website
      update_statistics
      find_or_create_user
      fetch_rank
      @descript
    end

    
    private

    attr_reader :params, :user, :website

    def create_website
      @website = website.first_or_create
       CollectionWebsite.create(collection_id: collection_id, website_id: website.id)

      @descript = Website.fetch_metadescription(domain: params[:website][:url],website: website)
      @descript
    end

    def collection_id
      params[:website][:collection_id]
    end

    def update_statistics
      Statistic.update_statistics(sites: CollectionWebsite.count)
    end

    def find_or_create_user
      site_urls = user.websites.map(&:url)
      websites_count = user.websites.count
      user.update(sites: site_urls, site_number: websites_count)
    end

    def fetch_rank
      return if website.alexaranks.any?
      FetchRankJob.perform_later(website)
    end
  end
end
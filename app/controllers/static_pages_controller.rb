class StaticPagesController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        @user = User.all
      end
      @website = Website.new
      @urls = current_user.websites
      logger.info "In static controller page"
      @collection = Collection.new
      @collection_names = current_user.collections
      @collect = Collection.new
      @descript = session[:descript]
            
    end
  end

   def show

    web = current_user.websites
    if params[:collection_id].present?
      web = current_user.collections.find_by_id(params[:collection_id]).try(:websites)
    else
      web = current_user.websites
    end
    @alexa_rank_json = StaticPagesHelper.createJSON(web)
    respond_to do |format|
      format.html
      format.json { render json: @alexa_rank_json}
    end
  
  end

  def destroy
    id = params[:format]
    User.destroy(id)
    Website.where(user_id: id).destroy_all
    redirect_to root_url
  end
end

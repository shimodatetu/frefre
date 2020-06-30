class SearchController < ApplicationController
  def show
    per = 10
    page_id = params[:page].to_i
    if page_id.nil? || page_id.to_i < 1
      page_id = 1
    end
    @search_text = ""
    if session["search_text"].nil? == false && session["search_text"] != ""
      @search_text = session["search_text"]
    end
    @threadtypes = Threadtype.all
    if !@search_text.nil?
     @threadtypes = Threadtype.where("type_jp LIKE ? OR type_en LIKE ?", "%"+ @search_text +"%", "%"+ @search_text +"%")
    end

    if logged_in?
      search_users = User.where.not(id:current_user.id)
    else
      search_users = User.all
    end
    if !@search_text.nil?
      search_users = search_users.where("name LIKE ? OR user_search_id LIKE ?", "%"+ @search_text +"%","%"+ @search_text +"%")
    end
    if params[:id] == "1" || params[:id] == nil
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(page_id).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(1).per(per)
      @search_users = search_users.all.page(1).per(per)
    elsif params[:id] == "2"
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(1).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(page_id).per(per)
      @search_users = search_users.all.page(1).per(per)
    elsif params[:id] == "3"
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(1).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(1).per(per)
      @search_users = search_users.all.page(page_id).per(per)
    end
  end
end

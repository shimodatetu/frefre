class ProfileController < ApplicationController
  def show
    @user = User.new
    @users = User.all
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
    if params[:id] == nil || params[:id] == "1" || params[:id] == "2" || params[:id] == "3" || params[:id] == "4"
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i < 1
        page_id = 1
      end
      per = 10
      current_user_id = current_user.id
      if params[:id] == nil || params[:id] == "1"
        @join_groups = current_user.threadtypes.all.page(page_id).per(per)
        @make_groups = Threadtype.all.where(leader_id:current_user_id).page(1).per(per)
        @make_threads = current_user.groups.all.page(1).per(per)
        @make_posts = current_user.posts.all.page(1).per(per)
      elsif params[:id] == "2"
        @join_groups = current_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:current_user_id).page(page_id).per(per)
        @make_threads = current_user.groups.all.page(1).per(per)
        @make_posts = current_user.posts.all.page(1).per(per)
      elsif params[:id] == "3"
        @join_groups = current_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:current_user_id).page(1).per(per)
        @make_threads = current_user.groups.all.page(page_id).per(per)
        @make_posts = current_user.posts.all.page(1).per(per)
      elsif params[:id] == "4"
        @join_groups = current_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:current_user_id).page(1).per(per)
        @make_threads = current_user.groups.all.page(1).per(per)
        @make_posts = current_user.posts.all.page(page_id).per(per)
      end
    elsif params[:id] == "5"
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i < 1
        page_id = 1
      end
      per = 10
      @notices = current_user.notices.all.page(page_id).per(per)
    elsif params[:id] == "6"
      notice_id = params[:page1].to_i
      if !(@notice = Notice.find(params[:page1].to_i))
        @notice = current_user.notices.first
      end
      @from_user = notice.users.last
      @to_user = notice.users.first
      per = 10
      @chats = notice.chats.all.page(page_id).per(per)
    elsif params[:id] == "7"
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i < 1
        page_id = 1
      end
      per = 10
      @user_infos = current_user.news.all.page(page_id).per(per)
    elsif params[:id] == "9" || params[:id] == "10" || params[:id] == "11"
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i < 1
        page_id = 1
      end
      per = 10
      current_user_id = current_user.id

      @search_text = ""
      if session["search_text"].nil? == false && session["search_text"] != ""
        @search_text = session["search_text"]
      end
      users = User.all
      if !@search_text.nil?
       @search_users = users.where("name LIKE ?", "%"+ @search_text +"%")
      end

      if params[:id] == "9"
        @followings = current_user.followings.all.page(page_id).per(per)
        @followers = current_user.followings.all.page(1).per(per)
        @search_users = @search_users.all.page(1).per(per)
      elsif params[:id] == "10"
        @followings = current_user.followings.all.page(1).per(per)
        @followers = current_user.followings.all.page(page_id).per(per)
        @search_users = @search_users.all.page(1).per(per)
      elsif params[:id] == "11"
        @followings = current_user.followings.all.page(1).per(per)
        @followers = current_user.followings.all.page(1).per(per)
        @search_users = @search_users.all.page(page_id).per(per)
      end
    end
  end
  def retire
    current_user.update(usertype:"delete")
    current_user = nil
    session[:user_id] = nil
    redirect_to "/users/unsubscribe"
  end
  def update
    if params[:user]["photo"].nil?
      if current_user.update!(image:params[:user]["image"].to_i)
        redirect_to profile_path
      else
        render :show
      end
    else
      if current_user.update!(image:0, photo:params[:user]["photo"].read)
        redirect_to profile_path
      else
        render :show
      end
    end
  end
  private
  def user_params
    params.require(:user).permit(:image)
  end
  def image_params
    params.require(:user).permit(:photo)
  end
end

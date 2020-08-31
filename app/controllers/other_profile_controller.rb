class OtherProfileController < ApplicationController
  def show
    @other_profile_menu_show = true
    other_user = User.find_by(id:1)
    if User.find_by(id:params[:id].to_i)
      other_user = User.find_by(id:params[:id].to_i)
    end
    if params[:type] == nil || params[:type] == "1" || params[:type] == "2" || params[:type] == "3" || params[:type] == "4"
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i < 1
        page_id = 1
      end
      per = 10
      other_user_id = other_user.id
      if params["navlink"] == "popular" || (params["navlink"] == nil || params["navlink"] == "") && (params[:type] == nil || params[:type] == "1")
        @join_groups = other_user.threadtypes.all.page(page_id).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(1).per(per)
        @make_threads = other_user.groups.all.page(1).per(per)
        @make_posts = other_user.posts.all.page(1).per(per)
      elsif params["navlink"] == "group" || (params["navlink"] == nil || params["navlink"] == "") && params[:type] == "2"
        @join_groups = other_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(page_id).per(per)
        @make_threads = other_user.groups.all.page(1).per(per)
        @make_posts = other_user.posts.all.page(1).per(per)
      elsif params["navlink"] == "thread" || (params["navlink"] == nil || params["navlink"] == "") && params[:type] == "3"
        @join_groups = other_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(1).per(per)
        @make_threads = other_user.groups.all.page(page_id).per(per)
        @make_posts = other_user.posts.all.page(1).per(per)
      elsif params["navlink"] == "post" || (params["navlink"] == nil || params["navlink"] == "") && params[:type] == "4"
        @join_groups = other_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(1).per(per)
        @make_threads = other_user.groups.all.page(1).per(per)
        @make_posts = other_user.posts.all.page(page_id).per(per)
      end
    end
  end
end
:type
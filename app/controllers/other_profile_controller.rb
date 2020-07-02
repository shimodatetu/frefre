class OtherProfileController < ApplicationController
  def show
    other_user = User.find_by(id:1)
    if User.find_by(id:params[:id].to_i)
      other_user = User.find_by(id:params[:id].to_i)
    end
    if params[:id] == nil || params[:id] == "1" || params[:id] == "2" || params[:id] == "3" || params[:id] == "4"
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i < 1
        page_id = 1
      end
      per = 10
      other_user_id = other_user.id
      if params[:type] == nil || params[:id] == "1"
        @join_groups = other_user.threadtypes.all.page(page_id).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(1).per(per)
        @make_threads = other_user.groups.all.page(1).per(per)
        @make_posts = other_user.posts.all.page(1).per(per)
      elsif params[:type] == "2"
        @join_groups = other_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(page_id).per(per)
        @make_threads = other_user.groups.all.page(1).per(per)
        @make_posts = other_user.posts.all.page(1).per(per)
      elsif params[:type] == "3"
        @join_groups = other_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(1).per(per)
        @make_threads = other_user.groups.all.page(page_id).per(per)
        @make_posts = other_user.posts.all.page(1).per(per)
      elsif params[:type] == "4"
        @join_groups = other_user.threadtypes.all.page(1).per(per)
        @make_groups = Threadtype.all.where(leader_id:other_user_id).page(1).per(per)
        @make_threads = other_user.groups.all.page(1).per(per)
        @make_posts = other_user.posts.all.page(page_id).per(per)
      end
    end
  end
end

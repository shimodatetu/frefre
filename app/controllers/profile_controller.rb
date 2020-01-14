class ProfileController < ApplicationController
  def show
    @user = User.new
    @users = User.all
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
    if params[:id] == "2" || params[:id] == "3"
      thread_page_num = 20.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = current_user.groups.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page1].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
      page_max_half = (page_show_max / 2).ceil
      group_num = current_user.posts.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page2].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num2 = thread_page_num
      @page_id2 = page_id
      @page_num2 = page_num
      @start_num2 = start_num
      @end_num2 = end_num
    elsif params[:id] == "4"
      thread_page_num = 20.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = current_user.notices.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page1].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
    elsif params[:id] == "5"
      @chat = Chat.new
      notice_page = 1
      if !params[:page1].nil?
        notice_page = params[:page1]
      end
      @notice = Notice.find(notice_page.to_i)
      thread_page_num = 20.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = @notice.chats.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page2].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
    elsif params[:id] == "6"
      notice_page = 1
      if !params[:page1].nil?
        notice_page = params[:page1]
      end
      @infos = Userinfo.find_by(id:notice_page.to_i)
      thread_page_num = 20.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = current_user.userinfos.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page2].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
    elsif params[:id] == "8" || params[:id] == "9" || params[:id] == "10"
      thread_page_num = 20.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = current_user.followings.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page1].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
      page_max_half = (page_show_max / 2).ceil
      group_num = current_user.followers.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page2].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num2 = @thread_page_num
      @page_id2 = page_id
      @page_num2 = page_num
      @start_num2 = start_num
      @end_num2 = end_num
    else
      @thread_page_num = 0
      @page_id = 0
      @page_num = 0
      @start_num = 0
      @end_num = 0
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

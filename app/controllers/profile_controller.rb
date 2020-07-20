class ProfileController < ApplicationController
  def show
    if logged_in?
      @user = User.new
      @users = User.all
      gon.prohibit = []
      for prohibit in Prohibit.all do
        gon.prohibit.push(prohibit.prohibit_words)
      end
      @threadtype = nil
      @profile_menu_show = true
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
        elsif params[:id] == "11"
          @followings = current_user.followings.all.page(1).per(per)
          @followers = current_user.followings.all.page(1).per(per)
          @search_users = @search_users.all.page(page_id).per(per)
        end
      elsif params[:id].to_i >= 14 && params[:id].to_i <= 23
        @profile_menu_show = false
        @profile_menu_manage_show = true
        threadtype_id = params[:page1].to_i
        if threadtype_id.nil? || threadtype_id.to_i < 1
          threadtype_id = 1
        end
        @threadtype = Threadtype.find_by(id:threadtype_id.to_i)
        if @threadtype != nil && @threadtype.leader_id != current_user.id && (threadtype = Threadtype.find_by(leader_id:current_user.id)) != nil
          @threadtype = threadtype
        end
        if @threadtype != nil
          if params[:id] == "15"
            @threads = @threadtype.groups.page(page_id).per(per)
          elsif params[:id] == "16"
            thread_id = params[:page2].to_i
            if thread_id.nil? || thread_id.to_i < 1
              thread_id = 1
            end
            @thread = Group.find_by(id:thread_id.to_i)
            @posts = @thread.posts.page(page_id).per(per)
          elsif params[:id] == "17"
            @search_text = ""
            if session["search_text"].nil? == false && session["search_text"] != ""
              @search_text = session["search_text"]
            end
            search_groups = @threadtype.groups
            if !@search_text.nil?
             search_groups = search_groups.where("title_jp LIKE ? OR title_en LIKE ? OR first_content_jp LIKE ? OR first_content_en LIKE ?", "%"+ @search_text +"%", "%"+ @search_text +"%", "%"+ @search_text +"%", "%"+ @search_text +"%")
            end
            @search_groups = search_groups.all.page(page_id).per(per)
          elsif params[:id] == "18"
            thread_id = params[:page2].to_i
            if thread_id.nil? || thread_id.to_i < 1
              thread_id = 1
            end
            @thread = Group.find_by(id:thread_id.to_i)

            @search_text = ""
            if session["search_text"].nil? == false && session["search_text"] != ""
              @search_text = session["search_text"]
            end
            search_posts = @thread.posts
            if !@search_text.nil?
             search_posts = search_posts.where("content_eng LIKE ? OR content_jap LIKE ?", "%"+ @search_text +"%", "%"+ @search_text +"%")
            end
            @search_posts = search_posts.all.page(page_id).per(per)
          elsif params[:id] == "19"
            @members = @threadtype.users.page(page_id).per(per)
          elsif params[:id] == "20"
            @search_text = ""
            if session["search_text"].nil? == false && session["search_text"] != ""
              @search_text = session["search_text"]
            end
            search_members = @threadtype.users
            if !@search_text.nil?
             search_members = search_members.where("name LIKE ? OR profile_en LIKE ? OR profile_jp LIKE ?", "%"+ @search_text +"%","%"+ @search_text +"%","%"+ @search_text +"%")
            end
            @search_members = search_members.all.page(page_id).per(per)
          elsif params[:id] == "22"
            @search_text = ""
            if session["search_text"].nil? == false && session["search_text"] != ""
              @search_text = session["search_text"]
            end
            @approvals = @threadtype.approvals.all.page(page_id).per(per)
          end
        else
          @threadtype = nil
        end
      end
    end
  end
  def threadtype_profile_search
    session["search_text"] = params[:search_text]
    redirect_to "/profile/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:threadtype_id].gsub(/{:value=>/,"")}/#{params[:thread_id].gsub(/{:value=>/,"")}?page=#{params[:page_id].gsub(/{:value=>/,"")}"
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
  def edit_detail
    current_user.update()
  end

  def delete_group
    if logged_in?
      if (thread = Group.find_by(id: params[:thread_id].to_i)) == nil && thread.threadtype.leader_id == current_user.id
        thread.update(deleted:true)
        redirect_to "/profile/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:threadtype_id].gsub(/{:value=>/,"")}/#{params[:thread_id].gsub(/{:value=>/,"")}?page=#{params[:page_id].gsub(/{:value=>/,"")}"
      end
    end
  end
  def delete_post
    if logged_in?
      if (post = Post.find_by(id: params[:post_id].to_i)) != nil && post.threadtype.leader_id == current_user.id
        post.update(deleted:true)
        redirect_to "/profile/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:threadtype_id].gsub(/{:value=>/,"")}/#{params[:thread_id].gsub(/{:value=>/,"")}?page=#{params[:page_id].gsub(/{:value=>/,"")}"
      end
    end
  end
  def invlisible_post
    if logged_in?
      if (post = Post.find_by(id: params[:post_id].to_i)) != nil && post.threadtype.leader_id == current_user.id
        post.update(visible:false)
        redirect_to "/profile/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:threadtype_id].gsub(/{:value=>/,"")}/#{params[:thread_id].gsub(/{:value=>/,"")}?page=#{params[:page_id].gsub(/{:value=>/,"")}"
      end
    end
  end
  def delete_member
    if logged_in? && (threadtype = Threadtype.find_by(id: params[:threadtype_id])) != nil && threadtype.leader_id == current_user.id
      if !(user_connects = threadtype.user_threadtypes.where(user_id:params[:user_id])).blank?
        user_connects.delete_all
        redirect_to "/profile/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:threadtype_id].gsub(/{:value=>/,"")}?page=#{params[:page_id].gsub(/{:value=>/,"")}"
      end
    end
  end
  def news_make
    if logged_in? && (threadtype = Threadtype.find_by(id:params["threadtype_id"].to_i)) != nil && threadtype.leader_id == current_user.id
      user_info = Userinfo.new()
      #group.threadtype_id = data['category'].to_i
      user_info.title_jp = params['title_jp']
      user_info.title_en = params['title_en']
      user_info.content_jp = params['content_ja']
      user_info.content_en = params['content_en']
      if params[:type] == "image"
        user_info.pict = params[:pict]
      elsif params[:type] == "video"
        user_info.video = params[:video]
        user_info.subtitle_en = params['subcontent_jap']
        user_info.subtitle_jp = params['subcontent_jap']
      end
      threadtype.users.each do |user|
        user_info.user_id = user.id
        user_info.save
      end
    end
  end
  def approval_admit
    if logged_in? && (threadtype = Threadtype.find_by(id:params[:threadtype_id])) != nil && threadtype.approval == "approval" && (approval = Approval.find_by(id:params[:approval_id])) != nil
      threadtype.users << approval.user
      approval.delete
      flash["alert_en"] = "You successed to admmit approval."
      flash["alert_jp"] = "参加申請の許可に成功しました。"
      flash["alert_type"] = "success"
      redirect_to "/profile/"+ params[:type_id] +"/"+threadtype.id.to_s
    end
  end
  def threadtype_change
    if logged_in? && (threadtype = Threadtype.find_by(id:params[:threadtype_id].to_i)) != nil && threadtype.leader_id == current_user.id
      type = "public"
      if params["type"] == "private"
        type = "private"
      end
      approval = "normal"
      if params["approval"] == "approval"
        approval = "approval"
      end
      #threadtype.update(type_en:params["type_en"],type_jp:params["type_jp"],content_en:params["content_en"],content_jp:params["content_jp"],type:type,approval:approval)
      threadtype.update(content_en:params["content_en"],content_jp:params["content_jp"],type:type,approval:approval)
      flash["alert_en"] = "You successed to Change data"
      flash["alert_jp"] = "コミュニティ情報の変更に成功しました。"
      flash["alert_type"] = "success"
      redirect_to "/profile/14/"+threadtype.id.to_s
    else
      flash["alert_en"] = "You failed to Change data"
      flash["alert_jp"] = "コミュニティ情報の変更に失敗しました。"
      flash["alert_type"] = "error"
      redirect_to "/profile/14/"+params[:threadtype_id].to_s
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

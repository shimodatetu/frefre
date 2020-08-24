class ThreadtypeController < ApplicationController
  def new
    @thread_types = Threadtype.all
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
  end
  def show
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
    threadtype_id = params[:id].to_i
    if threadtype_id.nil? || threadtype_id.to_i < 1
      threadtype_id = 1
    end
    page_id = params[:page].to_i
    if page_id.nil? || page_id.to_i < 1
      page_id = 1
    end
    per = 10
    @threadtype = Threadtype.find_by(id:threadtype_id)

    thread_id = @threadtype.groups.first.id
    groups = @threadtype.groups.where.not(id:thread_id)

    @threadtype_menu_show = true

    if (params[:type] == nil || params[:type] == "1")
      @open_posts = @threadtype.groups.first.posts.page(page_id).per(per)
      @post = Post.new
    elsif params[:type] == "2"
      @popular_groups = groups.order(seen_num: "DESC").page(page_id).per(per)
    elsif params[:type] == "3"
      @latest_groups = groups.order(id:"asc").page(page_id).per(per)
    elsif params[:type] == "4"
      @members = @threadtype.users.page(page_id).per(per)
    elsif params[:type] == "6" || params[:type] == "7" || params[:type] == "8"
      @search_text = ""
      if session["search_text"].nil? == false && session["search_text"] != ""
        @search_text = session["search_text"]
      end
      search_groups = groups
      if !@search_text.nil?
       search_groups = groups.where("title_jp LIKE ? OR title_en LIKE ? OR first_content_jp LIKE ? OR first_content_en LIKE ?", "%"+ @search_text +"%", "%"+ @search_text +"%", "%"+ @search_text +"%", "%"+ @search_text +"%")
      end

      thread_id = @threadtype.groups.first.id
      search_users = @threadtype.users.where.not(id:thread_id)
      if !@search_text.nil?
        search_users = search_users.where("name LIKE ? OR profile_en LIKE ? OR profile_jp LIKE ?", "%"+ @search_text +"%","%"+ @search_text +"%","%"+ @search_text +"%")
      end
      if params[:type] == "6" || params[:type] == "7" || params[:type] == "8"
        if params["navlink"] == nil || params["navlink"] == "popular"
          @popular_search_groups = search_groups.order(seen_num: "DESC").all.page(page_id).per(per)
          @latest_search_groups = search_groups.order(id: "ASC").all.page(1).per(per)
          @search_members = search_users.all.page(1).per(per)
        elsif params["navlink"] == "latest"
          @popular_search_groups = search_groups.order(seen_num: "DESC").all.page(1).per(per)
          @latest_search_groups = search_groups.order(id: "ASC").all.page(page_id).per(per)
          @search_members = search_users.all.page(1).per(per)
        elsif params["navlink"] == "member"
          @popular_search_groups = search_groups.order(seen_num: "DESC").all.page(1).per(per)
          @latest_search_groups = search_groups.order(id: "ASC").all.page(1).per(per)
          @search_members = search_users.all.page(page_id).per(per)
        end
      end
    end
  end

  def create
    if logged_in?
      data = params[:threadtype]
      threadtype = Threadtype.new()
      threadtype.type_jp = data['type_jp']
      threadtype.type_en = data['type_en']
      threadtype.leader_id = current_user.id
      threadtype.content_jp = params['content_jap']
      threadtype.content_en = params['content_eng']
      if data["type"] == "private"
        threadtype.type = "private"
      else
        threadtype.type = "public"
      end
      if data["approval"] == "approval"
        threadtype.approval = "approval"
      else
        threadtype.approval = "normal"
      end
      if data[:pict] != nil
        threadtype.pict = data[:pict]
      end
      if threadtype.save
        group = Group.new()
        threadtype.users << current_user
        group.title_jp = "お知らせ・一般トピック"
        group.title_en = "News・Standard Topic"
        group.user_id = current_user.id
        group.threadtype_id = threadtype.id
        group.first_content_jp = "コミュニティが作成されました!"
        group.first_content_en = "Community was made!"
        if group.save
          post = Post.new()
          post.content_jap = "コミュニティが作成されました。"
          post.content_eng = "Community was made."
          post.id_ingroup = group.posts.count
          post.threadtype_id = threadtype.id
          post.group_id = group.id
          post.user_id = current_user.id
          post.save
        end
      end
    end
  end
  def retire
    if logged_in? && (threadtype = Threadtype.find_by(id:params[:threadtype_id])) != nil && (user_threadtype = threadtype.user_threadtypes.find_by(user_id:current_user.id)) != nil
      user_threadtype.delete
      flash["alert_en"] = "You successed to leave this community."
      flash["alert_jp"] = "コミュニティの退会に成功しました。"
      flash["alert_type"] = "success"
      redirect_to "/threadtype/show/"+threadtype.id.to_s+"/1"
    end
  end
  def approval_retire
    if logged_in? && (threadtype = Threadtype.find_by(id:params[:threadtype_id])) != nil && threadtype.approval == "approval" && (approval = Approval.find_by(user_id:current_user.id,threadtype_id:threadtype.id)) != nil
      approval.delete
      flash["alert_en"] = "You successed to delete approval."
      flash["alert_jp"] = "参加申請の削除に成功しました。"
      flash["alert_type"] = "success"
      redirect_to "/threadtype/show/"+threadtype.id.to_s+"/1"
    end
  end
  def update_do
    threadtype_id = params["threadtype_id"].to_i
    Threadtype.find_by(id:threadtype_id).update(image_params)
  end
  def update_text_do
    threadtype_id = params["threadtype_id"].to_i
    Threadtype.find_by(id:threadtype_id).update(type_en:params[:threadtype][:type_en],type_jp:params[:threadtype][:type_jp])
  end
  def search
    session["search_text"] = params[:search_text]
    redirect_to "/threadtype/show/#{params[:threadtype_id].gsub(/{:value=>/,"")}/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:page_id].gsub(/{:value=>/,"")}"
  end
  def image_params
    params.require(:threadtype).permit(:pict)
  end
end

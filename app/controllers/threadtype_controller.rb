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
    if params[:type] == nil || params[:type] == "1"
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
        search_users = search_users.where("name LIKE ?", "%"+ @search_text +"%")
      end
      if params[:type] == "6"
        @popular_search_groups = search_groups.order(seen_num: "DESC").all.page(page_id).per(per)
        @latest_search_groups = search_groups.order(id: "ASC").all.page(1).per(per)
        @search_members = search_users.all.page(1).per(per)
      elsif params[:type] == "7"
        @popular_search_groups = search_groups.order(seen_num: "DESC").all.page(1).per(per)
        @latest_search_groups = search_groups.order(id: "ASC").all.page(page_id).per(per)
        @search_members = search_users.all.page(1).per(per)
      elsif params[:type] == "8"
        @popular_search_groups = search_groups.order(seen_num: "DESC").all.page(1).per(per)
        @latest_search_groups = search_groups.order(id: "ASC").all.page(1).per(per)
        @search_members = search_users.all.page(page_id).per(per)
      end
    end
  end

  def create
    if logged_in?
      data = params[:threadtype]
      threadtype = Threadtype.new()
      #group.threadtype_id = data['category'].to_i
      threadtype.type_jp = data['type_jp']
      threadtype.type_en = data['type_en']
      threadtype.leader_id = current_user.id
      threadtype.content_jp = params['content_jap']
      threadtype.content_en = params['content_eng']
      threadtype.type = data["type"]
      if threadtype.save
        group = Group.new()
        group.title_jp = "オープンスレッド"
        group.title_en = "Open Thread"
        group.user_id = current_user.id
        group.threadtype_id = threadtype.id
        group.first_content_jp = "オープンスレッドが作成されました。"
        group.first_content_en = "Open Thread was made."
        if group.save
          threadtype.groups << group
          post = Post.new()
          post.content_jap = "オープンスレッドが作成されました。"
          post.content_eng = "Open Thread was made."
          post.id_ingroup = group.posts.count
          post.threadtype_id = threadtype.id
          post.group_id = group.id
          post.user_id = current_user.id
          post.save
        end
      end
    end
  end

  def search
    session["search_text"] = params[:search_text]
    redirect_to "/threadtype/show/#{params[:threadtype_id].gsub(/{:value=>/,"")}/#{params[:type_id].gsub(/{:value=>/,"")}/#{params[:page_id].gsub(/{:value=>/,"")}"
  end
end

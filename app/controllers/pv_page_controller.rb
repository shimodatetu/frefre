class PvPageController < ApplicationController
  def show
    #
    # Threadtype.all.each do |threadtype|
    #   if threadtype.groups.count == 0
    #     Group.create(title_en:"open_chat",title_jp:"オープンチャット",threadtype_id:threadtype.id,user_id:User.first.id)
    #   end
    #   if threadtype.groups.first.posts.count == 0
    #     Post.create(content_eng:"The community has been created!",content_jap:"コミュニティが作成されました！",group_id:threadtype.groups.first.id,threadtype_id:threadtype.id,user_id:User.first.id)
    #   end
    #   threadtype.groups.first.update(title_jp: "お知らせ・一般トピック",title_en: "News・Standard Topic",first_content_jp:"コミュニティが作成されました!",first_content_en:"Community was made!")
    #   threadtype.groups.first.posts.first.update(content_jap: "コミュニティが作成されました。",content_eng: "Community was made.")
    # end
    #
    # @threadtypes = Threadtype.all.where.not(type:"every")
    # Threadtype.all.each do |threadtype|
    #   threadtype.update(category_id:9)
    # end
    # User.all.each do |user|
    #   if user.user_search_id == "" || user.user_search_id == nil
    #     for i in 1..100
    #       user_search_id = user.name + rand(1000000).to_s
    #       if User.find_by(user_search_id:user_search_id) == nil
    #         user.update(user_search_id: user_search_id)
    #         break
    #       end
    #     end
    #   end
    # end
    @threadtypes = Threadtype.all.where.not(type:"every")
    per = 10
    page_id = params[:page].to_i
    if page_id == nil || page_id < 1
      page_id = 1
    end
    if params["navlink"] == nil || params["navlink"] == "popular"
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(page_id).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(1).per(per)
    else
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(1).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(page_id).per(per)
    end
  end
  def new
    set_group_data
  end
  def popular
    set_group_data
  end
  def set_group_data
    if Group.present?
      @groups = Group.all.where("deleted = false")
      thread_page_num = 20.to_f
      page_show_max = 6.to_f
      page_max_half = (page_show_max / 2).ceil + 1
      group_num = Group.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:id].to_i
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
    else
      @thread_page_num = 0
      @page_id = 0
      @page_num = 0
      @start_num = 0
      @end_num = 0
    end
  end
end

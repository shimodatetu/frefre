class PvPageController < ApplicationController
  def show
    Group.all.each do |group|
      group.update("threadtype_id": 19)
    end
    @groups = Group.all.where("deleted = false")
    User.all.each do |user|
      user.update(profile_en:"Nice to meet you!",profile_jp:"よろしくお願いします！")
    end
    Threadtype.all.each do |threadtype|
      threadtype.users.delete_all
      User.all.each do |user|
        threadtype.users << user
      end
      threadtype.update(type:"public")
    end
    #Group.all.each do |group|
    #  group.update(threadtype_id: 22)
    #end

    #Post.all.each do |post|
    #  post.group_id = 1
    #  post.update(threadtype_id:post.group.threadtype_id)
    #end
    #last_id = Post.all.last.id
    #Post.find(last_id).update(threadtype_id:23)
    #Post.find(last_id - 1).update(threadtype_id:24)
    Post.all.where(deleted:true).each do |post|
      post.delete
    end
    @threadtypes = Threadtype.all.where.not(type:"every")
    Threadtype.all.each do |threadtype|
      threadtype.update(categry_id:9)
    end
    per = 10
    page_id = params[:page].to_i
    if page_id == nil || page_id < 1
      page_id = 1
    end
    if params[:id] == "latest"
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(1).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(page_id).per(per)
    else
      @popular_threadtypes = @threadtypes.where(id:Post.group(:threadtype_id).order('count(threadtype_id) desc').pluck(:threadtype_id)).page(page_id).per(per)
      @latest_threadtypes = @threadtypes.all.order('id desc').page(1).per(per)
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

class OtherProfileController < ApplicationController
  def show
    other_user = User.find(1)
    if User.find_by(id:params[:id].to_i)
      other_user = User.find_by(id:params[:id].to_i)
    end
    thread_page_num = 20.to_f
    page_show_max = 5.to_f
    page_max_half = (page_show_max / 2).ceil
    group_num = other_user.groups.all.count
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
  end
end

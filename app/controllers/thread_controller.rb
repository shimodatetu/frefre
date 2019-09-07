class ThreadController < ApplicationController
  def show
    @post = Post.new
    gon.login = logged_in?
    thread = Group.find(params[:id])
    thread_page_num = 10.to_f
    page_show_max = 5.to_f
    page_max_half = (page_show_max / 2).ceil
    group_num = thread.posts.all.count - 1
    page_num = (group_num / thread_page_num).ceil
    if page_num == 0
      page_num = 1
    end
    page_id = params[:page].to_i
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
  end
  def show_post_image
    @photo = Post.find(params[:id])
    send_data @photo.photo, :type => 'image/jpeg'
  end
  def show_image
    @photo = User.first
    send_data @photo.photo, :type => 'image/jpeg'
  end
end

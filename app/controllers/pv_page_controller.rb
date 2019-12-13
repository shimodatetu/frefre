class PvPageController < ApplicationController
  def show
    @groups = Group.all.where("deleted = false")
    Post.all.where(deleted:true).each do |post|
      post.delete
    end
  end
  def new
    set_group_data
  end
  def popular
    set_group_data
  end
  #result = system("ffmpeg -y -i https://localhost:9292/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f47fcef2b9b64f33632e4ef76816a5a699d3971/%E3%80%90%E6%BC%AB%E7%94%BB%E3%80%91%E7%89%B9%E6%AE%8A%E6%B8%85%E6%8E%83%E5%93%A1%E3%81%AB%E3%81%AA%E3%82%8B%E3%81%A8%E3%81%A8%E3%82%99%E3%82%93%E3%81%AA%E7%94%9F%E6%B4%BB%E3%81%AB%E3%81%AA%E3%82%8B%E3%81%AE%E3%81%8B%EF%BC%9F%E3%80%90%E3%83%9E%E3%83%B3%E3%82%AB%E3%82%99%E5%8B%95%E7%94%BB%E3%80%91.mp4 -acodec copy output.m4a")

  #print result
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

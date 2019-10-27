class PvPageController < ApplicationController
  def show
    @groups = Group.all.where("deleted = false")
    #p request.env["omniauth.auth"]
    #set_group_data
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
      thread_page_num = 10.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
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

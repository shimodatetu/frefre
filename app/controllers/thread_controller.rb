class ThreadController < ApplicationController
  def show
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
    @post = Post.new
    gon.login = logged_in?
    thread = Group.find(params[:id])

    per = 20
    thread_id = params[:id].to_i
    if thread_id.nil? || thread_id.to_i < 1
      thread_id = 1
    end
    page_id = params[:page].to_i
    if page_id.nil? || page_id.to_i < 1
      page_id = 1
    end
    @threadtype = thread.threadtype
    @thread = Group.find_by(id:thread_id)
    @thread_posts = @thread.posts.page(page_id).per(per)
    @threadtype_menu_show = true
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

class PostsController < ApplicationController
  require 'tempfile'
  def index
    @posts = Post.all.where("deleted = false")
    @groups = Group.all.where("deleted = false")
  end
  def create
    p "start"
    data = params[:post]
    group = Group.find(data[:group_id])
    if group
      post = Post.new()
      post.id_ingroup = group.posts.count
      post.group_id = group.id
      post.user_id = current_user.id
      if data[:type] == "image"
        post.pict = data[:pict]
        post.save
      else
        post.video = data[:video]
        post.subtitle_en = "ready"
        post.subtitle_jp = "ready"
        if post.save
        end
      end
    end
    #Post.find_by(id:params[:post][:post_id]).update(pict:params[:post][:pict])
  end
end
private
def image_params
  params.require(:post).permit(:photo)
end

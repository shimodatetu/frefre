class PostsController < ApplicationController
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
      p  data[:type]
      if data[:type] == "image"
        p "video"
        post.pict = data[:pict]
        post.save
      else
        p "video"
        post.video = data[:video]
        if post.save
          p "-----------------------"
          p "error"
          p data[:pict]
          p data[:video]
          p "-----------------------"
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

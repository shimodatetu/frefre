class PostsController < ApplicationController
  def index
    @posts = Post.all.where("deleted = false")
    @groups = Group.all.where("deleted = false")
  end
  def create
    Post.find_by(id:params[:post][:post_id]).update(pict:params[:post][:pict])
  end
end
private
def image_params
  params.require(:post).permit(:photo)
end

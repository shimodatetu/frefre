class PostsController < ApplicationController
  def index
    @posts = Post.all
    @groups = Group.all.where("deleted = false")
  end
  def create
    Post.find_by(id:params[:post][:post_id]).update(picture:params[:post][:picture])
  end
end
private
def image_params
  params.require(:post).permit(:photo)
end

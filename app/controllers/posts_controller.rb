class PostsController < ApplicationController
  def index
    @posts = Post.all
    @groups = Group.all
  end
  def create
    #if !params[:post][:photo].nil? && !params[:post][:group_id].nil?
    #  @post = Post.new(photo:params[:post]["photo"].read,group_id: params[:post][:group_id],user_id: current_user.id,file_name: params[:post]["photo"].original_filename)
    #  @post.save
    #end
  end
end
private
def image_params
  params.require(:post).permit(:photo)
end

class ThreadAllController < ApplicationController
  def show
    @groups = Group.all.where("deleted = false")
    @posts = Post.all.where("deleted = false")
  end
end

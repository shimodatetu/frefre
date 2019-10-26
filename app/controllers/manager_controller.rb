class ManagerController < ApplicationController
  def show
  end

  def search_post
    @posts = Post.all
  end
  def search_thread
    @groups = Group.all
  end
  def search_user
    @users = User.all
  end
  def searcher_post
    session["search_text"] = params[:search_text]
    redirect_to "/manager/search_post"
  end
  def searcher_user
    session["search_text"] = params[:search_text]
    redirect_to "/manager/search_user"
  end
  def searcher_profile
    session["search_profile"] = params[:search_text]
    redirect_to "/manager/search_user"
  end
  def searcher_mail
    session["search_mail"] = params[:search_text]
    redirect_to "/manager/search_user"
  end
  def searcher_groups
    session["search_text"] = params[:search_text]
    redirect_to "/manager/search_groups"
  end
end

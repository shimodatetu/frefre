class ManagerController < ApplicationController


  def show
  end

  def prohibit
    @prohibit_all = Prohibit.all
    @prohibit = Prohibit.new
  end

  def prohibit_set
    params[:prohibit][:prohibit_words].split(",").each do |prohibit|
      new_prohibit = Prohibit.new
      new_prohibit.prohibit_words = prohibit
      new_prohibit.save
    end
    redirect_to "/manager/prohibit"
  end

  def search_post
    @posts = Post.all.where("deleted = false")
  end
  def search_thread
    @groups = Group.all.where("deleted = false")
  end
  def thread_delete
    id = params[:id]
    if group = Group.find_by(id:id)
      group.update(deleted:true)
      for post in group.posts do
        post.update(deleted:true)
      end
    end
    redirect_to "/manager/search_thread"
  end
  def post_delete
    id = params[:id]
    if post = Post.find_by(id:id)
      post.update(deleted:true)
    end
    redirect_to "/manager/search_post"
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

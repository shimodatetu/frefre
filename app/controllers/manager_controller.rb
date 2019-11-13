class ManagerController < ApplicationController

  def manager_logged_in?
    if !current_user.nil? && current_user.usertype == "manager"
      return current_user
    else
      return false
    end
  end

  def show
  end

  def user_change
    user_id = params[:id]
    usertype = params[:type]
    User.find_by(id:user_id).update(usertype:usertype)

    redirect_to "/manager/search_user_detail/"+params[:id].to_s
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


  def prohibit_delete
    if prohibit = Prohibit.find_by(id:params[:id].to_i)
      prohibit.delete
    end
    redirect_to "/manager/prohibit"
  end
  def prohibit_alldelete
    Prohibit.delete_all
    redirect_to "/manager/prohibit"
  end

  def search_report_user
    @report_users = Reportuser.all
  end

  def search_report_post
    @report_posts = Reportpost.all
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
  def searcher_group
    session["search_text"] = params[:search_text]
    redirect_to "/manager/search_thread"
  end
  def searcher_report_post
    session["search_text"] = params[:search_text]
    redirect_to "/manager/search_report_post"
  end
  def searcher_report_user
    session["search_text"] = params[:search_text]
    redirect_to "/manager/search_report_user"
  end
end

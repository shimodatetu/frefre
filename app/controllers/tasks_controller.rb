class TasksController < ApplicationController
  def lang_change_jp
    session["lang"] = "jap"
    redirect_to params[:url]
  end
  def lang_change_en
    session["lang"] = "eng"
    redirect_to params[:url]
  end

  def search
    session["search_text"] = params[:search_text]
    redirect_to "/search/show"
  end

  def delete
    delete_id = params[:delete_id].to_i
    post = Post.find_by(id: delete_id)
    if post && post.user.id == current_user.id
      post.update(deleted: true)
      redirect_to params[:url]
    end
  end

  def search_inside
    search_text = params[:search_text]
    search_en = Bigcategory.find_by(name_en: search_text)

    if !search_en.nil?
      flash[:search_big_id] = search_en.id
      redirect_to "/groups"
    else
      search_jp = Bigcategory.find_by(name_jp: search_text)
      if !search_jp.nil?
        flash[:search_big_id] = search_en.id
        redirect_to "/groups"
      else
        search_en_small = Smallcategory.find_by(name_en: search_text)
        if !search_en_small.nil?
          flash[:search_sub_id] = search_en_small.id
          flash[:search_big_id] = search_en_small.bigcategory.id
          redirect_to "/groups"
        else
          search_jp_small = Bigcategory.find_by(name_en: search_text)
          if !search_jp_small.nil?
              flash[:search_sub_id] = search_jp_small.id
              flash[:search_big_id] = search_jp_small.bigcategory.id
              redirect_to "/groups"
          end
        end
      end
    end
  end
  def logout_inner
    logout
    redirect_to root_path
  end
end

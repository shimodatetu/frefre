require 'net/http'
require 'uri'
require 'json'

class Net::HTTP
  alias :create :initialize

  def initialize(*args)
    create(*args)
    self.set_debug_output $stderr
    $stderr.sync = true
  end
end
class TasksController < ApplicationController
  def trans
    lang = params[:lang]
    words = ""
    if lang == "ja"
      words = params[:content_en]
    elsif lang == "en"
      words = params[:content_jp]
    end
    uri = URI.parse("http://localhost:5000/trans_mirai")
    req = Net::HTTP::Post.new(uri)
    req["Authorization"] = "Bearer sample_token"
    p "------------"
    p words
    p lang
    p "おはよう"
    p "-------------"
    req.set_form_data({"words"=>words, "lang"=>lang})
    req_options = {
     use_ssl: uri.scheme == "http"
    }
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    	http.request(req)
    end
    answer = response.body.slice(2..-3).force_encoding("UTF-8")
    p "----------------------"
    p answer
    p params[:show_class_en]
    p params[:show_class_jp]
    p "----------------------"
    NodejsChannel.broadcast_to(current_user,"trans":answer,"show_class_en":params[:show_class_en],"show_class_jp":params[:show_class_jp],lang:lang)
  end
  def report_user
    id = params[:report_id]
    user = User.find_by(id:id.to_i)
    type = params[:type]
    content = params[:content]
    reportuser = Reportuser.find_by(user_id: id.to_i)
    if user && logged_in? && !(reportuser && reportuser.from_user == current_user.id)
      Reportuser.create(user_id:user.id,from_user:current_user.id,content:content,reporttype:type)
      flash["alert_en"] = "You reported this user"
      flash["alert_jp"] = "このユーザーを通報しました。"
      flash["alert_type"] = "success"
      redirect_to "/other_profile/"+id
    else
      flash["alert_en"] = "You reported this user"
      flash["alert_jp"] = "このユーザーを通報しました。"
      flash["alert_type"] = "success"
      redirect_to "/other_profile/"+id
    end
  end

  def report_post_task
    id = params[:report_id]
    post = Post.find_by(id:id.to_i)
    type = params[:type]
    content = params[:content]
    reportpost = Reportpost.find_by(post_id: id.to_i)
    if post && logged_in? && !(reportpost && reportpost.from_user == current_user.id)
      Reportpost.create(post_id:id.to_i,from_user:current_user.id,content:content,reporttype:type)
      flash["alert_en"] = "You reported this post"
      flash["alert_jp"] = "この投稿を通報しました。"
      flash["alert_type"] = "success"
      if params[:page_id] == "0"
        redirect_to "/thread/show/"+params[:thread_id]
      else
        redirect_to "/thread/show/"+params[:thread_id]+"/"+params[:page_id]
      end
    else
      flash["alert_en"] = "You reported this post"
      flash["alert_jp"] = "この投稿を通報しました。"
      flash["alert_type"] = "success"
      if params[:page_id] == "0"
        redirect_to "/thread/show/"+params[:thread_id]
      else
        redirect_to "/thread/show/"+params[:thread_id]+"/"+params[:page_id]
      end
    end
  end

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

  def search_user
    session["search_text"] = params[:search_text]
    redirect_to "/profile/10"
  end

  def delete
    delete_id = params[:delete_id].to_i
    post = Post.find_by(id:delete_id)
    if post && logged_in? && post.user.id == current_user.id
      post.update(deleted: true)
      redirect_to params[:url]
    end
  end

  def search_inside
    flash[:search] = params[:search_text]
  end

  def follow_other
    if params[:follow] == "true"
      follow_id = params[:follow_id].to_i
      if current_user.following_id?(follow_id) == nil
        current_user.follow_id!(follow_id)
      end
    else
      follow_id = params[:follow_id].to_i
      if current_user.following_id?(follow_id) != nil
        current_user.unfollow_id!(follow_id)
      end
    end
  end

  def search_inside
    flash[:search] = params[:search_text]
  end

  def search_inside_before
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

    current_user = nil
    session[:user_id] = nil
    redirect_to root_path
  end
end

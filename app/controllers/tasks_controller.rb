require 'net/https'
require 'uri'
require 'json'
require 'tempfile'
class TasksController < ApplicationController
  def video
    if current_user == nil || none_nil(params[:form_type]) || params[params[:form_type]][:video] == nil || none_nil(params[:show_class]) || none_nil(params[:show_class_en]) || none_nil(params[:show_class_jp]) || none_nil(params[:form_class]) || none_nil(params[:send_time]) || none_nil(params[:lang])
      NodejsChannel.broadcast_to(current_user,"type":"video","success":"false","params":params)
      return
    else
      require "execjs"
      num = 0
      file = File.open("files/data.txt", "r")
        num = file.read.to_i
      file.close
      file = File.open("files/data.txt", "w")
        file.write (num+ 1).to_s
      file.close
      file_name = "output"+num.to_s
      url = params[params[:form_type]][:video].path
      url = Rails.root.join('tmp', 'asd.mp4')

      # 一時ファイル書き込み
      File.open(url, 'wb') do |file|
        file.write(params[params[:form_type]][:video].read)
        url = url.to_s
        url = "https://www.frefreforum.com"+url
        p "-----------------------"
        p url
        p "-----------------------"
        stdout, stderr, status = Open3.capture3('ffmpeg -i '+ url)
        stdout, stderr, status = Open3.capture3('ffmpeg -y -i '+ url +' -acodec copy files/'+ file_name +'.m4a')
        std_data = stderr.split(" ")
        index = std_data.index("Hz,")
        hertz = std_data[index - 1].to_i
        stdout, stderr, status = Open3.capture3('ffmpeg -i files/'+file_name+'.m4a -ac 1 -f s16be -acodec pcm_s16le files/'+file_name+'.raw')
        connection = Faraday.new("https://still-plains-44123.herokuapp.com") do |builder|
          # `multipart`ミドルウェアを使って、ContentTypeをmultipart/form-dataにする
          builder.request :multipart
          builder.request :url_encoded
          builder.adapter Faraday.default_adapter
        end
        paramater = {
          lang:params[:lang] ,
          picture: Faraday::UploadIO.new("files/"+file_name+".raw", "image/jpeg")
        }
        response = connection.post("/upload_raw", paramater)
        stdout, stderr, status = Open3.capture3('rm files/'+file_name+'.m4a files/'+file_name+'.raw')
        answer = response.body.slice(2..-3).force_encoding("UTF-8")
        NodejsChannel.broadcast_to(current_user,"type":"video","trans":answer,"show_modal":params[:show_modal],"show_class":params[:show_class],"show_class_en":params[:show_class_en],"show_class_jp":params[:show_class_jp],"form_class":params[:form_class],"send_time":params[:send_time],"lang":params[:lang],"success":"true")

      end
    end
  end

  def trans
    p "--------------------"
    lang = params[:lang]
    words = ""
    if lang == "ja"
      words = params[:content_en]
    elsif lang == "en"
      words = params[:content_jp]
    end
    if current_user == nil || none_nil(words) || none_nil(params[:show_class_en]) || none_nil(params[:show_class_jp]) || none_nil(params[:form_class]) || none_nil(params[:send_time]) || none_nil(lang)
      NodejsChannel.broadcast_to(current_user,"type":"trans","success":"false")
      return
    else
      uri = URI.parse("https://still-plains-44123.herokuapp.com/trans_mirai")
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data({"words"=>words, "lang"=>lang})

      res = http.request(req)

      answer = res.body
      answer = res.body.slice(2..-3).force_encoding("UTF-8")
      NodejsChannel.broadcast_to(current_user,"type":"trans","trans":answer,"show_class_en":params[:show_class_en],"show_class_jp":params[:show_class_jp],"form_class":params[:form_class],"send_time":params[:send_time],"lang":lang,"success":"true")
      return
    end
  end

  def none_nil(data)
    if data == nil || data == ""
      return true
    else
      return false
    end
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

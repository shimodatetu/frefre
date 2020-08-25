class PostsController < ApplicationController
  require 'tempfile'
  require 'open3'
  require 'net/https'
  require 'uri'
  require 'json'
  require 'httparty'
  def index
    @posts = Post.all.where("deleted = false")
    @groups = Group.all.where("deleted = false")
  end

  def trans3(params)
    conn = Faraday.new(:url => 'http://example.com') do |builder|
      builder.request :multipart   # マルチパートでデータを送信
      builder.request :url_encoded
      builder.adapter :net_http
    end

    params = {
      :name    => 'nyanco',
      :raw => Faraday::UploadUI.new('files/output.raw', 'raw')
    }
    conn.put '/api/nyan.json', params
  end

  def trans2(params)
    @uri = URI.parse("http://localhost:5000/api/file")
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = false
    #@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    fd = new FormData
    imgBlob = new Blob([ e.target.result ], type: file.type)
    fd.append 'video', imgBlob, file.name
    fd.append 'lang', lang

    def apipost(filename)
      req = Net::HTTP::Post.new(@uri.path)
      file = File.open("files/output1.raw","r+")
      data = [
        ["video", file.read, type:{"filename" => "output1.raw"}]
      ]
      req.set_form(data, "multipart/form-data")
      p req
      res = @http.request(req)
      file.close
    end
    apipost("filename")
  end
  def trans(params)
    require "execjs"
    num = 0
    file = File.open("files/data.txt", "r+")
      p file.read
      num = file.read
      file.puts (num.to_i + 1).to_s
    file.close
    num = "1"

    file_name = "output"+num
    #p params[:post][:video].tempfile.path
    url = params[:post][:video].tempfile.path
    stdout, stderr, status = Open3.capture3('ffmpeg -i '+ url)
    p "-------------------------------------------------"

    stdout, stderr, status = Open3.capture3('ffmpeg -y -i '+ url +' -acodec copy files/'+ file_name +'.m4a')
    std_data = stderr.split(" ")
    #p std_data
    index = std_data.index("Hz,")
    hertz = std_data[index - 1].to_i
    stdout, stderr, status = Open3.capture3('ffmpeg -i files/'+file_name+'.m4a -ac 1 -f s16be -acodec pcm_s16le files/'+file_name+'.raw')
    video_set
  end
  def video_set
    uri = URI.parse("https://auth.mimi.fd.ai/v2/token")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"

    data = {
        "client_id"=>"6c40958879054b6586240c0f523fb1fb",
        "client_secret"=>"347e7072efd95ac30e1e6c5834a9a527e23330c26cc3efc70eba3abab7e082647cf2b93b397b1231f9337d7a4c2e67be703a8929a2cc691d6d5bb1885205129c42060d40bb7aa34097f32b0f654f925af2680fa76555ea89be1a0e3a9b4b9fc63c57a855b7cadd847ab1fee5c4789e4736984a9a5c5b33e572721b2d7aa556110386800beb5418ad504d87df95936d27c5c512a95ea5e18743fd7f904b9bb935cef55530c390263267b9c301ac9e17578f3daf859f22acf1dd3557cef7acdb463b19745fabfca0bb6828ccc11889f002b72e4382d1bec0860edcba7601f513e5cf85d0b4f8c9ef63b65f5f861a2420869c6d5a37f9a2c2a5f32ffa7d795cf10a",
        "scope"=>"https://apis.mimi.fd.ai/auth/nict-tts/http-api-service;https://apis.mimi.fd.ai/auth/nict-tra/http-api-service;https://apis.mimi.fd.ai/auth/nict-asr/http-api-service;https://apis.mimi.fd.ai/auth/nict-asr/websocket-api-service;https://apis.mimi.fd.ai/auth/applications.r",
        "grant_type"=>"https://auth.mimi.fd.ai/grant_type/application_credentials"
    }.to_json
    headers = {
      "Content-Type": "application/json"
    }
    req.body = data
    req.initialize_http_header(headers)
    res = http.request(req)
    p "----------------------"
    p res.body.split(",")[0].split("\"")[3]

    uri = URI.parse("https://service.mimi.fd.ai")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    p http
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"

    req = Net::HTTP::Post.new(uri)
    req.content_type = "audio/x-pcm;bit=16;rate=48000;channels=1"
    req["X-Mimi-Process"] = "asr"
    req["X-Mimi-Input-Language"] = "ja"
    req["Authorization"] = "Bearer "+res.body.split(",")[0].split("\"")[3]
    req.initialize_http_header(headers)
    file = File.open("files/output.raw","r")
    data = [
      ["file", file.read, {"filename" => "output.raw"}]
    ]
    file.close
    req.set_form(data, "multipart/form-data")

    res = http.request(req)
    p res.body
  end

  def create

    data = params[:post]
    p "=================="
    p params[:show_class_en]
    p "=================="
    if data[:type] == "trans_to_en" || data[:type] == "trans_to_jp"
      words = ""
      if data[:type] == "trans_to_jp"
        words = data[:content_eng]
        lang = "ja"
      elsif data[:type] == "trans_to_en"
        words = data[:content_jap]
        lang = "en"
      end
      if current_user == nil || none_nil(words) || none_nil(params[:show_class_en]) || none_nil(params[:show_class_jp]) || none_nil(params[:form_class]) || none_nil(params[:send_time]) || none_nil(lang)
        p "======================="
        p "error"
        p "========================"
        NodejsChannel.broadcast_to(current_user,"type":"trans","success":"false")
        return
      else
        p "======================="
        p "ok"
        p "========================"
        uri = URI.parse("https://still-plains-44123.herokuapp.com/trans_mirai")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data({"words"=>words, "lang"=>lang})
        res = http.request(req)
        answer = res.body
        answer = res.body.slice(2..-3).force_encoding("UTF-8")
        answer = answer.gsub(/\\n/,"\n")
        NodejsChannel.broadcast_to(current_user,"type":"trans","trans":answer,"show_class_en":params[:show_class_en],"show_class_jp":params[:show_class_jp],"form_class":params[:form_class],"send_time":params[:send_time],"lang":lang,"success":"true")
      end
    else
      group = Group.find(params["group_num"])
      if group
        post = Post.new()
        post.id_ingroup = group.posts.count
        post.group_id = group.id
        post.threadtype_id = group.threadtype_id
        post.user_id = current_user.id

        post.content_jap = data['content_jap']
        post.content_eng = data['content_eng']
        post.threadtype_id = group.threadtype_id
        post.user_id = current_user.id
        if data[:type] == "image" && data[:pict] != nil
          post.pict = data[:pict]
        elsif data[:type] == "video" && data[:video] != nil
          #trans3(params)
          post.subtitle_en = data[:subtitle_en]
          post.subtitle_jp = data[:subtitle_jp]
          post.video = data[:video]
        end
        post.save
      end
    end
  end
  def none_nil(data)
    if data == nil || data == ""
      return true
    else
      return false
    end
  end
end
private
def image_params
  params.require(:post).permit(:photo)
end

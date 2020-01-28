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
  def trans(params)
    p "trans"
    @uri = URI.parse("http://localhost:5000/api/file")
    @http = Net::HTTP.new(@uri.host, @uri.port)
    #@http.use_ssl = true
    #@http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    def apipost(filename)
      req = Net::HTTP::Post.new(@uri.path)
      File.open("files/output1.raw") do |file|
        data = [
          ["file", file.read, {"filename" => "output1.raw"}]
        ]
        req.set_form(data, "multipart/form-data")
        p req
        res = @http.request(req)
        p res
        p res.code
        p res.message
        p res.body
      end
    end
    apipost("filename")
  end
  def trans2(params)
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

    uri = URI.parse("https://sandbox-sr.mimi.fd.ai/")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"
    headers = {
      "Authorization":"Bearer "+res.body.split(",")[0].split("\"")[3],
      "x-mimi-process":"nict-asr",
      "x-mimi-input-language": "ja",
      "Content-Type":"audio/x-pcm;bit=16;rate=48000;channels=1"
    }
    file = File.open("files/output1.raw", "r+")
      file_data = file.read
    file.close
    data = {
        method: 'POST',
        headers: headers
    }.to_json

    data = data.chop + ",\"body\":"+ "file_data" +"}"
    data.gsub!(/\"/,'')
    p data
    req.body = data
    req.initialize_http_header(headers)
    res = http.request(req)
    p "================================"
    p res.body
    p res.message
    p res.code

  end

  def create
    data = params[:post]
    group = Group.find(params["group_num"])
    if group
      post = Post.new()
      post.id_ingroup = group.posts.count
      post.group_id = group.id
      post.user_id = current_user.id

      p data[:video]
      p "================================="
      if data[:type] == "image"
        post.pict = data[:pict]
        post.save
      else
        trans(params)
        #post.video = data[:video]
        #post.subtitle_en = "ready"
        #post.subtitle_jp = "ready"
        #post.save
      end
    end
    #Post.find_by(id:params[:post][:post_id]).update(pict:params[:post][:pict])
  end
end
private
def image_params
  params.require(:post).permit(:photo)
end

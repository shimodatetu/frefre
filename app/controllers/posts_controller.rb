class PostsController < ApplicationController
  require 'tempfile'
  require 'open3'
  def index
    @posts = Post.all.where("deleted = false")
    @groups = Group.all.where("deleted = false")
  end

  def trans
    num = 0
    file = File.open("files/data.txt", "r+")
      num = file.read
      file.puts (num.to_i + 1).to_s
    file.close
    file_name = "output"+num
    url = params[:url]
    p url
    stdout, stderr, status = Open3.capture3('ffmpeg -i '+ url)
    p stderr
    stdout, stderr, status = Open3.capture3('ffmpeg -y -i '+ url +' -acodec copy files/'+ file_name +'.m4a')
    std_data = stderr.split(" ")
    index = (std_data.reject { |data| data == "Hz"})[0]
    hertz = Math.round(Number(std_data[index - 1]))
    console.log(String(hertz))
    stdout, stderr, status = Open3.capture3('ffmpeg -i files/'+file_name+'.m4a -ac 1 -f s16be -acodec pcm_s16le files/'+file_name+'.raw')
  end
  def video_set(params)
    require "execjs"
    num = 0
    file = File.open("files/data.txt", "r+")
      num = file.read
      file.puts (num.to_i + 1).to_s
    file.close
    num = "1"
    file_name = "output"+num
    p params[:post][:video].tempfile.path
    url = params[:post][:video].tempfile.path
    stdout, stderr, status = Open3.capture3('ffmpeg -i '+ url)
    p "-------------------------------------------------"
    stdout, stderr, status = Open3.capture3('ffmpeg -y -i '+ url +' -acodec copy files/'+ file_name +'.m4a')
    std_data = stderr.split(" ")
    p std_data
    index = std_data.index("Hz,")
    hertz = std_data[index - 1].to_i
    stdout, stderr, status = Open3.capture3('ffmpeg -i files/'+file_name+'.m4a -ac 1 -f s16be -acodec pcm_s16le files/'+file_name+'.raw')
    ExecJS.exec("var req = new XMLHttpRequest();")
    "req.onreadystatechange = function() {var result = document.getElementById('result');if (req.readyState == 4) { if (req.status == 200) { result.innerHTML = req.responseText;}}else{result.innerHTML = '通信中...';}}"
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
        video_set(params)
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

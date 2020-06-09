class GroupsController < ApplicationController
  def new
    @category = Bigcategory.all
    @thread_types = Threadtype.all
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
  end
  def create
    if logged_in?
      data = params[:group]
      p params
      group = Group.new()
      #group.threadtype_id = data['category'].to_i
      group.title_jp = data['title_jp']
      group.title_en = data['title_en']
      group.user_id = current_user.id
      group.threadtype_id = data['threadtype_id'].to_i
      group.first_content_jp = params['content_jap']
      group.first_content_en = params['content_eng']
      if group.save
        params["threadtype"]["id"].each do |type|
          if type != ""
            Threadtype.find_by(id:type.to_i).groups << group
          end
        end
        post = Post.new()
        post.content_jap = params['content_jap']
        post.content_eng = params['content_eng']
        if data[:type] == "image"
          post.pict = data[:pict]
        else
          post.video = data[:video]
          post.subtitle_en = params['subcontent_jap']
          post.subtitle_jp = params['subcontent_jap']
        end
        post.id_ingroup = group.posts.count
        post.group_id = group.id
        post.user_id = current_user.id
        post.save
      end
    end
  end
  def create2
    data = params[:group]
    group = Group.find(data[:group_id])
    if group
      post = Post.new()
      post.id_ingroup = group.posts.count
      post.group_id = group.id
      post.user_id = current_user.id
      if data[:type] == "image"
        post.pict = data[:pict]
        post.save
      else
        post.video = data[:video]
        post.subtitle_en = "ready"
        post.subtitle_jp = "ready"
        post.save
      end
    end
    #Post.find_by(id:params[:post][:post_id]).update(pict:params[:post][:pict])
  end
end

class RoomChannel < ApplicationCable::Channel
  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "room_channel"
    stream_for current_user
  end

  def unsubscribed
  end

  def speak(data)
    if logged_in?
      group = Group.find(data['group_id'])
      if group
        post = Post.new()
        post.lang = data['lang']
        post.id_ingroup = group.posts.count
        post.content_jap = data['content_jap']
        post.content_eng = data['content_eng']
        post.group_id = group.id
        post.user_id = current_user.id
        if post.save
          p "====================================-"
          p "1"
          p "====================================-"
        else
        
          p "====================================-"
          p "2"
          p "====================================-"
        end
      end
    end
  end

  def image(data)
    group = Group.find(data['group_id'])
    if group
      post = Post.new()
      post.lang = data['lang']
      post.id_ingroup = group.posts.count
      post.image = data['image']
      post.group_id = group.id
      post.user_id = current_user.id
      post.save
    end
  end
end

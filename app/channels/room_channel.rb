class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end


  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    group = Group.find_by(id: data['group_id'])
    if group
      post = Post.new()
      post.lang = data['lang']
      post.id_ingroup = group.posts.count
      post.content_jap = data['content_jap']
      post.content_eng = data['content_eng']
      post.group_id = group.id
      post.user_id = current_user.id
      post.save
    end
  end

  def image(data)
    group = Group.find_by(id: data['group_id'])
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

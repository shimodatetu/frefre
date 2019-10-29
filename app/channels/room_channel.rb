class RoomChannel < ApplicationCable::Channel

  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
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
        post.save

        #info = Userinfo.new()
        #info_page = (post.id_ingroup - 1) / 10 + 1

        #info.title_en = 'There is a reply to "'+ h(group.title_en) + '"!'
        #info.title_jp = '「'+h(group.title_jp)+'」に投稿がありました！'

        #info.message_en = 'There is a reply to "'+ h(group.title_en) + '".
        #Please click on the url below and check the thread.
        #https://www.frefreforum.com/thread/'+group.id.to_s+'/'+info_page.to_s

        #info.message_jp = '「'+h(group.title_jp)+'」に投稿がありました。
        #下記のURLをクリックしてスレッドを確認してください。
        #https://www.frefreforum.com/thread/'+group.id.to_s+'/'+info_page.to_s
        #info.user_id = group.user_id
        #info.save

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

class ThreadChannel < ApplicationCable::Channel

  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "thread_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def make(data)
    if logged_in?
      group = Group.new()
      #group.threadtype_id = data['category'].to_i
      group.title_jp = data['title_jp']
      group.title_en = data['title_en']
      group.user_id = current_user.id
      group.first_content_jp = data['message_jp']
      group.first_content_en = data['message_en']
      group.threadtype_id = data["threadtype_id"]
      if group.save
        post = Post.new()
        post.lang = data['lang']
        post.content_jap = data['message_jp']
        post.content_eng = data['message_en']
        post.id_ingroup = group.posts.count
        post.group_id = group.id
        post.threadtype_id = data["threadtype_id"]
        post.user_id = current_user.id
        post.save
      end
    end
  end
end

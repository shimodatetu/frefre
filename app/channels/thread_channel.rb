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
      group.threadtype_id = 1
      group.title_jp = data['title_jp']
      group.title_en = data['title_en']
      group.user_id = current_user.id
      group.save
      post = Post.new()
      post.lang = data['lang']
      post.content_jap = data['message_jp']
      post.content_eng = data['message_en']
      post.id_ingroup = group.posts.count
      post.group_id = group.id
      post.user_id = current_user.id
      post.save
      hash_jp = data["hash_jp"]
      hash_en = data["hash_en"]
      hash_jp_text = ""
      hash_en_text = ""
      hash_jp.length.times do |id|
        Hashtag.create(hash_jp: hash_jp[id],hash_en: hash_en[id],group_id: group.id)
        hash_jp_text += "#"+hash.hash_jp[id] + " "
        hash_en_text += "#"+hash.hash_en[id] + " "
      end
      group.update(hash_en:hash_en_text,hash_jp:hash_jp_text)
    end
  end
end

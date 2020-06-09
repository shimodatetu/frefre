class MessageBroadcastJob < ApplicationJob
  queue_as :default
  def perform(post)
    threadtype_first_id = -1
    if post.threadtype.groups.first.id == post.group_id
      threadtype_first_id = post.threadtype_id
    end
    ActionCable.server.broadcast('room_channel',post:post,post_id:post.group.posts.all.count,message: render_post(post),type:"accept", threadtype_first_id: threadtype_first_id)
    if post.id == post.group.posts.first.id
      RoomChannel.broadcast_to(post.user,post:post,post_id:post.group.posts.all.count,type:"new_maker")
    else
      RoomChannel.broadcast_to(post.user,post:post,post_id:post.group.posts.all.count,type:"poster")
    end
  end
  private
  def render_post(post)
    ApplicationController.renderer.render(partial: 'posts/post', locals: { post: post,type:"normal" })
  end
end

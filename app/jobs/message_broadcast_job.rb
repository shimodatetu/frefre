class MessageBroadcastJob < ApplicationJob
  queue_as :default
  def perform(post)
    ActionCable.server.broadcast('room_channel',post:post,post_id:post.group.posts.all.count,message: render_post(post),type:"accept")
    RoomChannel.broadcast_to(post.user,type:"maker")
  end
  private
  def render_post(post)
    ApplicationController.renderer.render(partial: 'posts/post', locals: { post: post })
  end
end

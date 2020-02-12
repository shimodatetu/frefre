class MessageBroadcastJob < ApplicationJob
  queue_as :default
  def perform(post)
    p "--------------------------"
    p post
    p "--------------------------"
    group = post.group
    RoomChannel.broadcast_to(group, message: render_post(post))
    #ActionCable.server.broadcast('room_channel',user_id:post.user_id, group_id:post.group_id,data_id:post.id,data:post,
    #post_id:post.group.posts.all.count,message: render_post(post))
  end
  private
  def render_post(post)
    ApplicationController.renderer.render(partial: 'posts/post', locals: { post: post })
  end
end

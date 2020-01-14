class MessageBroadcastJob < ApplicationJob
  queue_as :default
  def perform(post)
    if post.subtitle_jp == "" || post.subtitle_en == ""
      ActionCable.server.broadcast('room_channel',user_id:post.user_id, group_id:post.group_id,data_id:post.id,data:post,
      post_id:post.id_ingroup,message: render_post(post))
    else
      ActionCable.server.broadcast('room_channel',user_id:post.user_id, group_id:post.group_id,data_id:post.id,data:post,
      post_id:post.id_ingroup,message: render_post(post),url:url_for(post.video))
    end
  end
  private
  def render_post(post)
    ApplicationController.renderer.render(partial: 'posts/post', locals: { post: post })
  end
end

class MessageBroadcastJob < ApplicationJob
  queue_as :default
  def perform(message)
    ActionCable.server.broadcast 'room_channel',user_id:message.user_id, group_id:message.group_id,post_id:message.id_ingroup,
    message: render_message(message),image:message.image,id:message.id
  end
  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'posts/post', locals: { post: message })
  end
end

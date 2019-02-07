class ThreadBroadcastJob < ApplicationJob
  queue_as :default
  def perform(message)
    ActionCable.server.broadcast 'thread_channel', user_id:message.user_id,message: render_message(message),id: message.id
  end
  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'groups/group', locals: { group: message })
  end
end

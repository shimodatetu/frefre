class ThreadBroadcastJob < ApplicationJob
  queue_as :default
  def perform(message)
    p "----------------------------"
    p message
    p "----------------------------"
    ActionCable.server.broadcast 'thread_channel', user_id:message.user_id,id: message.id
  end
  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'groups/group', locals: { group: message })
  end
end

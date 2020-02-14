class NodejsChannel < ApplicationCable::Channel
  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "nodejs_channel"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_node

  end
end

class ThreadtypeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ThreadtypeChannel.broadcast_to(user, joining_id: data[0],joiner_id: data[1])
  end
end

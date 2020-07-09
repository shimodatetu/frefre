class ThreadtypeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ApprovalChannel.broadcast_to(user, threadtype_id:threadtype_id)
  end
end

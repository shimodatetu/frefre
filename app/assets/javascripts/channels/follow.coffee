App.follow = App.cable.subscriptions.create "FollowChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    alert("help")
  following: (type,id)->
    @perform('following',type:type,id:id)


$(document).on 'click', '.unfollow_button_submit', (event) ->
  App.follow.following("unfollow",parseInt(this.id))

$(document).on 'click', '.follow_button_submit', (event) ->
  App.follow.following("follow",parseInt(this.id))

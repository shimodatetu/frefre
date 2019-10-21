App.follow = App.cable.subscriptions.create "FollowChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if $('.follow_button .glyphicon-star').length == 1
      $(".follow_button .glyphicon-star").removeClass('glyphicon-star').addClass('glyphicon-star-empty');
      $(".unfollow_button_submit .text_box .jp").html("フォロー")
      $(".unfollow_button_submit .text_box .en").html("Follow")
      $(".unfollow_button_submit").removeClass('unfollow_button_submit').addClass('follow_button_submit');
    else
      $(".follow_button .glyphicon-star-empty").removeClass('glyphicon-star-empty').addClass('glyphicon-star');
      $(".follow_button_submit .text_box .jp").html("フォロー中")
      $(".follow_button_submit .text_box .en").html("Following")
      $(".follow_button_submit").removeClass('follow_button_submit').addClass('unfollow_button_submit');
  following: (type,id)->
    @perform('following',type:type,id:id)


$(document).on 'click', '.unfollow_button_submit', (event) ->
  App.follow.following("unfollow",parseInt(this.id))

$(document).on 'click', '.follow_button_submit', (event) ->
  App.follow.following("follow",parseInt(this.id))

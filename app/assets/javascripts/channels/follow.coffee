App.follow = App.cable.subscriptions.create "FollowChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    button_change(data.data.following_id)
  following: (type,id)->
    @perform('following',type:type,id:id)

follow_id = 0

$(document).on 'click', '.unfollow_button_submit', (event) ->
  $("#follow_modal").modal("show")
  follow_id = this.id

$(document).on 'click', '.unfollow_modal_submit', (event) ->
  App.follow.following("unfollow",parseInt(follow_id))
  #button_change(follow_id)
  $("#follow_modal").modal("hide")

$(document).on 'click', '.follow_button_submit', (event) ->
  #button_change(follow_id)
  App.follow.following("follow",parseInt(this.id))

button_change=(id) ->
  if $('.follow_button'+id+' .glyphicon-star').length == 1
    $(".follow_button"+id+" .glyphicon-star").removeClass('glyphicon-star').addClass('glyphicon-star-empty');
    $(".follow_button"+id+" .unfollow_button_submit .text_box .jp").html("フォロー")
    $(".follow_button"+id+" .unfollow_button_submit .text_box .en").html("Follow")
    $(".follow_button"+id+" .unfollow_button_submit").removeClass('unfollow_button_submit').addClass('follow_button_submit');
  else
    $(".follow_button"+id+" .glyphicon-star-empty").removeClass('glyphicon-star-empty').addClass('glyphicon-star');
    $(".follow_button"+id+" .follow_button_submit .text_box .jp").html("フォロー中")
    $(".follow_button"+id+" .follow_button_submit .text_box .en").html("Following")
    $(".follow_button"+id+" .follow_button_submit").removeClass('follow_button_submit').addClass('unfollow_button_submit');

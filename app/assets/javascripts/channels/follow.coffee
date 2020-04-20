
App.follow = App.cable.subscriptions.create "FollowChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if $(".user_id").attr('id') == String(data["follower_id"])
      $(".follow_button_submit , .unfollow_button_submit").attr("style","none;")
      button_change(data["following_id"])

  following: (type,id)->
    $(".follow_button_submit , .unfollow_button_submit").attr("style","pointer-events: none;")
    @perform('following',type:type,id:id)

$(document).on 'click', '.unfollow_button_submit', (event) ->
  $("#follow_modal").modal("show")
  $(".unfollow_modal_submit").attr("id",this.id)

$(document).on 'click', '.unfollow_modal_submit', (event) ->
  App.follow.following("unfollow",parseInt(this.id))
  $("#follow_modal").modal("hide")

$(document).on 'click', '.follow_button_submit', (event) ->
  App.follow.following("follow",parseInt(this.id))

$(document).on 'hidden.bs.modal', '#follow_modal', (event) ->
  $(".follow_button_submit , .unfollow_button_submit").attr("style","none;");


button_change=(id) ->
  if $('.follow_button'+id+' .glyphicon-star').length > 0
    $(".follow_button"+id+" .glyphicon-star").removeClass('glyphicon-star').addClass('glyphicon-star-empty');
    $(".follow_button"+id+" .unfollow_button_submit .text_box .jp").html("フォロー")
    $(".follow_button"+id+" .unfollow_button_submit .text_box .en").html("Follow")
    $(".follow_button"+id+" .unfollow_button_submit").removeClass('unfollow_button_submit').addClass('follow_button_submit');
  else
    $(".follow_button"+id+" .glyphicon-star-empty").removeClass('glyphicon-star-empty').addClass('glyphicon-star');
    $(".follow_button"+id+" .follow_button_submit .text_box .jp").html("フォロー中")
    $(".follow_button"+id+" .follow_button_submit .text_box .en").html("Following")
    $(".follow_button"+id+" .follow_button_submit").removeClass('follow_button_submit').addClass('unfollow_button_submit');


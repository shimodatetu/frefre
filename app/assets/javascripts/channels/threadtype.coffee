App.threadtype = App.cable.subscriptions.create "ThreadtypeChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if $(".user_id").attr('id') == String(data["joiner_id"])
      $(".join_button_submit , .unjoin_button_submit").attr("style","none;")
      button_change(data["joining_id"])

  join: (type,id)->
    $(".join_button_submit , .unjoin_button_submit").attr("style","pointer-events: none;")
    @perform('joining',type:type,id:id)

$(document).on 'click', '.unjoin_button_submit', (event) ->
  $("#join_modal").modal("show")
  $(".unjoin_modal_submit").attr("id",this.id)

$(document).on 'click', '.unjoin_modal_submit', (event) ->
  App.join.join("unjoin",parseInt(this.id))
  $("#join_modal").modal("hide")

$(document).on 'click', '.join_button_submit', (event) ->
  App.join.join("join",parseInt(this.id))

$(document).on 'hidden.bs.modal', '#join_modal', (event) ->
  $(".join_button_submit , .unjoin_button_submit").attr("style","none;");


button_change=(id) ->
  if $('.join_button'+id+' .glyphicon-star').length > 0
    $(".join_button"+id+" .glyphicon-star").removeClass('glyphicon-star').addClass('glyphicon-star-empty');
    $(".join_button"+id+" .unjoin_button_submit .text_box .jp").html("フォロー")
    $(".join_button"+id+" .unjoin_button_submit .text_box .en").html("join")
    $(".join_button"+id+" .unjoin_button_submit").removeClass('unjoin_button_submit').addClass('join_button_submit');
  else
    $(".join_button"+id+" .glyphicon-star-empty").removeClass('glyphicon-star-empty').addClass('glyphicon-star');
    $(".join_button"+id+" .join_button_submit .text_box .jp").html("フォロー中")
    $(".join_button"+id+" .join_button_submit .text_box .en").html("joining")
    $(".join_button"+id+" .join_button_submit").removeClass('join_button_submit').addClass('unjoin_button_submit');


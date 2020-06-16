App.threadtype = App.cable.subscriptions.create "ThreadtypeChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(".join_button_submit , .unjoin_button_submit").attr("style","none;")
    button_change(String(data["joiner_id"]))

  join: (type,id)->
    $(".join_button_submit , .unjoin_button_submit").attr("style","pointer-events: none;")
    @perform('joining',type:type,id:id)

$(document).on 'click', '.unjoin_button_submit', (event) ->
  $("#join_modal").modal("show")
  $(".unjoin_modal_submit").attr("id",this.id)

$(document).on 'click', '.unjoin_modal_submit', (event) ->
  App.threadtype.join("unjoin",parseInt(this.id))
  $("#join_modal").modal("hide")

$(document).on 'click', '.join_button_submit', (event) ->
  App.threadtype.join("join",parseInt(this.id))

$(document).on 'hidden.bs.modal', '#join_modal', (event) ->
  $(".join_button_submit , .unjoin_button_submit").attr("style","none;");


button_change=(id) ->
  if $('.join_button'+id+' .unjoin_button_submit').length > 0
    $(".join_button"+id+" .unjoin_button_submit .text_box .jp").html("Join / 参加する")
    $(".join_button"+id+" .unjoin_button_submit").removeClass('unjoin_button_submit').addClass('join_button_submit');
  else
    $(".join_button"+id+" .join_button_submit .text_box .jp").html("Joined / 参加済")
    $(".join_button"+id+" .join_button_submit").removeClass('join_button_submit').addClass('unjoin_button_submit');


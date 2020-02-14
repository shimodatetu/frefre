App.nodejs = App.cable.subscriptions.create "NodejsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("#fakeLoader").fadeOut();
    alert("asd")
    console.log(data)
    # Called when there's incoming data on the websocket for this channel

  send_node: ->
    @perform 'send'

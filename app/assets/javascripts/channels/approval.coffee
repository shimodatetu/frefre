App.approval = App.cable.subscriptions.create "ApprovalChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(".join_button_submit , .approved_button_submit").attr("style","none;")
    alert_modal("You successed to approve this community.","コミュニティの申請にに成功しました。","success")
    location.reload()

  add: (type,id)->
    $(".join_button_submit , .approved_button_submit").attr("style","pointer-events: none;")
    #button_change(id)
    @perform('add',id:id)

$(document).on 'click', '.approves_button_submit.click', (event) ->
  App.approval.add("add",parseInt(this.id))


button_change=(id) ->
  $(".join_button"+id+" .approves_button_submit .text_box .jp").html("You Approved Community / コミュニティ参加申請済み")
  $(".join_button"+id+" .approves_button_submit").removeClass('approved_button_submit').addClass('unjoin_button_submit');


App.profile = App.cable.subscriptions.create "ProfileChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

  change: (username,gender,country,profile_en,profile_jp,able_see) ->
    @perform 'change',username:username,gender:gender,
    country:country,profile_en:profile_en,profile_jp:profile_jp,able_see:able_see
    alert_set("Your profile was successfully saved.","プロフィールの保存に成功しました","success")
    location.reload()

$(document).on 'click', '#profile_modal .btn_send', (event) ->
  ###
  able_see = $("#cmn-toggle-1").prop("checked")
  username = $(".profile_page #username").val();
  gender = $(".profile_page #gender").val();
  country = $(".profile_page #country").val();
  profile_en = $("#profile_modal .en_form").val();
  profile_jp = $("#profile_modal .jp_form").val();
  App.profile.change(username,gender,country,profile_en,profile_jp,able_see)
  ###
  profile_en = $("#profile_modal .en_form").val();
  profile_jp = $("#profile_modal .jp_form").val();
  $(".profile_page #profile_en").val(profile_en);
  $(".profile_page #profile_jp").val(profile_jp);
  $("#profile_modal").modal('hide')


$(document).on 'click', '.prof_trans .words_post_button', (event) ->
  profile_en = $(".profile_page #profile_en").val();
  profile_jp = $(".profile_page #profile_jp").val();
  if profile_en == "" && profile_jp != ""
    translate_google(profile_en,profile_jp,"en")
  else if profile_en != "" && profile_jp == ""
    translate_google(profile_en,profile_jp,"ja")

$(document).on 'click', '.profile_save_button', (event) ->
  #year = $(".profile_page #year").val();
  #month = $(".profile_page #month").val();
  #date = $(".profile_page #date").val();
  year = 1;
  month = 1;
  date = 1;
  able_see = $("#cmn-toggle-1").prop("checked")
  username = $(".profile_page #username").val();
  gender = $(".profile_page #gender").val();
  country = $(".profile_page #country").val();
  profile_en = $(".profile_page #profile_en").val();
  profile_jp = $(".profile_page #profile_jp").val();
  App.profile.change(username,gender,country,profile_en,profile_jp,able_see)

translate_google=(profile_en,profile_jp,lang) ->

  words = profile_jp
  if lang == "ja"
    words = profile_en
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', words
  data.append 'target', lang
  settings =
    method: 'POST'
    body: data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->
    ary = text.split('"');
    trans_text = ary[7]#7番はテキスト
    if lang == "ja"
      #App.profile.change(username,gender,year,month,date,country,profile_en,trans_text,able_see)
      $("#profile_modal .en_form").val(words)
      $("#profile_modal .jp_form").val(trans_text)
      $(".explain_text .en").attr("style","")
      $(".explain_text .jp").attr("style","display:none")
      $(".explain_text .enjp").attr("style","display:none")
      $("#profile_modal").modal("show")
    else
      #App.profile.change(username,gender,year,month,date,country,trans_text,profile_jp,able_see)
      $("#profile_modal .en_form").val(trans_text)
      $("#profile_modal .jp_form").val(words)
      $(".explain_text .jp").attr("style","")
      $(".explain_text .en").attr("style","display:none")
      $(".explain_text .enjp").attr("style","display:none")
      $("#profile_modal").modal("show")

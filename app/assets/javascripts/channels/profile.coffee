
window.translated = false
App.profile = App.cable.subscriptions.create "ProfileChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    user_id = data["message"]["id"].to_s
    if $(".user_id").attr('id') == user_id
      alert_set("Your profile was successfully saved.","プロフィールの保存に成功しました","success")
      location.reload()

  change: (username,gender,country,profile_en,profile_jp,able_see) ->
    @perform 'change',username:username,gender:gender,
    country:country,profile_en:profile_en,profile_jp:profile_jp,able_see:able_see

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
  if window.translated == true && 1 == 2
    alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
  else if this.id == "trans_to_en"
    if profile_jp == ""
      alert_modal("Japanese introduction is empty.","日本語プロフィール欄に何も書かれていません","fail")
    else
      translate_google(profile_en,profile_jp,"en")
  else if this.id == "trans_to_jp"
    if profile_en == ""
      alert_modal("English introduction is empty.","英語プロフィール欄に何も書かれていません","fail")
    else
      translate_google(profile_en,profile_jp,"ja")
  else
    alert("asd");

$(document).on 'click', '.profile_cannot_save', (event) ->
  alert_modal("The event acount cannot be changed.","イベント用アカウントは変更できません","fail")

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
  source = "en"
  if lang == 'en'
    source = "ja"
  words = profile_jp
  if lang == "ja"
    words = profile_en
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', words
  data.append 'source', source
  data.append 'target', lang
  settings =
    method: 'POST'
    body: data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->
    ary = text.split('"');
    trans_text = ary[7]#7番はテキスト
    window.translated = true
    if lang == "ja"
      #App.profile.change(username,gender,year,month,date,country,profile_en,trans_text,able_see)
      ###
      $("#profile_modal .en_form").val(words)
      $("#profile_modal .jp_form").val(trans_text)
      $(".explain_text .en").attr("style","")
      $(".explain_text .jp").attr("style","display:none")
      $(".explain_text .enjp").attr("style","display:none")
      $("#profile_modal").modal("show")
      ###
      $("#profile_jp").val(trans_text)
    else
      #App.profile.change(username,gender,year,month,date,country,trans_text,profile_jp,able_see)
      ###
      $("#profile_modal .en_form").val(trans_text)
      $("#profile_modal .jp_form").val(words)
      $(".explain_text .jp").attr("style","")
      $(".explain_text .en").attr("style","display:none")
      $(".explain_text .enjp").attr("style","display:none")
      $("#profile_modal").modal("show")
      ###
      trans_text = trans_text.replace("&#39;","'")
      $("#profile_en").val(trans_text)

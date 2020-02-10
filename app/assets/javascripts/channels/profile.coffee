
ajax_send = ""
window.translated = false
App.profile = App.cable.subscriptions.create "ProfileChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    user_id = String(data["message"]["id"])
    user_type = data["message"]["usertype"]
    if $(".user_id").attr('id') == String(user_id) && user_type != "delete"
      $(".profile_save_button").attr("style","")
      alert_set("Your profile was successfully saved.","プロフィールの保存に成功しました","success")
      location.reload()

  change: (username,gender,country,profile_en,profile_jp,able_see) ->
    $(".profile_save_button").attr("style","pointer-events: none;")
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
      $("#fakeLoader").fakeLoader({},translate_google2,["en",profile_en,profile_jp]);
      #translate_google(profile_en,profile_jp,"en")
  else if this.id == "trans_to_jp"
    if profile_en == ""
      alert_modal("English introduction is empty.","英語プロフィール欄に何も書かれていません","fail")
    else
      $("#fakeLoader").fakeLoader({},translate_google2,["ja",profile_en,profile_jp]);
      #translate_google(profile_en,profile_jp,"ja")

$(document).on 'click', '.profile_cannot_save', (event) ->
  alert_modal("The event acount cannot be changed.","イベント用アカウントは変更できません","fail")

prohibit_check=(text_en,text_jp)->
  can_post = true
  check_text_en = text_en.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '')
  check_text_jp = text_jp.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '')
  gon.prohibit.forEach (prohibit) ->
    if check_text_en.match?(prohibit) || check_text_jp.match?(prohibit)
      console.log("not")
      can_post = false
      return
  return can_post


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

  if prohibit_check(profile_en,profile_jp) == true
    App.profile.change(username,gender,country,profile_en,profile_jp,able_see)
  else
    alert_modal("You cannot save because it contains prohibited words.","禁止ワードが含まれているので保存できません。","fail");

translate_google2=(data) ->
  lang = data[0]
  profile_en = data[1]
  profile_jp = data[2]
  words = profile_jp
  if lang == "ja"
    words = profile_en
  ajax_send = $.ajax(
    async: false
    url: 'https://still-plains-44123.herokuapp.com/trans_mirai',
    type: 'post'
    cache: false
    data:
      'lang': lang
      'words': words
    dataType: 'json').done((res) ->
    window.translated = true
    translation = res[0]
    $("#fakeLoader").fadeOut();
    if lang == "ja"
      $("#profile_jp").val(translation)
    else
      translation = translation.replace("&#39;","'")
      $("#profile_en").val(translation)
    return
  ).fail (xhr, status, error) ->
    alert status
    $("#fakeLoader").fadeOut();
    return

$(document).on 'click', '.fakeloader_cancel_button', (event) ->
  ajax_send.abort();
  $("#fakeLoader").fadeOut();

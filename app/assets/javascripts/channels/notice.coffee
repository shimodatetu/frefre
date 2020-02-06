
window.translated = false
App.notice = App.cable.subscriptions.create "NoticeChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    if data["profile_jump"] != undefined && (data['users'][0] == $(".get_user_id").attr("id") || data['users'][1] == $(".get_user_id").attr("id"))
      window.translated = false
      if location.href.indexOf("/profile/5") == -1
        alert_set("You successed to send a direct message.","ダイレクトメッセージの送信に成功しました。","success")
        location.href = "/profile/5/"+data["profile_jump"]
      else
        $(".chat_all").append(data['message'])
    else if String(data['users'][0]["id"]) == $(".get_user_id").attr("id") || String(data['users'][1]["id"]) == $(".get_user_id").attr("id")
      window.translated = false
      if location.href.indexOf("/profile/5") == -1
        alert_set("You successed to send a direct message.","ダイレクトメッセージの送信に成功しました。","success")
        location.href = "/profile/5/"+data['notice_id']
      else
        $(".chat_all").append(data['message'])
      # Called when there's incoming data on the websocket for this channel

  make: (lang, mes_jp,mes_en,address) ->
    address = Number(address)
    console.log(lang:lang,mes_jp:mes_jp,address:address,mes_en:mes_en)
    @perform('make',lang:lang,mes_jp:mes_jp,address:address,mes_en:mes_en)

$(document).on 'click', '.notice_post .mes_post_button',(event) ->
  #send_check()

send_check=()->
  content_en = $(".notice_post .en_data_content").val();
  content_jp = $(".notice_post .jp_data_content").val();
  if content_en == ""
    alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
  else if content_jp == ""
    alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
  else
    $("#noticeModal").modal("hide")
    App.notice.make("enjp",content_jp,content_en,$(".get_other_id").attr("id"));

$(document).on 'click', '.make_thread_cover .mes_post_button', (event) ->
  type_check($(@).attr("id"),$(".get_other_id").attr("id"))
  event.preventDefault()

prohibit_check=(text_en,text_jp)->
  can_post = true
  check_text_en = text_en.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '')
  check_text_jp = text_jp.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '')
  gon.prohibit.forEach (prohibit) ->
    if check_text_en.match?(prohibit) || check_text_jp.match?(prohibit)
      can_post = false
      return
  return can_post

type_check=(id,type)->
  if type == undefined
    alert_modal("Distination is not selected.","宛先が選択されていません。","fail");
  else
    content_en = $(".en_data_content").val();
    content_jp = $(".jp_data_content").val();
    if id == "post"
      if content_en == ""
        alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
      else if content_jp == ""
        alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
      else
        $("#noticeModal").modal("hide")
        if prohibit_check(content_en,content_jp) == true
          $(".jimaku_form").attr("style":"display:none");
          if $(".post_type").val() == "text"
            App.notice.make("none",content_jp,content_en,$(".get_other_id").attr("id"))
          else
            $(".thread_submit").click()
        else
          alert_modal("You cannot post because it contains prohibited words.","禁止ワードが含まれているので投稿できません。","fail");
        #$("#noticeModal .en_form_content").html(content_en)
        #$("#noticeModal .jp_form_content").html(content_jp)
        #$(".explain_text .en").attr("style","display:none")
        #$(".explain_text .jp").attr("style","display:none")
        #$(".explain_text .enjp").attr("style","")
        #$("#noticeModal").modal("show")
    else if window.translated == true && 1 == 2
      alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
    else if id == "trans_to_jp"
      if content_en == ""
        alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
      else
        #translate_google(content_en,"ja")
        $("#fakeLoader").fakeLoader({},translate_google,["ja",content_en]);
    else if id == "trans_to_en"
      if content_jp == ""
        alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
      else
        #translate_google(content_jp,"en")
        $("#fakeLoader").fakeLoader({},translate_google,["en",content_jp]);


translate_google=(data) ->
  lang = data[0]
  content = data[1]
  $.ajax(
    async: false
    url: 'https://still-plains-44123.herokuapp.com/trans_mirai',
    type: 'post'
    data:
      'lang': lang
      'words': content
    dataType: 'json').done((res) ->
    window.translated = true
    translation = res[0]
    if lang == "ja"
      $(".jp_data_content").val(translation);
    else
      translation = translation.replace("&#39;","'")
      $(".en_data_content").val(translation);
    $("#fakeLoader").fadeOut();

    return
  ).fail (xhr, status, error) ->
    alert status
    $("#fakeLoader").fadeOut();
    return

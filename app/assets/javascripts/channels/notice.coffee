
window.translated = false
App.notice = App.cable.subscriptions.create "NoticeChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    window.translated = false
    if location.href.indexOf("/profile/5") == -1
      location.href = "/profile/5/"+data['notice_id']
    else
      $(".chat_all").append(data['message'])
    # Called when there's incoming data on the websocket for this channel
  make: (lang, mes_jp,mes_en,address) ->
    address = Number(address)
    @perform('make',lang:lang,mes_jp:mes_jp,address:address,mes_en:mes_en)
    alert_set("You successed to send a direct message.","ダイレクトメッセージの送信に成功しました。","success")

$(document).on 'click', '#noticeModal .btn_send',(event) ->
  send_check()

send_check=()->
  content_en = $("#noticeModal .en_form_content").val();
  content_jp = $("#noticeModal .jp_form_content").val();
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
        App.notice.make("enjp",content_jp,content_en,$(".get_other_id").attr("id"));
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
  $("#fakeLoader").fakeLoader();
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

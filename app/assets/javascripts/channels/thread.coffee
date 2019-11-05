
window.translated = false
App.thread = App.cable.subscriptions.create "ThreadChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    window.translated = false
    local = '/thread/show/'+data['id']
    $('#groups').append data['message']
    if String(data['user_id']) == $(".get_user_id").attr("id")
      location.href=local
      alert_set("You successed to make a thread.","スレッドの作成に成功しました。","success")
    # Called when there's incoming data on the websocket for this channel
  make: (lang, title_jp,mes_jp,title_en,mes_en) ->
    @perform('make',lang:lang,title_jp:title_jp,message_jp:mes_jp,title_en:title_en,message_en:mes_en)


$(document).on 'click', '#groupModal .btn_send',(event) ->
  send_check()

send_check=()->
  title_en = $("#groupModal .en_form_title").val();
  title_jp = $("#groupModal .jp_form_title").val();
  content_en = $("#groupModal .en_form_content").val();
  content_jp = $("#groupModal .jp_form_content").val();
  if title_en == ""
    alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
  else if title_jp == ""
    alert_modal("Tille in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
  else if content_en == ""
    alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
  else if content_jp == ""
    alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
  else
    $("#groupModal").modal("hide")
    App.thread.make("enjp",title_jp,content_jp,title_en,content_en);

$(document).on 'click', '.make_thread_cover .words_post_button', (event) ->
  type_check($(@).attr("id"))
  event.preventDefault()

type_check=(id)->
  title_en = $(".en_data_title").val();
  title_jp = $(".jp_data_title").val();
  content_en = $(".en_data_content").val();
  content_jp = $(".jp_data_content").val();
  if id == "post"
    if title_en == ""
      alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
    else if title_jp == ""
      alert_modal("Tille in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
    else if content_en == ""
      alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
    else if content_jp == ""
      alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
    else
      $("#groupModal").modal("hide")
      App.thread.make("enjp",title_jp,content_jp,title_en,content_en);
  else if window.translated == true && 1 == 2
    alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
  else if id == "trans_to_en"
    if title_jp == ""
      alert_modal("Title in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
    else if content_jp == ""
      alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
    else
      translate_google(title_jp,content_jp,"en")
  else if id == "trans_to_jp"
    if title_en == ""
      alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
    else if content_en == ""
      alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
    else
      translate_google(title_en,content_en,"ja")

cut_hash=(hash_data)->
  hash_ary_main = []
  hash_ary = hash_data.split('#')
  for h in [0...hash_ary.length]
    hash_ary2 = hash_ary[h].split('＃')
    for i in [0...hash_ary2.length]
      hash_ary_main.push(hash_ary2[i])
  hash_ary_main.shift()
  return hash_ary_main

###
translate_google=(title,content,lang,hash_ary) ->
  source = "en"
  if lang == 'en'
    source = "ja"
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', title
  data.append 'q', content
  hash_base = []
  hash_ary.forEach (value) ->
    data.append 'q', value
    hash_base.push(value)
  data.append 'target', lang
  data.append 'source', source
  data.append 'format', "text"
  settings =
    method: 'POST'
    body: data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->
    window.translated = true
    translate = JSON.parse(text)["data"]["translations"]
    trans_title = translate[0]["translatedText"]
    trans_content = translate[1]["translatedText"]
    i = 1
    hash_ary = []
    while(translate[i+1] != undefined)
      i += 1
      hash_ary.push(translate[i]["translatedText"].replace("&#39;","'"));
    if lang == "ja"
      #$("#groupModal .en_form_hash").html("#"+hash_base.join("#"))
      #$("#groupModal .jp_form_hash").html("#"+hash_ary.join("#");)
      #$("#groupModal .en_form_content").html(content)
      #$("#groupModal .jp_form_content").html(trans_content)
      #$("#groupModal .en_form_title").val(title)
      #$("#groupModal .jp_form_title").val(trans_title)
      #$(".explain_text .en").attr("style","")
      #$(".explain_text .jp").attr("style","display:none")
      #$(".explain_text .enjp").attr("style","display:none")
      #$("#groupModal").modal("show")

      $(".jp_data_title").val(trans_title);
      $(".jp_data_content").html(trans_content);
      $(".hash_jp").html("#"+hash_ary.join("#"))
    else
      #$("#groupModal .en_form_hash").html("#"+hash_ary.join("#"))
      #$("#groupModal .jp_form_hash").html("#"+hash_base.join("#"))
      #$("#groupModal .en_form_content").html(trans_content)
      #$("#groupModal .jp_form_content").html(content)
      #$("#groupModal .en_form_title").val(trans_title)
      #$("#groupModal .jp_form_title").val(title)
      #$(".explain_text .jp").attr("style","")
      #$(".explain_text .en").attr("style","display:none")
      #$(".explain_text .enjp").attr("style","display:none")
      #$("#groupModal").modal("show")

      trans_title = trans_title.replace("&#39;","'")
      trans_content = trans_content.replace("&#39;","'")
      $(".en_data_title").val(trans_title);
      $(".en_data_content").html(trans_content);
      $(".hash_en").html("#"+hash_ary.join("#"))


translate_google=(title,content,lang,hash_ary) ->
  hash_base = ""
  first = true
  hash_ary.forEach (value) ->
    if first == true
      first = false
      hash_base += value
    else
      hash_base += "</>"+value
  alert(hash_base)
  console.log([title,content,hash_base])
  $.ajax(
    async: false
    url: 'https://still-plains-44123.herokuapp.com/translate_thread',
    type: 'post'
    data:
      'lang': lang,
      'words':[title,content,hash_base]
    dataType: 'json').done((res) ->
    console.log(res)
    window.translated = true
    trans_title = res[0]
    trans_content = res[1]
    hash_ary = res[2].split('</>')
    if lang == "ja"
      $(".jp_data_title").val(trans_title);
      $(".jp_data_content").html(trans_content);
      $(".hash_jp").html("#"+hash_ary.join("#"))
    else
      trans_title = trans_title.replace("&#39;","'")
      trans_content = trans_content.replace("&#39;","'")
      $(".en_data_title").val(trans_title);
      $(".en_data_content").html(trans_content);
      $(".hash_en").html("#"+hash_ary.join("#"))
    return
  ).fail (xhr, status, error) ->
    alert status
    return
###

translate_google=(title,content,lang) ->
  $.ajax(
    async: false
    url: 'https://still-plains-44123.herokuapp.com/trans_mirai_twice',
    type: 'post'
    data:
      'lang': lang,
      'words':[title,content]
    dataType: 'json').done((res) ->
    window.translated = true
    trans_title = res[0]
    trans_content = res[1]

    console.log(res)
    if lang == "ja"
      $(".jp_data_title").val(trans_title);
      $(".jp_data_content").val(trans_content);
    else
      $(".en_data_title").val(trans_title);
      $(".en_data_content").val(trans_content);
    return
  ).fail (xhr, status, error) ->
    alert status
    return

App.thread = App.cable.subscriptions.create "ThreadChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    local = '/thread/show/'+data['id']
    $('#groups').append data['message']
    if String(data['user_id']) == $(".get_user_id").attr("id")
      location.href=local
    # Called when there's incoming data on the websocket for this channel
  make: (lang, title_jp,mes_jp,title_en,mes_en,category,hash_jp,hash_en) ->
    category = Number(category)
    @perform('make',lang:lang,title_jp:title_jp,message_jp:mes_jp,category:category,title_en:title_en,message_en:mes_en,category:category,hash_en:hash_en,hash_jp:hash_jp)
    alert_set("You successed to make a thread.","スレッドの作成に成功しました。","success")
    location.reload()

$(document).on 'click', '#groupModal .btn_send',(event) ->
  send_check()

send_check=()->
  title_en = $("#groupModal .en_form_title").val();
  title_jp = $("#groupModal .jp_form_title").val();
  content_en = $("#groupModal .en_form_content").val();
  content_jp = $("#groupModal .jp_form_content").val();
  hash_en = $("#groupModal .en_form_hash").val()
  hash_jp = $("#groupModal .jp_form_hash").val()
  if title_en == ""
    alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
  else if title_jp == ""
    alert_modal("Tille in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
  else if content_en == ""
    alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
  else if content_jp == ""
    alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
  else if hash_en == ""
    alert_modal("Hashtag in English is empty.","英語のハッシュタグの欄に何も書かれていません","fail");
  else if hash_jp == ""
    alert_mofal("Hashtag in Japanese is empty.","日本語のハッシュタグの欄に何も書かれていません","fail");
  else
    hash_ary_en = cut_hash(hash_en)
    hash_ary_jp = cut_hash(hash_jp)
    if hash_ary_en.length != hash_ary_jp.length
      alert_modal("ハッシュタグが間違っています","Hashtag is wrong.","fail");
    else
      $("#groupModal").modal("hide")
      App.thread.make("enjp",title_jp,content_jp,title_en,content_en,$('input[name=type_select]:checked').val(),hash_ary_jp,hash_ary_en);

$(document).on 'click', '.make_thread_cover .post_button', (event) ->
  #alert($('input[name=type_select]:checked').val())
  type_check($(@).attr("id"),$('input[name=type_select]:checked').val())
  event.preventDefault()

type_check=(id,type)->
  if type == undefined
    alert_modal("Type of thread is not selected.","スレッドの種類が選択されていません","fail");
  else
    title_en = $(".en_data_title").val();
    title_jp = $(".jp_data_title").val();
    content_en = $(".en_data_content").val();
    content_jp = $(".jp_data_content").val();
    hash_en = $(".hash_en").val()
    hash_jp = $(".hash_jp").val()
    if title_en == "" && title_jp == "" && content_jp == "" && content_en == "" && hash_en == "" && hash_jp == ""
      alert_modal("Nothing is inputed.","何も入力されていません","fail")
    else if title_en == "" && content_en == "" && hash_en == ""
      title_jp = $(".jp_data_title").val();
      content_jp = $(".jp_data_content").val();
      hash_jp = $(".hash_jp").val();
      if title_jp == ""
        alert_modal("Title in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
      else if content_jp == ""
        alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
      else if hash_jp == ""
        alert_modal("Hashtag in Japanese is empty.","日本語のハッシュタグ入力欄に何も書かれていません","fail");
      else
        hash_ary_jp = cut_hash(hash_jp)
        translate_google(title_jp,content_jp,"en",hash_ary_jp)
    else if title_jp == "" && content_jp == "" && hash_jp == ""
      title_en = $(".en_data_title").val();
      content_en = $(".en_data_content").val();
      hash_en = $(".hash_en").val();
      if title_en == ""
        alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
      else if content_en == ""
        alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
      else if hash_en == ""
        alert_modal("Hashtag in English is empty.","英語のハッシュタグ入力欄に何も書かれていません","fail");
      else
        hash_ary_en = cut_hash(hash_en)
        translate_google(title_en,content_en,"ja",hash_ary_en)
    else
      if title_en == ""
        alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
      else if title_jp == ""
        alert_modal("Tille in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
      else if content_en == ""
        alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
      else if content_jp == ""
        alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
      else if hash_en == ""
        alert_modal("Hashtag in English is empty.","英語のハッシュタグの欄に何も書かれていません","fail");
      else if hash_jp == ""
        alert_modal("Hashtag in Japanese is empty.","日本語のハッシュタグの欄に何も書かれていません","fail");
      else
        hash_ary_en = cut_hash(hash_en)
        hash_ary_jp = cut_hash(hash_jp)
        if hash_ary_en.length != hash_ary_jp.length
          alert_modal("ハッシュタグが間違っています","Hashtag is wrong.","fail");
        else
          #App.thread.make("enjp",title_jp,content_jp,title_en,content_en,category,hash_ary_jp,hash_ary_en);
          $("#groupModal .en_form_hash").html(hash_en)
          $("#groupModal .jp_form_hash").html(hash_jp)
          $("#groupModal .en_form_content").html(content_en)
          $("#groupModal .jp_form_content").html(content_jp)
          $("#groupModal .en_form_title").val(title_en)
          $("#groupModal .jp_form_title").val(title_jp)
          $(".explain_text .en").attr("style","")
          $(".explain_text .jp").attr("style","display:none")
          $("#groupModal").modal("show")

cut_hash=(hash_data)->
  hash_ary_main = []
  hash_ary = hash_data.split('#')
  for h in [0...hash_ary.length]
    hash_ary2 = hash_ary[h].split('＃')
    for i in [0...hash_ary2.length]
      hash_ary_main.push(hash_ary2[i])
  hash_ary_main.shift()
  return hash_ary_main


translate_google=(title,coment,lang,hash_ary) ->
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', title
  data.append 'q', coment
  hash_base = []
  console.log(hash_ary)
  hash_ary.forEach (value) ->
    console.log(value)
    data.append 'q', value
    hash_base.push(value)
  data.append 'target', lang
  settings =
    method: 'POST'
    body: data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->
    ary = text.split('"');
    trans_title = ary[7]#7番はテキスト
    trans_content = ary[15]
    i = 15
    hash_ary = [];
    while(ary[i+8] != undefined)
      i += 8
      hash_ary.push(ary[i]);
    if lang == "ja"
      #App.thread.make(lang,ary[7],ary[15],title,coment,category,hash_base,hash_ary)
      $("#groupModal .en_form_hash").html("#"+hash_base.join("#"))
      $("#groupModal .jp_form_hash").html("#"+hash_ary.join("#");)
      $("#groupModal .en_form_content").html(coment)
      $("#groupModal .jp_form_content").html(ary[15])
      $("#groupModal .en_form_title").val(title)
      $("#groupModal .jp_form_title").val(ary[7])
      $(".explain_text .en").attr("style","")
      $(".explain_text .jp").attr("style","display:none")
      $("#groupModal").modal("show")
    else
      #App.thread.make(lang,title,coment,ary[7],ary[15],category,hash_ary,hash_base)
      $("#groupModal .en_form_hash").html("#"+hash_ary.join("#"))
      $("#groupModal .jp_form_hash").html("#"+hash_base.join("#"))
      $("#groupModal .en_form_content").html(ary[15])
      $("#groupModal .jp_form_content").html(coment)
      $("#groupModal .en_form_title").val(ary[7])
      $("#groupModal .jp_form_title").val(title)
      $(".explain_text .jp").attr("style","")
      $(".explain_text .en").attr("style","display:none")
      $("#groupModal").modal("show")

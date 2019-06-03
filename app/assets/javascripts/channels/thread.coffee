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
$(document).on 'click', '.make_thread_cover .post_button', (event) ->
  type_check($(@).attr("id"),$('.type_select').val())
  event.preventDefault()

type_check=(id,category)->
  if category == "" || category == undefined
    alert("カテゴリーが選択されていません\nCategory is not selected.");
  else
    hash_en = $(".hash_en").val()
    hash_jp = $(".hash_jp").val()
    hash_ary_en = cut_hash(hash_en)
    hash_ary_jp = cut_hash(hash_jp)
    if hash_ary_en.length != hash_ary_jp.length
      alert("ハッシュタグが間違っています\nHashtag is wrong.");
    else
      if id == "enjp"
        title_en = $(".en_data_title").val();
        title_jp = $(".jp_data_title").val();
        content_en = $(".en_data_content").val();
        content_jp = $(".jp_data_content").val();
        if title_en == ""
          alert("Title in English is empty.\n英語のタイトルの欄に何も書かれていません");
        else if title_jp == ""
          alert("Tille in Japanese is empty.\n日本語のタイトルの欄に何も書かれていません");
        else if content_en == ""
          alert("Title in English is empty.\n英語のタイトルの欄に何も書かれていません");
        else if content_jp == ""
          alert("Content in Japanese is empty.\n日本語入力欄に何も書かれていません");
        else
          App.thread.make("enjp",title_jp,content_jp,title_en,content_en,category,hash_ary_jp,hash_ary_en);
      else if id == "en"
        title_en = $(".en_data_title").val();
        content_en = $(".en_data_content").val();
        hash_en = $(".hash_en").val();
        if title_en == ""
          alert("Title in English is empty.\n英語のタイトルの欄に何も書かれていません");
        else if content_en == ""
          alert("Content in Japanese is empty.\n日本語入力欄に何も書かれていません");
        else
          translate_google(title_en,content_en,"ja",category,hash_ary_en)
      else if id == "jp"
        title_jp = $(".jp_data_title").val();
        content_jp = $(".jp_data_content").val();
        hash_jp = $(".hash_jp").val();
        if title_jp == ""
          alert("Title in Japanese is empty.\n日本語のタイトルの欄に何も書かれていません");
        else if content_jp == ""
          alert("日本語入力欄に何も書かれていません");
        else
          translate_google(title_jp,content_jp,"en",category,hash_ary_jp)

cut_hash=(hash_data)->
  hash_ary = []
  first = true
  hash_data.split('#').forEach (value) ->
    if first == true
      first = false
    else
      hash_ary.push(value)
  return hash_ary


translate_google=(title,coment,lang,category,hash_ary) ->
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', title
  data.append 'q', coment
  hash_base = []
  hash_ary.each (value) ->
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
    console.log(hash_base)
    console.log(hash_ary)
    if lang == "ja"
      App.thread.make(lang,ary[7],ary[15],title,coment,category,hash_base,hash_ary)
    else
      App.thread.make(lang,title,coment,ary[7],ary[15],category,hash_ary,hash_base)


bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte


window.translated = false
App.thread = App.cable.subscriptions.create "ThreadChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    if String(data['user_id']) == $(".get_user_id").attr("id")
      window.translated = false
      local = '/thread/show/'+data['id']
      $('#groups').append data['message']
      location.href=local
      alert_set("You successed to make a thread.","スレッドの作成に成功しました。","success")
    # Called when there's incoming data on the websocket for this channel
  make: (lang, title_jp,mes_jp,title_en,mes_en,types) ->
    $(".jimaku_form").attr("style":"display:none");
    @perform('make',lang:lang,title_jp:title_jp,message_jp:mes_jp,title_en:title_en,message_en:mes_en,types:types)


$(document).on 'click', '#groupModal .btn_send',(event) ->
  send_check()

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
    if prohibit_check(title_en,title_jp) == true && prohibit_check(content_en,content_jp) == true
      App.profile.change(username,gender,country,profile_en,profile_jp,able_see)
    else
      alert_modal("You cannot save because it contains prohibited words.","禁止ワードが含まれているので保存できません。","fail");

$(document).on 'click', '.make_thread_cover .thread_make .words_post_button', (event) ->
  type_check($(@).attr("id"))
  event.preventDefault()


$(document).on 'change', '.make_thread_cover #image_send', (event) ->
  $(".post_type").val("image")
  $(".video_show").attr("style":"display:none");
  reader = new FileReader
  reader.onload = (e) ->
    $(".image_show").attr("src": e.target.result);
    $(".image_show").attr("style":"display:block");
    return
  reader.readAsDataURL @files[0]
  $(".image_show").attr("style":"display:block");


$(document).on 'change', '.make_thread_cover #video_send', (event) ->
  $(".post_type").val("video")
  $(".image_show").attr("style":"display:none");
  fileList = @files
  i = 0
  l = fileList.length
  while l > i
    blobUrl = window.URL.createObjectURL(fileList[i])
    i++
  $(".vjs-tech").attr("style":"")
  $(".vjs-tech").attr("poster":blobUrl)
  $(".vjs-tech").attr("src":blobUrl)
  $(".video_show").attr("style":"display:block");
  $(".jimaku_form").attr("style":"display:block")


video_thread_subtitle=(data) ->
  lang = data[0]
  reader = new FileReader
  file = $('#video_send')[0].files[0]
  reader.onload = (e) ->
    fd = new FormData
    imgBlob = new Blob([ e.target.result ], type: file.type)
    fd.append 'video', imgBlob, file.name
    fd.append 'lang', lang
    $.ajax 'https://still-plains-44123.herokuapp.com/user_photo',
      processData: false
      contentType: false
      type: 'post'
      enctype: 'multipart/form-data'
      data: fd
      dataType: 'html'
      success: (data) ->
        words = data.slice( 2 ).slice( 0,-2 ).split('\",\"')
        console.log(words)
        $("#fakeLoader").fadeOut();
        if lang == "ja"
          $("#subcontent_eng").val(words[0])
          #$("#subcontent_jap").val(words[1])
        else if lang == "en"
          #$("#subcontent_eng").val(words[1])
          $("#subcontent_jap").val(words[0])
        return
      error: (err)->
        console.log(err)
        $("#fakeLoader").fadeOut();
        return
  reader.readAsArrayBuffer(file)
  false

$(document).on 'click', '.thread_auto_subtitle_en', (event) ->
  $("#fakeLoader").fakeLoader({},video_thread_subtitle,["ja"]);

$(document).on 'click', '.thread_auto_subtitle_ja', (event) ->
  $("#fakeLoader").fakeLoader({},video_thread_subtitle,["en"]);


type_check=(id)->
  types = []
  $('input:checked').each ->
    types.push( $(this).val() )
    return
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
      if $(".post_type").val() == "text"
        App.thread.make("enjp",title_jp,content_jp,title_en,content_en,types);
      else
        $(".thread_submit").click()
  else if window.translated == true && 1 == 2
    alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
  else if id == "trans_to_en"
    if title_jp == ""
      alert_modal("Title in Japanese is empty.","日本語のタイトルの欄に何も書かれていません","fail");
    else if content_jp == ""
      alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
    else
      #translate_google(title_jp,content_jp,"en")
      $("#fakeLoader").fakeLoader({},translate_google,["en",title_jp,content_jp]);
  else if id == "trans_to_jp"
    if title_en == ""
      alert_modal("Title in English is empty.","英語のタイトルの欄に何も書かれていません","fail");
    else if content_en == ""
      alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
    else
      #translate_google(title_en,content_en,"ja")
      $("#fakeLoader").fakeLoader({},translate_google,["ja",title_en,content_en]);
  else if id == "subtrans_to_en"
    content_jp = $(".sub_jp_data_content").val();
    if content_jp == ""
      alert_modal("Content in Japanese is empty.","日本語の内容入力欄に何も書かれていません","fail");
    else
      #translate_google(title_jp,content_jp,"en")
      $("#fakeLoader").fakeLoader({},translate_google2,["en",content_jp]);
  else if id == "subtrans_to_jp"
    content_en = $(".sub_en_data_content").val();
    if content_en == ""
      alert_modal("Content in English is empty.","英語の内容入力欄に何も書かれていません","fail");
    else
      #translate_google(title_en,content_en,"ja")
      $("#fakeLoader").fakeLoader({},translate_google2,["ja",content_en]);

cut_hash=(hash_data)->
  hash_ary_main = []
  hash_ary = hash_data.split('#')
  for h in [0...hash_ary.length]
    hash_ary2 = hash_ary[h].split('＃')
    for i in [0...hash_ary2.length]
      hash_ary_main.push(hash_ary2[i])
  hash_ary_main.shift()
  return hash_ary_main

translate_google=(data) ->
  lang = data[0]
  title = data[1]
  content = data[2]
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

    if lang == "ja"
      $(".jp_data_title").val(trans_title);
      $(".jp_data_content").val(trans_content);
    else
      $(".en_data_title").val(trans_title);
      $(".en_data_content").val(trans_content);
    $("#fakeLoader").fadeOut();
    return
  ).fail (xhr, status, error) ->
    alert status
    console.log(xhr)
    console.log(error)
    $("#fakeLoader").fadeOut();
    return

translate_googl2e=(data) ->
  lang = data[0]
  subtitle = data[1]
  $.ajax(
    async: false
    url: 'https://still-plains-44123.herokuapp.com/trans_mirai',
    type: 'post'
    data:
      'lang': lang,
      'words':subtitle
    dataType: 'json').done((res) ->
    window.translated = true
    trans_subtitle = res[0]
    if lang == "ja"
      $(".sub_jp_data_content").val(trans_subtitle);
    else
      $(".sub_en_data_content").val(trans_subtitle);
    $("#fakeLoader").fadeOut();
    return
  ).fail (xhr, status, error) ->
    $("#fakeLoader").fadeOut();
    return


window.translated = false
window.touched = false
ajax_send = ""
App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    url = location.pathname
    urls = url.split("/")
    now_id = urls[3]
    window.translated = false
    user_id = Number($(".user_login").attr("id"))
    if user_id == data['user_id']
      $(".thread_send #post").attr("style","")
      $(".thread_submit_image").attr("style","display:none")
      $(".thread_submit_video").attr("style","display:none")

    now_page = 1
    if urls.length >= 5
      now_page = urls[4]
    page_id_max = 20
    page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
    if url.indexOf("groups") != -1 && user_id == data['user_id']
      alert_set("You successed to make a thread.","スレッドの作成に成功しました。","success")
      window.location.href = "/thread/show/" + data["data"]["group_id"] + "/" + String(Number(page))
    else if url.indexOf('thread/show') != -1 && Number(now_id) == data['group_id']
      if Number(now_page) + 1 == page && parseInt(data['post_id']) % page_id_max == 1
        if user_id == data['user_id']
          window.location.href = "/thread/show/" + String(now_id) + "/" + String(Number(now_page) + 1)
      else if Number(now_page) == page
        if user_id == data['user_id']
          $(".base_en_form").val("");
          $(".base_jp_form").val("");
        add_post(data,user_id)
      else
        window.location.href = "/thread/show/" + String(now_id) + "/" + String(page)
  speak: (lang,mes_jp,mes_en, group)->
    $(".thread_send #post").attr("style","pointer-events: none;")
    $(".thread_submit_image").attr("style","display:none;pointer-events: none;")
    $(".thread_submit_video").attr("style","display:none;pointer-events: none;")
    @perform('speak',group_id:group,content_jap:mes_jp,content_eng:mes_en,lang:lang)

  #image: (file,group)->
  #  @perform('image',group_id:group,image:file,lang:"none")

reader = new FileReader
reader2 = new FileReader
String::bytes = ->
  encodeURIComponent(this).replace(/%../g, 'x').length

reader.addEventListener 'load', ->
  text = "<img src='" + String(reader.result) + "'>"
  App.room.image(reader.result,parseInt($("#group_id").val()))
  return

reader2.addEventListener 'load', ->
  text = "<img src='" + String(reader2.result) + "'>"
  $(".thread_all").append(text)


$(document).on 'click', '.post_image_submit', (event) ->
  $('.post_image_submit').prop('disabled', false)

$(document).on 'click', '.report_post_button', (event) ->
  $(".report_post_input").val(this.id)
  $("#report_post_modal").modal("show")


$(document).on 'change', '.thread_page .thread_image_post #file_send', (event) ->
  if($(this).attr("class") == "logined")
    $(".thread_submit_image").click()
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")

alert_show=()->
  alert("asd")

video_subtitle=(data) ->
  lang = data[0]
  reader = new FileReader
  file = $('.thread_page .thread_video_post #video_send')[0].files[0]
  reader.onload = (e) ->
    fd = new FormData
    imgBlob = new Blob([ e.target.result ], type: file.type)
    fd.append 'video', imgBlob, file.name
    fd.append 'lang', lang
    ajax_send = $.ajax 'https://still-plains-44123.herokuapp.com/user_photo',
      processData: false
      contentType: false
      type: 'post'
      enctype: 'multipart/form-data'
      data: fd
      dataType: 'html'
      success: (data) ->
        console.log(data)
        words = data.slice( 2 ).slice( 0,-2 ).split('\",\"')
        console.log(words)
        $("#fakeLoader").fadeOut();
        if lang == "ja"
          $("#video-subtitle-modal .subbase_en_form").val(words[0])
          $("#video-subtitle-modal .subbase_jp_form").val("")
          $("#video-subtitle-modal").modal("show")
          #$("#sub_content_jp").val(words[1])
        else if lang == "en"
          #$("#sub_content_en").val(words[1])
          $("#video-subtitle-modal .subbase_en_form").val("")
          $("#video-subtitle-modal .subbase_jp_form").val(words[0])
          $("#video-subtitle-modal").modal("show")
        return
      error: (err)->
        console.log(err)
        $("#fakeLoader").fadeOut();
        return
  reader.readAsArrayBuffer(file)

$(document).on 'click', '.auto_subtitle_en', (event) ->
  $("#fakeLoader").fakeLoader({},video_subtitle,["ja"]);

$(document).on 'click', '.auto_subtitle_ja', (event) ->
  $("#fakeLoader").fakeLoader({},video_subtitle,["en"]);

$(document).on 'change', '.thread_page .thread_video_post #video_send', (event) ->
  if($(this).attr("class") == "logined")
    video_show2()
    $("#video-modal").modal("show")
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")

$(document).on 'click', '#video-modal .non_add_subtitle', (event) ->
  $(".form_subtitle_input_en").val("")
  $(".form_subtitle_input_jp").val("")
  $(".thread_submit_image").click()
$(document).on 'click', '#video-modal .add_subtitle_jp', (event) ->
  video_show()
  $("#fakeLoader").fakeLoader({},video_subtitle,["en"]);
$(document).on 'click', '#video-modal .add_subtitle_en', (event) ->
  video_show()
  $("#fakeLoader").fakeLoader({},video_subtitle,["ja"]);

$(document).on 'click', '#video-modal .add_subtitle_self', (event) ->
  $("#video-subtitle-modal").modal("show")

$(document).on 'click', '#video-subtitle-modal .btn_video_send', (event) ->
  text_en = $(".subbase_en_form").val()
  text_jp = $(".subbase_jp_form").val()
  $(".form_subtitle_input_en").val(text_en)
  $(".form_subtitle_input_jp").val(text_jp)
  if text_en != "" && text_jp != ""
    if prohibit_check(text_en,text_jp) == true
      $("#video-subtitle-modal").modal("hide")
      $("#video-modal").modal("hide")
      $(".subbase_jp_form").val("")
      $(".subbase_en_form").val("")
      $(".thread_submit_video").click()
    else
      alert_modal("You cannot post because it contains prohibited words.","禁止ワードが含まれているので投稿できません。","fail");



video_show　=　->
  fileList = $(".thread_page .thread_video_post #video_send")[0].files
  i = 0
  l = fileList.length
  while l > i
    blobUrl = window.URL.createObjectURL(fileList[i])
    i++
  $("#video-subtitle-modal .video_show .vjs-tech").attr("style":"")
  $("#video-subtitle-modal .video_show .vjs-tech").attr("poster":blobUrl)
  $("#video-subtitle-modal .video_show .vjs-tech").attr("src":blobUrl)
  $("#video-subtitle-modal .video_show").attr("style":"display:block")

video_show2　=　->
  fileList = $(".thread_page .thread_video_post #video_send")[0].files
  i = 0
  l = fileList.length
  while l > i
    blobUrl = window.URL.createObjectURL(fileList[i])
    i++
  $("#video-modal .video_show .vjs-tech").attr("style":"")
  $("#video-modal .video_show .vjs-tech").attr("poster":blobUrl)
  $("#video-modal .video_show .vjs-tech").attr("src":blobUrl)
  $("#video-modal .video_show").attr("style":"display:block")

$(document).on 'click', '.thread_send .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    window.touched = false
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


add_post=(data,user_id)->
  if location.href.match("localhost")
    plus_post = $(data["message"].replace('example.org', 'localhost:3000'))
  else
    plus_post = $(data["message"].replace('example.org', 'www.frefreforum.com'))
  $(".thread_cover_cover").append plus_post
  plus_post.ready ->
    if user_id == data['user_id']
      $(".profile_button_destroy").click();
    else
      $(".delete_button_destroy").click();
      $(".report_button_destroy").click();
    jp_height = plus_post.find(".jp_content_row .post_content_text").height();
    en_height = plus_post.find(".en_content_row .post_content_text").height();
    row = (Math.max(jp_height,en_height) - 10) / 22;
    plus_post.find(".jp_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    plus_post.find(".en_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    slider = $(".slider-handle").attr("aria-valuenow");
    en_per = slider;
    jp_per = (100 - slider);
    if slider < 5
      plus_post.find(".en_position").attr("style","display:none;");
      plus_post.find(".jp_position").attr("style","width:calc(100%)");
      plus_post.find(".post_content_position_space").attr("style","display:none;");
    else if slider > 95
      plus_post.find(".en_position").attr("style","width:calc(100%)");
      plus_post.find(".jp_position").attr("style","display:none");
      plus_post.find(".post_content_position_space").attr("style","display:none;");
    else
      plus_post.find(".en_position").attr("style","width:calc("+en_per+"% - 15px)");
      plus_post.find(".jp_position").attr("style","width:calc("+jp_per+"% - 15px)");
      plus_post.find(".post_content_position_space").removeAttr("style");

prohibit_check=(text_en,text_jp)->
  can_post = true
  check_text_en = text_en.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '').replace(/@/g, '')
  check_text_jp = text_jp.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '').replace(/@/g, '')
  gon.prohibit.forEach (prohibit) ->
    if check_text_en.match?(prohibit) || check_text_jp.match?(prohibit)
      can_post = false
      return
  return can_post

type_check=(type)->
  if type == "post"
    text_en = $(".base_en_form").val();
    text_jp = $(".base_jp_form").val();
    if text_en != "" && text_jp != ""
      if prohibit_check(text_en,text_jp) == true
        App.room.speak("none",text_jp,text_en,parseInt($(".group_num").val()))
      else
        alert_modal("You cannot post because it contains prohibited words.","禁止ワードが含まれているので投稿できません。","fail");
    else if text_jp != ""
      alert_modal("The English is empty.","英語入力欄に何も書かれていません","fail");
    else if text_en != ""
      alert_modal("The Japanese form is empty.","日本語入力欄に何も書かれていません","fail");
    else
      alert_modal("This form is empty.","入力欄に何も書かれていません","fail");
  else
    if window.translated == true && 1 == 2
      alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
    else if type == "trans_to_en"
      text_en = $(".base_en_form").val();
      text_jp = $(".base_jp_form").val();
      if text_jp == ""
        alert_modal("Japanese form is empty.","日本語入力欄に何も書かれていません","fail")
      else
        #translate_google("en",text_jp)
        $("#fakeLoader").fakeLoader({},translate_google,["en",text_jp]);
    else if type == "trans_to_jp"
      text_en = $(".base_en_form").val();
      text_jp = $(".base_jp_form").val();
      if text_en == ""
        alert_modal("English form is empty.","英語入力欄に何も書かれていません","fail")
      else
        $("#fakeLoader").fakeLoader({},translate_google,["ja",text_en]);
        #translate_google("ja",text_en)
    else if type == "subtrans_to_en"
      text_en = $(".subbase_en_form").val();
      text_jp = $(".subbase_jp_form").val();
      if text_jp == ""
        alert_modal("Japanese subtitle form is empty.","日本語字幕入力欄に何も書かれていません","fail")
      else
        #translate_google("en",text_jp)
        $("#fakeLoader").fakeLoader({},translate_google2,["en",text_jp]);
    else if type == "subtrans_to_jp"
      text_en = $(".subbase_en_form").val();
      text_jp = $(".subbase_jp_form").val();
      if text_en == ""
        alert_modal("English subtitle form is empty.","英語字幕入力欄に何も書かれていません","fail")
      else
        $("#fakeLoader").fakeLoader({},translate_google2,["ja",text_en]);
        #translate_google("ja",text_en)



translate_google=(data) ->
  lang = data[0]
  words = data[1]
  if window.touched == false
    window.touched = true
    ajax_send = $.ajax(
      async: false
      url: 'https://still-plains-44123.herokuapp.com/trans_mirai',
      type: 'post'
      data:
        'lang': lang
        'words': words
      dataType: 'json').done((res) ->
      window.translated = true
      translation = res[0]
      if lang == "ja"
        $(".base_jp_form").val(translation)
      else
        translation = translation.replace("&#39;","'")
        $(".base_en_form").val(translation)
      $("#fakeLoader").fadeOut();
      window.touched = false
      return
    ).fail (xhr, status, error) ->
      alert status
      $("#fakeLoader").fadeOut();
      window.touched = false
      return

translate_google2=(data) ->
  lang = data[0]
  words = data[1]
  if window.touched == false
    window.touched = true
    ajax_send = $.ajax(
      async: false
      url: 'https://still-plains-44123.herokuapp.com/trans_mirai',
      type: 'post'
      data:
        'lang': lang
        'words': words
      dataType: 'json').done((res) ->
      window.translated = true
      translation = res[0]
      if lang == "ja"
        $(".subbase_jp_form").val(translation)
      else
        translation = translation.replace("&#39;","'")
        $(".subbase_en_form").val(translation)
      $("#fakeLoader").fadeOut();
      window.touched = false
      return
    ).fail (xhr, status, error) ->
      alert status
      $("#fakeLoader").fadeOut();
      window.touched = false
      return


bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

$(document).on 'click', '.fakeloader_cancel_button', (event) ->
  ajax_send.abort();
  $("#fakeLoader").fadeOut();

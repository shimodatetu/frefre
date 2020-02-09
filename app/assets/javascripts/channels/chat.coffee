
window.translated = false
ajax_send = ""
App.chat = App.cable.subscriptions.create "ChatChannel",
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
    now_page = 1
    if urls.length >= 5
      now_page = urls[4]
    page_id_max = 20
    page = Math.ceil((parseFloat(data['chat_id'])) / page_id_max)
    if user_id == data["chat"]['user_id']
      $(".notice_cover #post").attr("style","")
      $(".chat_thread_submit_image").attr("style","display:none;")
      $(".chat_thread_submit_video").attr("style","display:none;")

    if url.indexOf("notice/new") != -1 && user_id == data["chat"]['user_id']
      alert_set("You successed to send a direct message.","ダイレクトメッセージの送信に成功しました。","success")
      window.location.href = "/profile/5/" + data["notice_id"] + "/" + String(Number(page))
    else if url.indexOf("/profile/5") != -1 && Number(now_id) == data["chat"]['notice_id']
      if Number(now_page) + 1 == page && parseInt(data['chat_id']) % page_id_max == 1
        if user_id == data["chat"]['user_id']
          window.location.href = "/profile/5/" + String(now_id) + "/" + String(Number(now_page) + 1)
      else if Number(now_page) == page
        if user_id == data['user_id']
          $(".base_en_form").val("");
          $(".base_jp_form").val("");
        add_chat(data,user_id)
      else
        window.location.href = "/profile/5/" + String(now_id) + "/" + String(page)

  make: (lang,mes_jp,mes_en, group)->
    window.translated = false
    mes_jp = mes_jp.replace("// n", '').replace("//n", '');
    mes_en = mes_en.replace("//n", '').replace("// n", '');
    $(".notice_cover #post").attr("style","pointer-events: none;")
    $(".chat_thread_submit_image").attr("style","display:none;pointer-events: none;")
    $(".chat_thread_submit_video").attr("style","display:none;pointer-events: none;")
    alert_modal("You successed to post.","投稿に成功しました","success")
    console.log(group_id:group,content_jap:mes_jp,content_eng:mes_en,lang:"")
    @perform('make',group_id:group,content_jap:mes_jp,content_eng:mes_en,lang:"")
    $(".base_en_form").val("")
    $(".base_jp_form").val("")
    $('#chatModal-enjp').modal("hide")

  image: (file,group)->
    window.translated = false
    @perform('image',group_id:group,image:file,lang:"none")

add_chat=(data,user_id)->
  if location.href.match("localhost")
    plus_post = $(data["message"].replace('example.org', 'localhost:3000'))
  else
    plus_post = $(data["message"].replace('example.org', 'www.frefreforum.com'))
  $(".chat_all").append plus_post
  plus_post.ready ->
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

reader = new FileReader
reader.addEventListener 'load', ->
  text = "<img src='" + String(reader.result) + "'>"
  App.chat.image(reader.result,parseInt($("#group").val()))

$(document).on 'change', '.chat_image_post .post_file', (event) ->
  if (this.files[0].type != 'text/plain')
    reader.readAsDataURL(this.files[0], 'UTF-8');

$(document).on 'click', '.notice_cover .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


$(document).on 'click', '#chatModal-enjp .btn_send', (event) ->
  text_en = $("#chatModal-enjp .en_form").val();
  text_jp = $("#chatModal-enjp .jp_form").val();
  App.chat.make("none",text_jp,text_en,parseInt($("#group_num").val()))

add_post=(data)->
  plus_post = $(data["message"])
  $(".thread_cover").append plus_post
  plus_post.ready ->
    $(".delete_button_destroy").click();
    jp_height = plus_post.find(".jp_content_row .post_content_text").height();
    en_height = plus_post.find(".en_content_row .post_content_text").height();
    row = (Math.max(jp_height,en_height) - 10) / 22;
    plus_post.find(".jp_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    plus_post.find(".en_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    slider = $(".slider-handle").attr("aria-valuenow");
    en_per = slider / 10;
    jp_per = (1000 - slider) / 10;
    if slider < 100
      plus_post.find(".en_position").attr("style","display:none;");
      plus_post.find(".jp_position").attr("style","width:calc(100%)");
      plus_post.find(".post_content_position_space").attr("style","display:none;");
    else if slider > 900
      plus_post.find(".en_position").attr("style","width:calc(100%)");
      plus_post.find(".jp_position").attr("style","display:none");
      plus_post.find(".post_content_position_space").attr("style","display:none;");
    else
      plus_post.find(".en_position").attr("style","width:calc("+en_per+"% - 15px)");
      plus_post.find(".jp_position").attr("style","width:calc("+jp_per+"% - 15px)");
      plus_post.find(".post_content_position_space").removeAttr("style");

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

type_check=(id)->
  text_en = $(".base_en_form").val();
  text_jp = $(".base_jp_form").val();
  if id == "post"
    if text_en != "" && text_jp != ""
      if prohibit_check(text_en,text_jp) == true
        App.chat.make("none",text_jp,text_en,parseInt($("#group_num").val()))
      else
        alert_modal("You cannot post because it contains prohibited words.","禁止ワードが含まれているので投稿できません。","fail");
    else if text_jp != ""
      alert_modal("The English is empty.","英語入力欄に何も書かれていません","fail");
    else if text_en != ""
      alert_modal("The Japanese form is empty.","日本語入力欄に何も書かれていません","fail");
    else
      alert_modal("This form is empty.","入力欄に何も書かれていません","fail");
  else if window.translated == true && 1 == 2
    alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
  else if id == "trans_to_en"
    if text_jp == ""
      alert_modal("The Japanese form is empty.","日本語入力欄に何も書かれていません","fail");
    else
      #translate_google("en",text_jp)
      $("#fakeLoader").fakeLoader({},translate_google,["ja",text_jp]);
  else if id == "trans_to_jp"
    if text_en == ""
      alert_modal("The English is empty.","英語入力欄に何も書かれていません","fail");
    else
      #translate_google("ja",text_en)
      $("#fakeLoader").fakeLoader({},translate_google,["ja",text_en]);

$(document).on 'change', '.notice_cover .chat_thread_image_post #chat_file_send', (event) ->
  if($(this).attr("class") == "logined")
    $(".chat_thread_submit_image").click()
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


video_subtitle=(data) ->
  lang = data[0]
  reader = new FileReader
  file = $('.notice_cover .chat_thread_video_post #chat_video_send')[0].files[0]
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
          $("#chat_video-subtitle-modal .subbase_en_form").val(words[0])
          $("#chat_video-subtitle-modal .subbase_jp_form").val("")
          $("#chat_video-subtitle-modal").modal("show")
          #$("#sub_content_jp").val(words[1])
        else if lang == "en"
          #$("#sub_content_en").val(words[1])
          $("#chat_video-subtitle-modal .subbase_en_form").val("")
          $("#chat_video-subtitle-modal .subbase_jp_form").val(words[0])
          $("#chat_video-subtitle-modal").modal("show")
        return
      error: (err)->
        console.log(err)
        $("#fakeLoader").fadeOut();
        return
  reader.readAsArrayBuffer(file)

$(document).on 'change', '.notice_cover #chat_video_send', (event) ->
  if($(this).attr("class") == "logined")
    $(".post_type").val("video")
    $(".image_show").attr("style":"display:none");
    video_show2()
    $("#chat_video-modal").modal("show")

  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")

$(document).on 'click', '#chat_video-modal .non_add_subtitle', (event) ->
  $(".form_subtitle_input_en").val("")
  $(".form_subtitle_input_jp").val("")
  $(".chat_thread_submit_image").click()
$(document).on 'click', '#chat_video-modal .add_subtitle_jp', (event) ->
  video_show()
  $("#fakeLoader").fakeLoader({},video_subtitle,["en"]);
$(document).on 'click', '#chat_video-modal .add_subtitle_en', (event) ->
  video_show()
  $("#fakeLoader").fakeLoader({},video_subtitle,["ja"]);

$(document).on 'click', '#chat_video-modal .add_subtitle_self', (event) ->
  video_show()
  $("#chat_video-subtitle-modal").modal("show")

$(document).on 'click', '#chat_video-subtitle-modal .btn_video_send', (event) ->
  text_en = $(".subbase_en_form").val()
  text_jp = $(".subbase_jp_form").val()
  $(".chat_form_subtitle_input_en").val(text_en)
  $(".chat_form_subtitle_input_jp").val(text_jp)
  if text_en != "" && text_jp != ""
    if prohibit_check(text_en,text_jp) == true
      $("#chat_video-subtitle-modal").modal("hide")
      $("#chat_video-modal").modal("hide")
      $(".subbase_jp_form").val("")
      $(".subbase_en_form").val("")
      $(".chat_thread_submit_video").click()
    else
      alert_modal("You cannot post because it contains prohibited words.","禁止ワードが含まれているので投稿できません。","fail");



video_show　=　->
  fileList = $(".notice_cover .chat_thread_video_post #chat_video_send")[0].files
  i = 0
  l = fileList.length
  while l > i
    blobUrl = window.URL.createObjectURL(fileList[i])
    i++
  $("#chat_video-subtitle-modal .video_show .vjs-tech").attr("style":"")
  $("#chat_video-subtitle-modal .video_show .vjs-tech").attr("poster":blobUrl)
  $("#chat_video-subtitle-modal .video_show .vjs-tech").attr("src":blobUrl)
  $("#chat_video-subtitle-modal .video_show").attr("style":"display:block")

video_show2　=　->
  fileList = $(".notice_cover .chat_thread_video_post #chat_video_send")[0].files
  i = 0
  l = fileList.length
  while l > i
    blobUrl = window.URL.createObjectURL(fileList[i])
    i++
  $("#chat_video-modal .video_show .vjs-tech").attr("style":"")
  $("#chat_video-modal .video_show .vjs-tech").attr("poster":blobUrl)
  $("#chat_video-modal .video_show .vjs-tech").attr("src":blobUrl)
  $("#chat_video-modal .video_show").attr("style":"display:block")

translate_google=(data) ->
  lang = data[0]
  words = data[1]
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
      $(".base_jp_form").val(translation);
    else
      translation = translation.replace("&#39;","'")
      $(".base_en_form").val(translation);
    $("#fakeLoader").fadeOut();
    return
  ).fail (xhr, status, error) ->
    alert status
    $("#fakeLoader").fadeOut();
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

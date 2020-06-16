

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
    page_id_max = 20
    if data["type"] == "new_maker"
      page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
      alert_set("You successed to make a thread.","スレッドの作成に成功しました。","success")
      window.location.href = "/thread/show/" + data["post"]["group_id"] + "/" + String(Number(page))
    else if data["type"] == "poster"
      $(".thread_send #post").attr("style","")
      $(".thread_submit_image").attr("style","display:none;")
      $(".thread_submit_video").attr("style","display:none;")
      $(".trans_send").attr("style","display:none")
      if url.indexOf('thread/show') != -1
        page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
        now_id = 1
        if urls.length >= 4
          now_id = urls[3]
        if Number(now_id) == data["post"]['group_id']
          now_page = 1
          now_page_get = GetQueryString()["page"]
          if now_page_get != undefined
            now_page = now_page_get
          if Number(now_page) + 1 == page && parseInt(data['post_id']) % page_id_max == 1
            window.location.href = "/thread/show/" + String(now_id) + "/" + String(Number(now_page) + 1)
          else if Number(now_page) == page
            $(".base_en_form").val("");
            $(".base_jp_form").val("");
            if(!($('.thread_cover#'+data["post"]['id']).length))
              $(".profile_button_destroy").click();
          else
            window.location.href = "/thread/show/" + String(now_id) + "/" + String(page)
      else if url.indexOf('threadtype/show') != -1
        page_id_max = 10
        page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
        now_id = 1
        if urls.length >= 4
          now_id = urls[3]
        if Number(now_id) == data["post"]['threadtype_id'] && (urls[4] == 1 || urls.length <= 4)
          now_page = 1
          now_page_get = GetQueryString()["page"]
          if now_page_get != undefined
            now_page = now_page_get
          if Number(now_page) + 1 == page && parseInt(data['post_id']) % page_id_max == 1
            window.location.href = "/threadtype/show/" + String(now_id) + "/1/?page=" + String(Number(now_page) + 1)
          else if Number(now_page) == page
            $(".base_en_form").val("");
            $(".base_jp_form").val("");
            if(!($('.thread_cover#'+data["post"]['id']).length))
              $(".profile_button_destroy").click();
          else
            window.location.href = "/threadtype/show/" + String(now_id) + "/1/?page=" + String(page)
    else if data["type"] == "threadtype_maker"
      window.location.href = "/threadtype/show/"+data["threadtype_id"]
    else if data["type"] == "accept"
      if $(".thread_cover#"+data["post"]["threadtype_id"]).length == 0
        if url.indexOf('thread/show') != -1
          alert("thread")
          now_id = 1
          if urls.length >= 4
            now_id = urls[3]
          now_page = 1
          now_page_get = GetQueryString()["page"]
          if now_page_get != undefined
            now_page = now_page_get
          page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
          if(!($('.thread_cover#'+data["post"]['id']).length)) && Number(now_page) == page && Number(now_id) == data["post"]['group_id']
            add_post(data)
            $(".delete_button_destroy").click();
            $(".report_button_destroy").click();
        else if url.indexOf('threadtype/show') != -1 && data["threadtype_first_id"] == data["post"]["threadtype_id"]
            page_id_max = 10
            now_id = 1
            if urls.length >= 4
              now_id = urls[3]
            now_page = 1
            now_page_get = GetQueryString()["page"]
            if now_page_get != undefined
              now_page = now_page_get
            page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
            if !($('.thread_cover#'+data["post"]['id']).length) && Number(now_page) == page && Number(now_id) == data["post"]['threadtype_id']
              add_post(data)
              $(".delete_button_destroy").click();
              $(".report_button_destroy").click();

  speak: (lang,mes_jp,mes_en, group)->
    $(".thread_send #post").attr("style","pointer-events: none;")
    $(".thread_submit_image").attr("style","display:none;pointer-events: none;")
    $(".thread_submit_video").attr("style","display:none;pointer-events: none;")
    $(".trans_send").attr("style","display:none;pointer-events: none;")
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

$(document).on 'click', '.report_button_submit', (event) ->
  $("#report_post_modal").modal("hide")
  alert_modal("You reported this post","この投稿を通報しました。","success")

$(document).on 'change', '.thread_page .thread_image_post #file_send', (event) ->
  if($(this).attr("class") == "logined")
    $(".thread_submit_image").click()
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


video_subtitle=(data) ->
  $(".thread_video_post .lang_input").val(data[0])
  $(".thread_video_post").attr("action","/tasks/video")
  $(".thread_video_post .thread_submit_video").click()
  $(".cancel_button_class").val(".thread_video_post .send_time")
  $(".thread_video_post").attr("action","/posts")

$(document).on 'click', '.auto_subtitle_en', (event) ->
  $("#fakeLoader").fakeLoader({},video_subtitle,["ja"]);

$(document).on 'click', '.auto_subtitle_ja', (event) ->
  $("#fakeLoader").fakeLoader({},video_subtitle,["en"]);

$(document).on 'click', '.thread_page .thread_video_post #video_send', (event) ->
  this.value = ""
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
  video_show()
  $("#video-subtitle-modal").modal("show")

$(document).on 'click', '#video-subtitle-modal .btn_video_send', (event) ->
  text_en = $(".subbase_en_form").val()
  text_jp = $(".subbase_jp_form").val()
  $(".form_subtitle_input_en").val(text_en)
  $(".form_subtitle_input_jp").val(text_jp)
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

$(document).on 'click', '.post_form_page .thread_send .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    window.touched = false
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


add_post=(data)->
  if location.href.match("localhost")
    plus_post = $(data["message"].replace('example.org', 'localhost:3000'))
  else
    plus_post = $(data["message"].replace('example.org', 'www.frefreforum.com'))
  $(".thread_cover_cover").append plus_post
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
        $("#fakeLoader").fakeLoader({},trans_submit,["en",text_jp]);
    else if type == "trans_to_jp"
      text_en = $(".base_en_form").val();
      text_jp = $(".base_jp_form").val();
      if text_en == ""
        alert_modal("English form is empty.","英語入力欄に何も書かれていません","fail")
      else
        $("#fakeLoader").fakeLoader({},trans_submit,["ja",text_en]);
        #translate_google("ja",text_en)
    else if type == "subtrans_to_en"
      text_en = $(".subbase_en_form").val();
      text_jp = $(".subbase_jp_form").val();
      if text_jp == ""
        alert_modal("Japanese subtitle form is empty.","日本語字幕入力欄に何も書かれていません","fail")
      else
        #translate_google("en",text_jp)
        $("#fakeLoader").fakeLoader({},trans_submit2,["en",text_jp]);
    else if type == "subtrans_to_jp"
      text_en = $(".subbase_en_form").val();
      text_jp = $(".subbase_jp_form").val();
      if text_en == ""
        alert_modal("English subtitle form is empty.","英語字幕入力欄に何も書かれていません","fail")
      else
        $("#fakeLoader").fakeLoader({},trans_submit2,["ja",text_en]);
        #translate_google("ja",text_en)


trans_submit=(data) ->
  lang = data[0]
  $(".post_trans_form .lang_input").val(lang)
  $(".cancel_button_class").val(".post_trans_form .send_time")
  $(".post_trans_form .trans_send").click()

trans_submit2=(data) ->
  lang = data[0]
  $(".post_subtrans_form .lang_input").val(lang)
  $(".cancel_button_class").val(".post_subtrans_form .send_time")
  $(".post_subtrans_form .trans_send").click()

bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

GetQueryString = ->
  result = {}
  if 1 < window.location.search.length
    # 最初の1文字 (?記号) を除いた文字列を取得する
    query = window.location.search.substring(1)
    # クエリの区切り記号 (&) で文字列を配列に分割する
    parameters = query.split('&')
    i = 0
    while i < parameters.length
      # パラメータ名とパラメータ値に分割する
      element = parameters[i].split('=')
      paramName = decodeURIComponent(element[0])
      paramValue = decodeURIComponent(element[1])
      # パラメータ名をキーとして連想配列に追加する
      result[paramName] = paramValue
      i++
  result


App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    user_id = Number($(".user_login").attr("id"))
    urls = location.pathname.split("/")
    now_id = urls[3]
    if Number(now_id) == data['group_id']
      now_page = 1
      if urls.length >= 5
        now_page = urls[4]
      page_id_max = Number($(".thread_page_num").attr("id"))
      page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
      if Number(now_page) + 1 == page && parseInt(data['post_id']) % page_id_max == 1
        window.location.href = "/thread/show/" + String(now_id) + "/" + String(Number(now_page) + 1)
      else if Number(now_page) == page
        add_post(data)
      else if user_id == data['user_id']
        window.location.href = "/thread/show/" + String(now_id) + "/" + String(page)

  speak: (lang,mes_jp,mes_en, group)->
    mes_jp = mes_jp.replace(/\r\n/g, "<br />").replace(/(\n|\r)/g, "\r");
    mes_en = mes_en.replace(/\r\n/g, "<br />").replace(/(\n|\r)/g, "&lt;br&gt;");
    @perform('speak',lang: "en",content_jap: mes_jp,content_eng: mes_en, group_id: group)
    $('#sampleModal-enjp').modal("hide")


$(document).on 'click', '.post_footer .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    alert("You can't post a comment because you haven't logined.\nログインしていないので書き込めません。")


$(document).on 'click', '#sampleModal-enjp .btn_send', (event) ->
  text_en = $("#sampleModal-enjp .en_form").val();
  text_jp = $("#sampleModal-enjp .jp_form").val();
  App.room.speak("none",text_jp,text_en,parseInt($("#group").val()))

add_post=(data)->
  plus_post = $(data["message"])
  $(".thread_cover_cover").append plus_post
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



type_check=(id)->
  text_en = $(".base_en_form").val();
  text_jp = $(".base_jp_form").val();
  if text_en == "" && text_jp == ""
    alert("This form is empty.\n入力欄に何も書かれていません");
  else　if text_en != "" && text_jp != ""
    $("#sampleModal-enjp .en_form").val(text_en)
    $("#sampleModal-enjp .jp_form").val(text_jp)
    $('#sampleModal-enjp').modal("show")
  else if text_jp == ""
    translate_google("ja",text_en)
  else if text_en == ""
    translate_google("en",text_jp);
    # body...

translate_google=(lang,words) ->
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', words
  data.append 'target', lang
  data.append 'format', "text"
  settings =
    method: 'POST'
    body: data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->
    ary = text.split('"');
    translation = ary[7]#7番はテキスト
    if lang == "ja"
      $(".only_en_form").val("");
      #App.room.speak(lang,translation,words, group)
      $("#sampleModal-enjp .en_form").val(words)
      $("#sampleModal-enjp .jp_form").val(translation)
      $(".base_jp_form").val(translation)
      $('#sampleModal-enjp').modal("show")
    else
      $(".only_jp_form").val("");
      #App.room.speak(lang,words,translation, group)
      $("#sampleModal-enjp .jp_form").val(words)
      $("#sampleModal-enjp .en_form").val(translation)
      $(".base_en_form").val(translation)
      $('#sampleModal-enjp').modal("show")

bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

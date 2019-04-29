App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    plus_post = $(data["message"])
    $(".thread_cover_cover").append plus_post
    plus_post.ready ->
      jp_height = plus_post.find(".jp_content_row .post_content_text").height();
      en_height = plus_post.find(".en_content_row .post_content_text").height();
      row = (Math.max(jp_height,en_height) - 10) / 22;
      plus_post.find(".jp_content_row").attr("style","margin:7px;-webkit-line-clamp:"+Math.ceil(row));
      plus_post.find(".en_content_row").attr("style","margin:7px;-webkit-line-clamp:"+Math.ceil(row));
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


# ---
# generated by js2coffee 2.2.0

  speak: (lang,mes_jp,mes_en, group)->
    #mes_jp = mes_jp.replace(/\r\n/g, "<br />").replace(/(\n|\r)/g, "\r");
    #mes_en = mes_en.replace(/\r\n/g, "<br />").replace(/(\n|\r)/g, "&lt;br&gt;");
    @perform 'speak',lang: lang,content_jap: mes_jp,content_eng: mes_en, group_id: group

$(document).on 'click', '.thread_post_cover .btn_send', (event) ->
  type_check(this.id,$("#group").val())

type_check=(id,group)->
  if id == "enjp"
    text_en = $(".en_form").val();
    text_jp = $(".jp_form").val();
    if text_en == ""
      alert("English form is empty.\n英語の欄に何も書かれていません");
    else if text_jp == ""
      alert("Japanese form is empty.\n日本語入力欄に何も書かれていません");
    else
      $(".en_form").val("");
      $(".jp_form").val("");
      $('#sampleModal-enjp').modal('hide');
      App.room.speak("enjp",text_jp,text_en, group)
  else if id == "en"
      text = $(".only_en_form").val();
      if text == ""
        alert("Input form is empty.\n入力欄に何も書かれていません");
      else
        translate_google("ja",text,group)
  else if id == "jp"
      text = $(".only_jp_form").val();
      if text == ""
        alert("Input form is empty.\n入力欄に何も書かれていません");
      else
        $(".from_jp").attr("style","");
        $(".from_enjp").attr("style","display:none");
        $(".from_en").attr("style","display:none");
        translate_google("en",text,group);
    # body...

translate_google=(lang,words,group) ->
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', words
  data.append 'target', lang
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
      $('#sampleModal-en').modal('hide');
      App.room.speak(lang,translation,words, group)
    else
      $(".only_jp_form").val("");
      $('#sampleModal-jp').modal('hide');
      App.room.speak(lang,words,translation, group)

bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

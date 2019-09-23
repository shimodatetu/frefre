App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->

  make: (lang,mes_jp,mes_en, group)->
    mes_jp = mes_jp.replace("// n", '').replace("//n", '');
    mes_en = mes_en.replace("//n", '').replace("// n", '');
    @perform('make',group_id:group,content_jap:mes_jp,content_eng:mes_en,lang:lang)
    $(".base_en_form").val("")
    $(".base_jp_form").val("")
    $('#chatModal-enjp').modal("hide")

  image: (file,group)->
    @perform('image',group_id:group,image:file,lang:"none")

reader = new FileReader
reader.addEventListener 'load', ->
  text = "<img src='" + String(reader.result) + "'>"
  App.chat.image(reader.result,parseInt($("#group").val()))

$(document).on 'change', '.chat_image_post .post_file', (event) ->
  if (this.files[0].type != 'text/plain')
    reader.readAsDataURL(this.files[0], 'UTF-8');

$(document).on 'click', '.chat_send .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


$(document).on 'click', '#chatModal-enjp .btn_send', (event) ->
  text_en = $("#chatModal-enjp .en_form").val();
  text_jp = $("#chatModal-enjp .jp_form").val();
  App.chat.make("none",text_jp,text_en,parseInt($("#group").val()))

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



type_check=(id)->
  text_en = $(".base_en_form").val();
  text_jp = $(".base_jp_form").val();
  if id == "post"
    if text_en != "" && text_jp != ""
      $("#chatModal-enjp .en_form").val(text_en)
      $("#chatModal-enjp .jp_form").val(text_jp)
      $(".explain_text .en").attr("style","display:none")
      $(".explain_text .jp").attr("style","display:none")
      $(".explain_text .enjp").attr("style","")
      $('#chatModal-enjp').modal("show")
    else if text_jp != ""
      alert_modal("The English is empty.","英語入力欄に何も書かれていません","fail");
    else if text_en != ""
      alert_modal("The Japanese form is empty.","日本語入力欄に何も書かれていません","fail");
    else
      alert_modal("This form is empty.","入力欄に何も書かれていません","fail");
  else if id == "trans"
    if text_en != "" && text_jp != ""
      alert_modal("Both Englsh and Japanese form is filled.","両方の入力欄に入力されています","fail");
    else if text_jp != ""
      translate_google("en",text_jp)
    else if text_en != ""
      translate_google("ja",text_en)
    else
      alert_modal("This form is empty.","入力欄に何も書かれていません","fail")


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
    get_text = JSON.parse(text)["data"]["translations"][0]["translatedText"]
    translation = get_text
    if lang == "ja"
      $(".only_en_form").val("");
      #App.chat.make(lang,translation,words, group)
      $("#chatModal-enjp .en_form").val(words)
      $("#chatModal-enjp .jp_form").val(translation)
      #$(".base_en_form").val("")
      #$(".base_jp_form").val("")
      $(".explain_text .en").attr("style","")
      $(".explain_text .jp").attr("style","display:none")
      $(".explain_text .enjp").attr("style","display:none")
      $('#chatModal-enjp').modal("show")
    else
      $(".only_jp_form").val("");
      #App.chat.make(lang,words,translation, group)
      $("#chatModal-enjp .jp_form").val(words)
      $("#chatModal-enjp .en_form").val(translation)
      #$(".base_en_form").val("")
      #$(".base_jp_form").val("")
      $(".explain_text .jp").attr("style","")
      $(".explain_text .en").attr("style","display:none")
      $(".explain_text .enjp").attr("style","display:none")
      $('#chatModal-enjp').modal("show")

bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

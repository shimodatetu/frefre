
window.translated = false
App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    urls = location.pathname.split("/")
    now_id = urls[3]
    window.translated = false
    user_id = Number($(".user_login").attr("id"))
    if user_id == data['user_id']
      $('#post_id').val data['id']
      alert("asd")
      $('.post_image_submit').click()
      if Number(now_id) == data['group_id']
        now_page = 1
        if urls.length >= 5
          now_page = urls[4]
        page_id_max = Number($(".thread_page_num").attr("id"))
        page = Math.ceil((parseFloat(data['post_id'])) / page_id_max)
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
          #if user_id == data['user_id']
            #alert_set("You successed to post.","投稿に成功しました","success")

      $(".post_image_submit").prop('disabled', false)



  speak: (lang,mes_jp,mes_en, group)->
    mes_jp = mes_jp.replace("// n", '').replace("//n", '');
    mes_en = mes_en.replace("//n", '').replace("// n", '');
    #alert("id:"+group+"/mes_jp:"+mes_jp+"/mes_en:"+mes_en)
    @perform('speak',group_id:group,content_jap:mes_jp,content_eng:mes_en,lang:lang)
    #$(".base_en_form").val("")
    #$(".base_jp_form").val("")
    #$('#sampleModal-enjp').modal("hide")
  image: (file,group)->
    @perform('image',group_id:group,image:file,lang:"none")

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


$(document).on 'click', '.report_post_button', (event) ->
  $(".report_post_input").val(this.id)
  $("#report_modal").modal("show")

$(document).on 'change', '.thread_image_post #file_send', (event) ->
  if($(this).attr("class") == "logined")
    if (this.files[0].type != 'text/plain')
      reader.readAsDataURL(this.files[0], 'UTF-8');
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")

$(document).on 'click', '.thread_send .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")

###
$(document).on 'click', '#sampleModal-enjp .btn_send', (event) ->
  text_en = $("#sampleModal-enjp .en_form").val();
  text_jp = $("#sampleModal-enjp .jp_form").val();
  App.room.speak("none",text_jp,text_en,parseInt($("#group").val()))
###

add_post=(data,user_id)->
  plus_post = $(data["message"])
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



type_check=(type)->
  text_en = $(".base_en_form").val();
  text_jp = $(".base_jp_form").val();
  if type == "post"
    if text_en != "" && text_jp != ""
      can_post = true
      gon.prohibit.forEach (prohibit) ->
        if text_en.match?(prohibit) || text_jp.match?(prohibit)
          can_post = false
      if can_post == true
        App.room.speak("none",text_jp,text_en,parseInt($("#group").val()))
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
      if text_jp == ""
        alert_modal("Japanese form is empty.","日本語入力欄に何も書かれていません","fail")
      else
        translate_google("en",text_jp)
    else if type == "trans_to_jp"
      if text_en == ""
        alert_modal("English form is empty.","英語入力欄に何も書かれていません","fail")
      else
        translate_google("ja",text_en)



translate_google3=(lang,words) ->
  source = "en"
  if lang == 'en'
    source = "ja"
  words = "hello"
  key = window.ENV.RailsEnv
  url = 'https://apigw.mirai-api.net/trial/mt/v1.0/translate?langFrom=en&langTo=ja&profile=default&subscription-key='+key
  data = {
    "source": "The quick brown fox jumps over the lazy dog."
  }
  settings =
    method: 'POST',
    header:{
      "Content-Type":"application/json; charset=UTF-8",
      "Content-Length":bytes(data),
      "Host":"www.frefreforum.com"
    },
    body:data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->


translate_google=(lang,words) ->
  $.ajax(
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
    return
  ).fail (xhr, status, error) ->
    alert status
    return



###
translate_google4=(lang,words) ->
  source = "en"
  if lang == 'en'
    source = "ja"
  key = window.ENV.RailsEnv
  url = 'https://translation.googleapis.com/language/translate/v2?key=' + key
  data = new FormData
  data.append 'q', words
  data.append 'target', lang
  data.append 'source', source
  data.append 'format', "html"
  console.log(data)
  settings =
    method: 'POST'
    header:{
      header:"Access-Control-Allow-Origin: *"
    }
    body: data
  fetch(url, settings).then((res) ->
    res.text()
  ).then (text) ->
    window.translated = true
    get_text = JSON.parse(text)["data"]["translations"][0]["translatedText"]
    translation = get_text
    if lang == "ja"
      #$(".only_en_form").val("");
      #App.room.speak(lang,translation,words, group)
      #$("#sampleModal-enjp .en_form").val(words)
      #$("#sampleModal-enjp .jp_form").val(translation)
      #$(".base_en_form").val("")
      #$(".base_jp_form").val("")
      #$(".explain_text .en").attr("style","")
      #$(".explain_text .jp").attr("style","display:none")
      #$(".explain_text .enjp").attr("style","display:none")
      #$('#sampleModal-enjp').modal("show")
      $(".base_jp_form").val(translation)
    else
      #$(".only_jp_form").val("");
      #App.room.speak(lang,words,translation, group)
      #$("#sampleModal-enjp .jp_form").val(words)
      #$("#sampleModal-enjp .en_form").val(translation)
      #$(".base_en_form").val("")
      #$(".base_jp_form").val("")
      #$(".explain_text .jp").attr("style","")
      #$(".explain_text .en").attr("style","display:none")
      #$(".explain_text .enjp").attr("style","display:none")
      #$('#sampleModal-enjp').modal("show")
      translation = translation.replace("&#39;","'")
      $(".base_en_form").val(translation)
###
bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

App.nodejs = App.cable.subscriptions.create "NodejsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log(data)
    if data["success"] == "true"
      id = $("." + data["form_class"] + " .send_time").val()
      if id == data["send_time"]
        $("#fakeLoader").fadeOut();
        $("." + data["form_class"] + " .send_time").val(String(parseInt(id) + 1))
        if data["type"] == "trans"
          if data["lang"] == "ja"
            $("." + data["form_class"] + " ." + data["show_class_jp"]).val(data["trans"])
          else if data["lang"] == "en"
            $("." + data["form_class"] + " ." + data["show_class_en"]).val(data["trans"])
        else if data["type"] == "video"
          if data["lang"] == "en" || data["lang"] == "ja"
            if data["show_modal"] != ""
              $(data["show_modal"]).modal("show")
            class_words = data["show_class"]
            class_words +=  " "
            class_words_en = class_words + data["show_class_en"]
            class_words_jp = class_words + data["show_class_jp"]
            $(class_words_en).val("")
            $(class_words_jp).val("")
            if data["lang"] == "ja"
              $(class_words_en).val(data["trans"])
            else if data["lang"] == "en"
              $(class_words_jp).val(data["trans"])
  send_node: ->
    @perform 'send'

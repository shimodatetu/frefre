module ApplicationHelper
  require "uri"

  def current_user
    @current_user ||= User.find_by(id:session[:user_id])
  end

  def manager_logged_in?
    if !current_user.nil? && current_user.usertype == "manager"
      return current_user
    else
      return nil
    end
  end
  def logged_in?
    !current_user.nil?
  end

  def logout
   session[:user_id] = nil
  end

  def text_url_to_link text
    URI.extract(text, ['http']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end
    return text
  end
  def alert_en
     alert_en = flash["alert_en"]
     flash["alert_en"] = nil
     return alert_en
  end
  def alert_jp
     alert_jp = flash["alert_jp"]
     flash["alert_jp"] = nil
     return alert_jp
  end
  def alert_type
     alert_type = flash["alert_type"]
     flash["alert_type"] = nil
     return alert_type
  end
end

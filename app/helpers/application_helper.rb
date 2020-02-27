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
    session.delete(:user_id)
    @current_user = nil
  end

  def text_url_to_link text
    URI.extract(text, ['http']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end
    return text
  end
end

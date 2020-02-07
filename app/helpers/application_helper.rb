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

  def text_url_to_link(text)

    URI.extract(text, ["http", "https"]).uniq.each do |url|
      text.gsub!(url, "#{url}")
    end
    text
  end
end

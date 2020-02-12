class ApplicationController < ActionController::Base
 protect_from_forgery with: :exception

 add_flash_types :success, :info, :warning, :danger ,:search_big_id,:search_small_id, :alert_en, :alert_jp, :alert_type

 helper_method :current_user2
 #before_action :configure_permitted_parameters, if: :devise_controller?
 # def configure_permitted_parameters
 #    # サインアップ時にnameのストロングパラメータを追加
 #    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
 #    # アカウント編集の時にnameとprofileのストロングパラメータを追加
 #    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
 # end
 def current_user
   @current_user ||= User.find_by(id:session[:user_id])
 end
 def manager_logged_in?
   if !current_user.nil && current_user.usertype == "manager"
     return current_user
   else
     return false
   end
 end
 def logged_in?
   !current_user.nil?
 end
 def log_in(user)
   session[:user_id] = user.id
 end
 def logout
   current_user = nil
   session[:user_id] = nil
 end

 def user_image_default
   return "/user2.png"
 end

 #
 # require "google/cloud/translate"
 #
 #  # Your Google Cloud Platform project ID
 #  project_id = "AIzaSyCgjFOpuYQrKqsunVHpQporHSNmg1yW0mw"
 #
 #  # Instantiates a client
 #  translate = Google::Cloud::Translate.new project: project_id
 #
 #  # The text to translate
 #  text = "Hello, world!"
 #  # The target language
 #  target = "ru"
 #
 #  # Translates some text into Russian
 #  translation = translate.translate text, to: target
 #
 #  @test_base = "Text: #{text}"
 #  @test_trans = "Translation: #{translation}"
end

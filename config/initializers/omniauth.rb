Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :google_oauth2, "673565985277-8sv83se9a6j2dontbc1sj7nn1ftr3et9.apps.googleusercontent.com", "kSb3j8Tt_A1RyGbSszVEbtZG"
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET']
end

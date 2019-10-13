class SessionsController < ApplicationController
  def index
  end

  def new
  end
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password]) && user.activated? && user.oauth == false
      log_in user
      flash["alert_en"] = "You successed to login"
      flash["alert_jp"] = "ログインに成功しました。"
      flash["alert_type"] = "success"
      redirect_to root_path, success: 'ログインに成功しました'
    else
      flash.now[:failed_en] = "Mail address or password is wrong."
      flash.now[:failed_jp] = "メールアドレスかパスワードが間違っています。"
      render :index
    end
  end
  def create_auth
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.save
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to "/sessions/new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/"
  end
  private
  def log_in(user)
    reset_session
    session[:user_id] = user.id
  end

end
